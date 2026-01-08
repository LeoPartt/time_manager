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
import java.time.temporal.TemporalAdjusters;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReportsService {

    private final TeamService teamService;
    private final UserService userService;
    private final ScheduleRepository scheduleRepository;
    private final MembershipService membershipService;
    private final PlanningService planningService;

    private final OffsetDateTime oneYearAgo = ZonedDateTime.now().minusYears(1).toOffsetDateTime();

    public ReportModels.GlobalReportResponse getGlobalReports() {
        Averages averages = computeGlobalWorkAverage();
        return new ReportModels.GlobalReportResponse(
                averages.weekly,
                averages.monthly,
                computeGlobalPunctualityRate(),
                computeGlobalAttendanceRate()
        );
    }

    public ReportModels.UserReportResponse getUserReports(Long userId) {
        UserEntity user = userService.findEntityOrThrow(userId);
        Averages averages = computeUserWorkAverage(user);
        return new ReportModels.UserReportResponse(
                averages.weekly,
                averages.monthly,
                computeUserPunctualityRate(user),
                computeUserAttendanceRate(user)
        );
    }

    public ReportModels.TeamReportResponse getTeamReports(Long teamId) {
        TeamEntity team = teamService.findEntityOrThrow(teamId);
        Averages averages = computeTeamWorkAverage(team);
        return new ReportModels.TeamReportResponse(
                averages.weekly,
                averages.monthly,
                computeTeamPunctualityRate(team),
                computeTeamAttendanceRate(team)
        );
    }

    private Averages computeGlobalWorkAverage() {
        return computeAverages(scheduleRepository.findByDepartureTsIsNotNullAndArrivalTsAfter(oneYearAgo))
                .orElse(Averages.EMPTY);
    }

    private Averages computeUserWorkAverage(UserEntity user) {
        return computeAverages(scheduleRepository.findByUserAndDepartureTsIsNotNullAndArrivalTsAfter(user, oneYearAgo))
                .orElse(Averages.EMPTY);
    }

    private Averages computeTeamWorkAverage(TeamEntity team) {
        return computeAverages(
                scheduleRepository.findByUserIdInAndDepartureTsIsNotNullAndArrivalTsAfter(
                        membershipService.getMembershipsOfTeam(team)
                                .stream()
                                .map(m -> m.getUser().getId())
                                .toList(),
                        oneYearAgo))
                .orElse(Averages.EMPTY);
    }

    private float computeGlobalPunctualityRate() {
        List<UserEntity> users = userService.getAll();
        if (users.isEmpty()) return 0f;
        return (float) users.stream()
                .mapToDouble(this::computeUserPunctualityRate)
                .average()
                .orElse(0.0);
    }

    private float computeGlobalAttendanceRate() {
        return (float) userService.getAll().stream()
                .mapToDouble(this::computeUserAttendanceRate)
                .average()
                .orElse(0.0);
    }

    private float computeUserPunctualityRate(UserEntity user) {
        List<ScheduleEntity> schedules = scheduleRepository.findByUserAndArrivalTsAfter(user, oneYearAgo);
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

    private float computeUserAttendanceRate(UserEntity user) {
        List<PlanningEntity> plannings = planningService.getForUser(user);
        if (plannings.isEmpty()) return 0f;

        List<ScheduleEntity> schedules = scheduleRepository.findByUserAndArrivalTsAfter(user, oneYearAgo);
        Set<LocalDate> presentDays = schedules.stream()
                .map(s -> s.getArrivalTs().toLocalDate())
                .collect(Collectors.toSet());

        long totalExpectedDays = computeExpectedWorkingDays(plannings);
        if (totalExpectedDays == 0) return 0f;

        float attendanceRate = (float) presentDays.size() / totalExpectedDays * 100f;
        return Math.min(attendanceRate, 100f);
    }

    private float computeTeamPunctualityRate(TeamEntity team) {
        return (float) membershipService.getUsersOfTeam(team).stream()
                .mapToDouble(this::computeUserPunctualityRate)
                .average()
                .orElse(0.0);
    }

    private float computeTeamAttendanceRate(TeamEntity team) {
        return (float) membershipService.getUsersOfTeam(team).stream()
                .mapToDouble(this::computeUserAttendanceRate)
                .average()
                .orElse(0.0);
    }

    private long computeExpectedWorkingDays(List<PlanningEntity> plannings) {
        LocalDate today = LocalDate.now();
        LocalDate start = today.minusYears(1);
        Set<DayOfWeek> plannedDays = plannings.stream()
                .map(p -> DayOfWeek.of(p.getWeekDay().ordinal() + 1))
                .collect(Collectors.toSet());

        return start.datesUntil(today)
                .filter(d -> plannedDays.contains(d.getDayOfWeek()))
                .count();
    }

    private Optional<Averages> computeAverages(List<ScheduleEntity> schedules) {
        if (schedules.isEmpty())
            return Optional.empty();

        double totalHours = schedules.stream()
                .mapToDouble(s -> Duration.between(s.getArrivalTs(), s.getDepartureTs()).toHours())
                .sum();

        long weekCount = schedules.stream()
                .map(s -> s.getArrivalTs().truncatedTo(ChronoUnit.DAYS)
                        .with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY)))
                .distinct()
                .count();

        long monthCount = schedules.stream()
                .map(s -> YearMonth.from(s.getArrivalTs()))
                .distinct()
                .count();

        float weekly = weekCount == 0 ? 0 : (float) (totalHours / weekCount);
        float monthly = monthCount == 0 ? 0 : (float) (totalHours / monthCount);

        return Optional.of(new Averages(weekly, monthly));
    }

    /**
     * Internal record for reusability
     */
    private record Averages(float weekly, float monthly) {
        public static final Averages EMPTY = new Averages(0, 0);
    }
}