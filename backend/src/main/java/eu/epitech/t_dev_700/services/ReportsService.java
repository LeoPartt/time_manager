package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.entities.PlanningEntity;
import eu.epitech.t_dev_700.entities.ScheduleEntity;
import eu.epitech.t_dev_700.entities.TeamEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.models.ReportModels;
import eu.epitech.t_dev_700.repositories.ScheduleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.*;
import java.time.format.TextStyle;
import java.time.temporal.ChronoUnit;
import java.time.temporal.TemporalAdjusters;
import java.time.temporal.WeekFields;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReportsService {

    private final TeamService teamService;
    private final UserService userService;
    private final ScheduleRepository scheduleRepository;
    private final MembershipService membershipService;
    private final PlanningService planningService;

    private final ZoneId businessZone = ZoneId.of("Europe/Paris");
    private final Clock clock = Clock.systemDefaultZone();

    /* -------------------------
     * Public API
     * ------------------------- */

    public ReportModels.DashboardResponse getGlobalDashboard(ReportModels.Mode mode, OffsetDateTime at) {
        PeriodRange range = resolveRange(mode, at);

        float punctuality = computeGlobalPunctualityRate(range.from(), range.to());
        float attendance = computeGlobalAttendanceRate(range.from(), range.to());

        ReportModels.WorkSeries work = computeGlobalWorkSeries(mode, range.from(), range.to());

        return new ReportModels.DashboardResponse(
                mode,
                new ReportModels.DateRange(range.from(), range.to()),
                new ReportModels.PercentKpi(punctuality),
                new ReportModels.PercentKpi(attendance),
                work
        );
    }

    public ReportModels.UserDashboardResponse getUserDashboard(Long userId, ReportModels.Mode mode, OffsetDateTime at) {
        UserEntity user = userService.findEntityOrThrow(userId);
        PeriodRange range = resolveRange(mode, at);

        float punctuality = computeUserPunctualityRate(user, range.from(), range.to());
        float attendance = computeUserAttendanceRate(user, range.from(), range.to());

        ReportModels.WorkSeries work = computeUserWorkSeries(user, mode, range.from(), range.to());

        return new ReportModels.UserDashboardResponse(
                userId,
                new ReportModels.DashboardResponse(
                        mode,
                        new ReportModels.DateRange(range.from(), range.to()),
                        new ReportModels.PercentKpi(punctuality),
                        new ReportModels.PercentKpi(attendance),
                        work
                )
        );
    }

    public ReportModels.TeamDashboardResponse getTeamDashboard(Long teamId, ReportModels.Mode mode, OffsetDateTime at) {
        TeamEntity team = teamService.findEntityOrThrow(teamId);
        PeriodRange range = resolveRange(mode, at);

        float punctuality = computeTeamPunctualityRate(team, range.from(), range.to());
        float attendance = computeTeamAttendanceRate(team, range.from(), range.to());

        ReportModels.WorkSeries work = computeTeamWorkSeries(team, mode, range.from(), range.to());

        return new ReportModels.TeamDashboardResponse(
                teamId,
                new ReportModels.DashboardResponse(
                        mode,
                        new ReportModels.DateRange(range.from(), range.to()),
                        new ReportModels.PercentKpi(punctuality),
                        new ReportModels.PercentKpi(attendance),
                        work
                )
        );
    }

    /* -------------------------
     * Period resolution
     * ------------------------- */

    private OffsetDateTime now() {
        return OffsetDateTime.now(clock);
    }

    /**
     * Computes the "current" period for the given mode, anchored to Europe/Paris:
     * - W: ISO week (Mon 00:00 -> next Mon 00:00)
     * - M: calendar month (1st 00:00 -> 1st next month 00:00)
     * - Y: calendar year (Jan 1st 00:00 -> Jan 1st next year 00:00)
     *
     * 'at' is optional; if null => now().
     */
    private PeriodRange resolveRange(ReportModels.Mode mode, OffsetDateTime at) {
        OffsetDateTime anchor = (at != null) ? at : now();

        ZonedDateTime zdt = anchor.atZoneSameInstant(businessZone);

        return switch (mode) {
            case W -> {
                // ISO week starts Monday
                ZonedDateTime start = zdt
                        .with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY))
                        .truncatedTo(ChronoUnit.DAYS);
                ZonedDateTime end = start.plusWeeks(1);
                yield new PeriodRange(start.toOffsetDateTime(), end.toOffsetDateTime());
            }
            case M -> {
                ZonedDateTime start = zdt.withDayOfMonth(1).truncatedTo(ChronoUnit.DAYS);
                ZonedDateTime end = start.plusMonths(1);
                yield new PeriodRange(start.toOffsetDateTime(), end.toOffsetDateTime());
            }
            case Y -> {
                ZonedDateTime start = zdt.withDayOfYear(1).truncatedTo(ChronoUnit.DAYS);
                ZonedDateTime end = start.plusYears(1);
                yield new PeriodRange(start.toOffsetDateTime(), end.toOffsetDateTime());
            }
        };
    }

    private record PeriodRange(OffsetDateTime from, OffsetDateTime to) {
        PeriodRange {
            if (from == null || to == null) throw new IllegalArgumentException("Range bounds must not be null");
            if (!from.isBefore(to)) throw new IllegalArgumentException("Range 'from' must be strictly before 'to'");
        }
    }

    /* -------------------------
     * Work series (bucketed)
     * ------------------------- */

    private ReportModels.WorkSeries computeGlobalWorkSeries(ReportModels.Mode mode, OffsetDateTime from, OffsetDateTime to) {
        List<ScheduleEntity> schedules =
                scheduleRepository.findByDepartureTsIsNotNullAndArrivalTsBetween(from, to);
        return bucketWork(mode, from, to, schedules);
    }

    private ReportModels.WorkSeries computeUserWorkSeries(UserEntity user, ReportModels.Mode mode, OffsetDateTime from, OffsetDateTime to) {
        List<ScheduleEntity> schedules =
                scheduleRepository.findByUserAndDepartureTsIsNotNullAndArrivalTsBetween(user, from, to);
        return bucketWork(mode, from, to, schedules);
    }

    private ReportModels.WorkSeries computeTeamWorkSeries(TeamEntity team, ReportModels.Mode mode, OffsetDateTime from, OffsetDateTime to) {
        List<Long> userIds = membershipService.getMembershipsOfTeam(team).stream()
                .map(m -> m.getUser().getId())
                .toList();
        if (userIds.isEmpty()) {
            return ReportModels.WorkSeries.empty(bucketForMode(mode));
        }

        List<ScheduleEntity> schedules =
                scheduleRepository.findByUserIdInAndDepartureTsIsNotNullAndArrivalTsBetween(userIds, from, to);

        return bucketWork(mode, from, to, schedules);
    }

    private ReportModels.WorkBucket bucketForMode(ReportModels.Mode mode) {
        return switch (mode) {
            case W -> ReportModels.WorkBucket.DAY;
            case M -> ReportModels.WorkBucket.WEEK;
            case Y -> ReportModels.WorkBucket.MONTH;
        };
    }

    private ReportModels.WorkSeries bucketWork(
            ReportModels.Mode mode,
            OffsetDateTime from,
            OffsetDateTime to,
            List<ScheduleEntity> schedules
    ) {
        ReportModels.WorkBucket bucket = bucketForMode(mode);

        if (schedules.isEmpty()) {
            return ReportModels.WorkSeries.empty(bucket);
        }

        // ---- total hours over the period ----
        double totalHours = schedules.stream()
                                    .mapToLong(s -> Duration.between(s.getArrivalTs(), s.getDepartureTs()).toMinutes())
                                    .sum() / 60.0;

        // ---- compute average (first-class KPI) ----
        float average = computeAverage(mode, schedules, totalHours);

        // ---- bucket for chart ----
        Map<BucketKey, Double> hoursByBucket = new HashMap<>();
        for (ScheduleEntity s : schedules) {
            BucketKey key = bucketKey(bucket, s.getArrivalTs());
            double hours = Duration.between(s.getArrivalTs(), s.getDepartureTs()).toMinutes() / 60.0;
            hoursByBucket.merge(key, hours, Double::sum);
        }

        List<ReportModels.WorkPoint> points = hoursByBucket.entrySet().stream()
                .sorted(Comparator.comparing(e -> e.getKey().start))
                .map(e -> new ReportModels.WorkPoint(
                        e.getKey().label,
                        e.getKey().start,
                        (float) (double) e.getValue()
                ))
                .toList();

        return new ReportModels.WorkSeries("hours", bucket, points, average);
    }

    private float computeAverage(
            ReportModels.Mode mode,
            List<ScheduleEntity> schedules,
            double totalHours
    ) {
        switch (mode) {
            case W -> {
                long workedDays = schedules.stream()
                        .map(s -> s.getArrivalTs()
                                .atZoneSameInstant(businessZone)
                                .toLocalDate())
                        .distinct()
                        .count();
                return workedDays == 0 ? 0f : (float) (totalHours / workedDays);
            }

            case M -> {
                WeekFields wf = WeekFields.ISO;
                long workedWeeks = schedules.stream()
                        .map(s -> {
                            LocalDate d = s.getArrivalTs()
                                    .atZoneSameInstant(businessZone)
                                    .toLocalDate();
                            return d.get(wf.weekBasedYear()) + "-" + d.get(wf.weekOfWeekBasedYear());
                        })
                        .distinct()
                        .count();
                return workedWeeks == 0 ? 0f : (float) (totalHours / workedWeeks);
            }

            case Y -> {
                long workedMonths = schedules.stream()
                        .map(s -> YearMonth.from(
                                s.getArrivalTs().atZoneSameInstant(businessZone)))
                        .distinct()
                        .count();
                return workedMonths == 0 ? 0f : (float) (totalHours / workedMonths);
            }
        }
        return 0f;
    }

    private BucketKey bucketKey(ReportModels.WorkBucket bucket, OffsetDateTime ts) {
        ZonedDateTime z = ts.atZoneSameInstant(businessZone);

        return switch (bucket) {
            case DAY -> {
                ZonedDateTime start = z.truncatedTo(ChronoUnit.DAYS);
                String label = z.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.ENGLISH); // Mon/Tue...
                yield new BucketKey(start.toOffsetDateTime(), label);
            }
            case WEEK -> {
                // ISO week start (Monday), label "W<weekOfYear>"
                ZonedDateTime start = z.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY)).truncatedTo(ChronoUnit.DAYS);
                WeekFields wf = WeekFields.ISO;
                int week = start.toLocalDate().get(wf.weekOfWeekBasedYear());
                String label = "W" + week;
                yield new BucketKey(start.toOffsetDateTime(), label);
            }
            case MONTH -> {
                ZonedDateTime start = z.withDayOfMonth(1).truncatedTo(ChronoUnit.DAYS);
                String label = z.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH); // Jan/Feb...
                yield new BucketKey(start.toOffsetDateTime(), label);
            }
        };
    }

    private record BucketKey(OffsetDateTime start, String label) {}

    /* -------------------------
     * Punctuality (percent on period)
     * ------------------------- */

    private float computeGlobalPunctualityRate(OffsetDateTime from, OffsetDateTime to) {
        List<UserEntity> users = userService.getAll();
        if (users.isEmpty()) return 0f;
        return average(users.stream().map(u -> computeUserPunctualityRate(u, from, to)));
    }

    private float computeTeamPunctualityRate(TeamEntity team, OffsetDateTime from, OffsetDateTime to) {
        List<UserEntity> users = membershipService.getUsersOfTeam(team);
        if (users.isEmpty()) return 0f;
        return average(users.stream().map(u -> computeUserPunctualityRate(u, from, to)));
    }

    private float computeUserPunctualityRate(UserEntity user, OffsetDateTime from, OffsetDateTime to) {
        List<ScheduleEntity> schedules = scheduleRepository.findByUserAndArrivalTsBetween(user, from, to);
        if (schedules.isEmpty()) return 0f;

        Map<DayOfWeek, LocalTime> plannedStartTimes = planningService.getForUser(user).stream()
                .collect(Collectors.toMap(
                        p -> DayOfWeek.of(p.getWeekDay().ordinal() + 1),
                        PlanningEntity::getStartTime,
                        (a, b) -> a
                ));

        long onTimeCount = schedules.stream()
                .filter(s -> {
                    ZonedDateTime arrivalZ = s.getArrivalTs().atZoneSameInstant(businessZone);
                    LocalTime expectedStart = plannedStartTimes.get(arrivalZ.getDayOfWeek());
                    return expectedStart != null && !arrivalZ.toLocalTime().isAfter(expectedStart);
                })
                .count();

        return (float) onTimeCount / schedules.size() * 100f;
    }

    /* -------------------------
     * Attendance (percent on period)
     * ------------------------- */

    private float computeGlobalAttendanceRate(OffsetDateTime from, OffsetDateTime to) {
        List<UserEntity> users = userService.getAll();
        if (users.isEmpty()) return 0f;
        return average(users.stream().map(u -> computeUserAttendanceRate(u, from, to)));
    }

    private float computeTeamAttendanceRate(TeamEntity team, OffsetDateTime from, OffsetDateTime to) {
        List<UserEntity> users = membershipService.getUsersOfTeam(team);
        if (users.isEmpty()) return 0f;
        return average(users.stream().map(u -> computeUserAttendanceRate(u, from, to)));
    }

    private float computeUserAttendanceRate(UserEntity user, OffsetDateTime from, OffsetDateTime to) {
        List<PlanningEntity> plannings = planningService.getForUser(user);
        if (plannings.isEmpty()) return 0f;

        List<ScheduleEntity> schedules = scheduleRepository.findByUserAndArrivalTsBetween(user, from, to);

        // We consider presence by distinct local dates (business timezone)
        Set<LocalDate> presentDays = schedules.stream()
                .map(s -> s.getArrivalTs().atZoneSameInstant(businessZone).toLocalDate())
                .collect(Collectors.toSet());

        long expectedDays = computeExpectedWorkingDays(plannings,
                from.atZoneSameInstant(businessZone).toLocalDate(),
                to.atZoneSameInstant(businessZone).toLocalDate());

        if (expectedDays == 0) return 0f;

        float rate = (float) presentDays.size() / expectedDays * 100f;
        return Math.min(rate, 100f);
    }

    private long computeExpectedWorkingDays(List<PlanningEntity> plannings, LocalDate startInclusive, LocalDate endExclusive) {
        Set<DayOfWeek> plannedDays = plannings.stream()
                .map(p -> DayOfWeek.of(p.getWeekDay().ordinal() + 1))
                .collect(Collectors.toSet());

        return startInclusive.datesUntil(endExclusive)
                .filter(d -> plannedDays.contains(d.getDayOfWeek()))
                .count();
    }

    /* -------------------------
     * Small helper
     * ------------------------- */

    private float average(java.util.stream.Stream<Float> stream) {
        DoubleSummaryStatistics stats = new DoubleSummaryStatistics();
        stream.forEach(stats::accept);
        return stats.getCount() == 0 ? 0f : (float) stats.getAverage();
    }
}
