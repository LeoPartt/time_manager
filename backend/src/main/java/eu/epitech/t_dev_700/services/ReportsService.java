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
import java.time.temporal.ChronoUnit;
import java.time.temporal.WeekFields;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;


@Service
@RequiredArgsConstructor
public class ReportsService {

    private final TeamService teamService;
    private final UserService userService;
    private final ScheduleRepository scheduleRepository;
    private final MembershipService membershipService;
    private final PlanningService planningService;

    private final Clock clock = Clock.systemDefaultZone();

    public ReportModels.GlobalReportResponse getGlobalReports() {
        ReportModels.Report averages = computeGlobalWorkAverages();
        ReportModels.Report punctuality = computeGlobalPunctualityRates();
        ReportModels.Report attendance = computeGlobalAttendanceRates();

        return new ReportModels.GlobalReportResponse(
                averages,
                punctuality,
                attendance
        );
    }

    public ReportModels.UserReportResponse getUserReports(Long userId) {
        UserEntity user = userService.findEntityOrThrow(userId);

        ReportModels.Report averages = computeUserWorkAverages(user);
        ReportModels.Report punctuality = computeUserPunctualityRates(user);
        ReportModels.Report attendance = computeUserAttendanceRates(user);

        return new ReportModels.UserReportResponse(
                userId,
                averages,
                punctuality,
                attendance
        );
    }

    public ReportModels.TeamReportResponse getTeamReports(Long teamId) {
        TeamEntity team = teamService.findEntityOrThrow(teamId);

        ReportModels.Report averages = computeTeamWorkAverages(team);
        ReportModels.Report punctuality = computeTeamPunctualityRates(team);
        ReportModels.Report attendance = computeTeamAttendanceRates(team);

        return new ReportModels.TeamReportResponse(
                teamId,
                averages,
                punctuality,
                attendance
        );
    }

    /* -------------------------
     * Time windows helpers
     * ------------------------- */

    private OffsetDateTime now() {
        return OffsetDateTime.now(clock);
    }

    private OffsetDateTime weekFrom(OffsetDateTime now) {
        // Rolling last 7 days (simple, timezone-safe enough for KPI)
        return now.minusDays(7);
    }

    private OffsetDateTime monthFrom(OffsetDateTime now) {
        // From first day of current month (local offset)
        return now.withDayOfMonth(1).truncatedTo(ChronoUnit.DAYS);
    }

    private OffsetDateTime yearFrom(OffsetDateTime now) {
        return now.minusYears(1);
    }

    /* -------------------------
     * Work averages (hours)
     * ------------------------- */

    private ReportModels.Report computeGlobalWorkAverages() {
        OffsetDateTime n = now();
        return computeWorkAveragesForRange(yearFrom(n), n,
                scheduleRepository.findByDepartureTsIsNotNullAndArrivalTsBetween(yearFrom(n), n))
                .orElse(ReportModels.Report.EMPTY);
    }

    private ReportModels.Report computeUserWorkAverages(UserEntity user) {
        OffsetDateTime n = now();
        return computeWorkAveragesForRange(yearFrom(n), n,
                scheduleRepository.findByUserAndDepartureTsIsNotNullAndArrivalTsBetween(user, yearFrom(n), n))
                .orElse(ReportModels.Report.EMPTY);
    }

    private ReportModels.Report computeTeamWorkAverages(TeamEntity team) {
        OffsetDateTime n = now();
        List<Long> userIds = membershipService.getMembershipsOfTeam(team).stream()
                .map(m -> m.getUser().getId())
                .toList();

        return computeWorkAveragesForRange(yearFrom(n), n,
                scheduleRepository.findByUserIdInAndDepartureTsIsNotNullAndArrivalTsBetween(userIds, yearFrom(n), n))
                .orElse(ReportModels.Report.EMPTY);
    }

    /**
     * Computes:
     * - weekly average = totalHours / number of distinct ISO weeks in the range that have work
     * - monthly average = totalHours / number of distinct months in the range that have work
     * - yearly average = totalHours (over the range)  (or totalHours / 1 if you prefer)
     */
    private Optional<ReportModels.Report> computeWorkAveragesForRange(OffsetDateTime from, OffsetDateTime to, List<ScheduleEntity> schedules) {
        if (schedules.isEmpty()) return Optional.empty();

        double totalHours = schedules.stream()
                                    .mapToLong(s -> Duration.between(s.getArrivalTs(), s.getDepartureTs()).toMinutes())
                                    .sum() / 60.0;

        WeekFields wf = WeekFields.ISO;
        long weekCount = schedules.stream()
                .map(s -> s.getArrivalTs().toLocalDate())
                .map(d -> d.get(wf.weekBasedYear()) + "-" + d.get(wf.weekOfWeekBasedYear()))
                .distinct()
                .count();

        long monthCount = schedules.stream()
                .map(s -> YearMonth.from(s.getArrivalTs()))
                .distinct()
                .count();

        float weekly = weekCount == 0 ? 0f : (float) (totalHours / weekCount);
        float monthly = monthCount == 0 ? 0f : (float) (totalHours / monthCount);
        float yearly = (float) totalHours;

        return Optional.of(new ReportModels.Report(weekly, monthly, yearly));
    }

    private ReportModels.Report computeGlobalPunctualityRates() {
        List<UserEntity> users = userService.getAll();
        if (users.isEmpty()) return ReportModels.Report.EMPTY;

        return averageRates(users.stream().map(this::computeUserPunctualityRates));
    }

    private ReportModels.Report computeTeamPunctualityRates(TeamEntity team) {
        List<UserEntity> users = membershipService.getUsersOfTeam(team);
        if (users.isEmpty()) return ReportModels.Report.EMPTY;

        return averageRates(users.stream().map(this::computeUserPunctualityRates));
    }

    private ReportModels.Report computeUserPunctualityRates(UserEntity user) {
        OffsetDateTime n = now();
        OffsetDateTime wFrom = weekFrom(n);
        OffsetDateTime mFrom = monthFrom(n);
        OffsetDateTime yFrom = yearFrom(n);

        return new ReportModels.Report(
                computeUserPunctualityRate(user, wFrom, n),
                computeUserPunctualityRate(user, mFrom, n),
                computeUserPunctualityRate(user, yFrom, n)
        );
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
                    LocalDateTime arrival = s.getArrivalTs().toLocalDateTime();
                    LocalTime expectedStart = plannedStartTimes.get(arrival.getDayOfWeek());
                    return expectedStart != null && !arrival.toLocalTime().isAfter(expectedStart);
                })
                .count();

        return (float) onTimeCount / schedules.size() * 100f;
    }

    /* -------------------------
     * Attendance rates
     * ------------------------- */

    private ReportModels.Report computeGlobalAttendanceRates() {
        List<UserEntity> users = userService.getAll();
        if (users.isEmpty()) return ReportModels.Report.EMPTY;

        return averageRates(users.stream().map(this::computeUserAttendanceRates));
    }

    private ReportModels.Report computeTeamAttendanceRates(TeamEntity team) {
        List<UserEntity> users = membershipService.getUsersOfTeam(team);
        if (users.isEmpty()) return ReportModels.Report.EMPTY;

        return averageRates(users.stream().map(this::computeUserAttendanceRates));
    }

    private ReportModels.Report computeUserAttendanceRates(UserEntity user) {
        OffsetDateTime n = now();
        OffsetDateTime wFrom = weekFrom(n);
        OffsetDateTime mFrom = monthFrom(n);
        OffsetDateTime yFrom = yearFrom(n);

        return new ReportModels.Report(
                computeUserAttendanceRate(user, wFrom, n),
                computeUserAttendanceRate(user, mFrom, n),
                computeUserAttendanceRate(user, yFrom, n)
        );
    }

    private float computeUserAttendanceRate(UserEntity user, OffsetDateTime from, OffsetDateTime to) {
        List<PlanningEntity> plannings = planningService.getForUser(user);
        if (plannings.isEmpty()) return 0f;

        List<ScheduleEntity> schedules = scheduleRepository.findByUserAndArrivalTsBetween(user, from, to);
        Set<LocalDate> presentDays = schedules.stream()
                .map(s -> s.getArrivalTs().toLocalDate())
                .collect(Collectors.toSet());

        long expectedDays = computeExpectedWorkingDays(plannings, from.toLocalDate(), to.toLocalDate());
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
     * Small helpers
     * ------------------------- */

    private ReportModels.Report averageRates(Stream<ReportModels.Report> ratesStream) {
        DoubleSummaryStatistics w = new DoubleSummaryStatistics();
        DoubleSummaryStatistics m = new DoubleSummaryStatistics();
        DoubleSummaryStatistics y = new DoubleSummaryStatistics();

        ratesStream.forEach(r -> {
            w.accept(r.weekly());
            m.accept(r.monthly());
            y.accept(r.yearly());
        });

        if (w.getCount() == 0) return ReportModels.Report.EMPTY;

        return new ReportModels.Report(
                (float) w.getAverage(),
                (float) m.getAverage(),
                (float) y.getAverage()
        );
    }

}