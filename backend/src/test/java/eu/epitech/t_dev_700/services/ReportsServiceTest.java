package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.entities.*;
import eu.epitech.t_dev_700.models.ReportModels;
import eu.epitech.t_dev_700.repositories.ScheduleRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ReportsServiceTest {

    private TeamService teamService;
    private UserService userService;
    private ScheduleRepository scheduleRepository;
    private MembershipService membershipService;
    private PlanningService planningService;

    private ReportsService reportsService;

    @BeforeEach
    void setUp() {
        teamService = mock(TeamService.class);
        userService = mock(UserService.class);
        scheduleRepository = mock(ScheduleRepository.class);
        membershipService = mock(MembershipService.class);
        planningService = mock(PlanningService.class);

        reportsService = new ReportsService(
                teamService,
                userService,
                scheduleRepository,
                membershipService,
                planningService
        );
    }

    @Test
    void globalDashboard_week_shouldResolveIsoWeekRangeInParis_andReturnEmptyWorkWhenNoSchedules() {
        // Wed 2026-01-07 12:00 UTC -> Paris +01:00
        OffsetDateTime anchorUtc = OffsetDateTime.of(2026, 1, 7, 12, 0, 0, 0, ZoneOffset.UTC);

        when(userService.getAll()).thenReturn(List.of()); // KPIs -> 0
        when(scheduleRepository.findByDepartureTsIsNotNullAndArrivalTsBetween(any(), any()))
                .thenReturn(List.of()); // Work -> empty

        ReportModels.DashboardResponse res = reportsService.getGlobalDashboard(ReportModels.Mode.W, anchorUtc);

        assertThat(res.range().from()).isEqualTo(OffsetDateTime.parse("2026-01-05T00:00:00+01:00"));
        assertThat(res.range().to()).isEqualTo(OffsetDateTime.parse("2026-01-12T00:00:00+01:00"));

        assertThat(res.work().bucket()).isEqualTo(ReportModels.WorkBucket.DAY);
        assertThat(res.work().series()).isEmpty();
        assertThat(res.work().average()).isEqualTo(0f);

        assertThat(res.punctuality().percent()).isEqualTo(0f);
        assertThat(res.attendance().percent()).isEqualTo(0f);
    }

    @Test
    void userDashboard_month_shouldBucketByIsoWeek_andComputeAverageHoursPerWorkedWeek_and100Punctuality() {
        long userId = 42L;
        UserEntity user = mock(UserEntity.class);
        when(userService.findEntityOrThrow(userId)).thenReturn(user);

        OffsetDateTime anchorUtc = OffsetDateTime.of(2026, 2, 10, 12, 0, 0, 0, ZoneOffset.UTC);

        when(planningService.getForUser(user)).thenReturn(List.of(
                planning(PlanningEntity.WeekDay.MONDAY, LocalTime.of(9, 0)),
                planning(PlanningEntity.WeekDay.TUESDAY, LocalTime.of(9, 0)),
                planning(PlanningEntity.WeekDay.WEDNESDAY, LocalTime.of(9, 0)),
                planning(PlanningEntity.WeekDay.THURSDAY, LocalTime.of(9, 0)),
                planning(PlanningEntity.WeekDay.FRIDAY, LocalTime.of(9, 0))
        ));

        // Two days same ISO week => WorkSeries (bucket WEEK) should aggregate to 1 point: 16h
        ScheduleEntity s1 = schedule(user,
                OffsetDateTime.parse("2026-02-02T09:00:00+01:00"),
                OffsetDateTime.parse("2026-02-02T17:00:00+01:00")
        );
        ScheduleEntity s2 = schedule(user,
                OffsetDateTime.parse("2026-02-03T09:00:00+01:00"),
                OffsetDateTime.parse("2026-02-03T17:00:00+01:00")
        );

        when(scheduleRepository.findByUserAndArrivalTsBetween(eq(user), any(), any()))
                .thenReturn(List.of(s1, s2));

        when(scheduleRepository.findByUserAndDepartureTsIsNotNullAndArrivalTsBetween(eq(user), any(), any()))
                .thenReturn(List.of(s1, s2));

        ReportModels.UserDashboardResponse res =
                reportsService.getUserDashboard(userId, ReportModels.Mode.M, anchorUtc);

        ReportModels.DashboardResponse dash = res.dashboard();

        assertThat(res.userId()).isEqualTo(userId);

        assertThat(dash.work().bucket()).isEqualTo(ReportModels.WorkBucket.WEEK);
        assertThat(dash.work().series()).hasSize(1);
        assertThat(dash.work().series().get(0).value()).isEqualTo(16.0f);
        assertThat(dash.work().average()).isEqualTo(16.0f);

        // punctuality: arrival at 09:00 and expected 09:00 => on time => 100%
        assertThat(dash.punctuality().percent()).isEqualTo(100.0f);

        // attendance depends on expected business days in the month range, just ensure sane bounds
        assertThat(dash.attendance().percent()).isGreaterThan(0f);
        assertThat(dash.attendance().percent()).isLessThanOrEqualTo(100f);
    }

    @Test
    void teamDashboard_year_whenNoMembers_shouldReturnEmptySeriesAndZeroKpis() {
        long teamId = 7L;
        TeamEntity team = mock(TeamEntity.class);
        when(teamService.findEntityOrThrow(teamId)).thenReturn(team);

        when(membershipService.getMembershipsOfTeam(team)).thenReturn(List.of());
        when(membershipService.getUsersOfTeam(team)).thenReturn(List.of());

        OffsetDateTime anchorUtc = OffsetDateTime.of(2026, 6, 15, 12, 0, 0, 0, ZoneOffset.UTC);

        ReportModels.TeamDashboardResponse res =
                reportsService.getTeamDashboard(teamId, ReportModels.Mode.Y, anchorUtc);

        ReportModels.DashboardResponse dash = res.dashboard();

        assertThat(res.teamId()).isEqualTo(teamId);
        assertThat(dash.punctuality().percent()).isEqualTo(0f);
        assertThat(dash.attendance().percent()).isEqualTo(0f);

        assertThat(dash.work().bucket()).isEqualTo(ReportModels.WorkBucket.MONTH);
        assertThat(dash.work().series()).isEmpty();
        assertThat(dash.work().average()).isEqualTo(0f);
    }

    @Test
    void teamDashboard_week_shouldUseMembershipUserIdsForWorkSeriesQuery() {
        long teamId = 99L;
        TeamEntity team = mock(TeamEntity.class);
        when(teamService.findEntityOrThrow(teamId)).thenReturn(team);

        UserEntity u1 = mock(UserEntity.class);
        when(u1.getId()).thenReturn(1L);
        UserEntity u2 = mock(UserEntity.class);
        when(u2.getId()).thenReturn(2L);

        MembershipEntity m1 = new MembershipEntity(u1, team, MembershipEntity.TeamRole.MEMBER);
        MembershipEntity m2 = new MembershipEntity(u2, team, MembershipEntity.TeamRole.MEMBER);

        when(membershipService.getMembershipsOfTeam(team)).thenReturn(List.of(m1, m2));

        // KPIs: make them 0 by giving no planning
        when(membershipService.getUsersOfTeam(team)).thenReturn(List.of(u1, u2));
        when(planningService.getForUser(any())).thenReturn(List.of());
        when(scheduleRepository.findByUserAndArrivalTsBetween(any(UserEntity.class), any(), any()))
                .thenReturn(List.of());

        ScheduleEntity s1 = schedule(u1,
                OffsetDateTime.parse("2026-01-05T09:00:00+01:00"),
                OffsetDateTime.parse("2026-01-05T17:00:00+01:00")
        );

        when(scheduleRepository.findByUserIdInAndDepartureTsIsNotNullAndArrivalTsBetween(
                eq(List.of(1L, 2L)), any(), any()
        )).thenReturn(List.of(s1));

        OffsetDateTime anchorUtc = OffsetDateTime.of(2026, 1, 6, 12, 0, 0, 0, ZoneOffset.UTC);

        ReportModels.TeamDashboardResponse res =
                reportsService.getTeamDashboard(teamId, ReportModels.Mode.W, anchorUtc);

        assertThat(res.dashboard().work().bucket()).isEqualTo(ReportModels.WorkBucket.DAY);
        assertThat(res.dashboard().work().series()).hasSize(1);
        assertThat(res.dashboard().work().series().get(0).value()).isEqualTo(8.0f);
        assertThat(res.dashboard().work().average()).isEqualTo(8.0f);

        verify(scheduleRepository).findByUserIdInAndDepartureTsIsNotNullAndArrivalTsBetween(
                eq(List.of(1L, 2L)), any(), any()
        );
    }

    @Test
    void globalDashboard_month_shouldResolveCalendarMonthRangeInParis() {
        // 2026-02-10 12:00 UTC => 13:00 Paris
        OffsetDateTime anchorUtc = OffsetDateTime.of(2026, 2, 10, 12, 0, 0, 0, ZoneOffset.UTC);

        when(userService.getAll()).thenReturn(List.of());
        when(scheduleRepository.findByDepartureTsIsNotNullAndArrivalTsBetween(any(), any()))
                .thenReturn(List.of());

        ReportModels.DashboardResponse res = reportsService.getGlobalDashboard(ReportModels.Mode.M, anchorUtc);

        assertThat(res.range().from()).isEqualTo(OffsetDateTime.parse("2026-02-01T00:00:00+01:00"));
        assertThat(res.range().to()).isEqualTo(OffsetDateTime.parse("2026-03-01T00:00:00+01:00"));
        assertThat(res.work().bucket()).isEqualTo(ReportModels.WorkBucket.WEEK);
    }

    @Test
    void globalDashboard_year_shouldResolveCalendarYearRangeInParis() {
        OffsetDateTime anchorUtc = OffsetDateTime.of(2026, 6, 15, 12, 0, 0, 0, ZoneOffset.UTC);

        when(userService.getAll()).thenReturn(List.of());
        when(scheduleRepository.findByDepartureTsIsNotNullAndArrivalTsBetween(any(), any()))
                .thenReturn(List.of());

        ReportModels.DashboardResponse res = reportsService.getGlobalDashboard(ReportModels.Mode.Y, anchorUtc);

        assertThat(res.range().from()).isEqualTo(OffsetDateTime.parse("2026-01-01T00:00:00+01:00"));
        assertThat(res.range().to()).isEqualTo(OffsetDateTime.parse("2027-01-01T00:00:00+01:00"));
        assertThat(res.work().bucket()).isEqualTo(ReportModels.WorkBucket.MONTH);
    }

    @Test
    void userDashboard_week_whenLate_shouldComputeZeroPunctuality() {
        long userId = 1L;
        UserEntity user = mock(UserEntity.class);
        when(userService.findEntityOrThrow(userId)).thenReturn(user);

        OffsetDateTime anchorUtc = OffsetDateTime.of(2026, 1, 7, 12, 0, 0, 0, ZoneOffset.UTC);

        when(planningService.getForUser(user)).thenReturn(List.of(
                planning(PlanningEntity.WeekDay.WEDNESDAY, LocalTime.of(9, 0))
        ));

        // Arrive at 09:10 (late) on Wednesday
        ScheduleEntity s = schedule(user,
                OffsetDateTime.parse("2026-01-07T09:10:00+01:00"),
                OffsetDateTime.parse("2026-01-07T17:10:00+01:00")
        );

        when(scheduleRepository.findByUserAndArrivalTsBetween(eq(user), any(), any()))
                .thenReturn(List.of(s));
        when(scheduleRepository.findByUserAndDepartureTsIsNotNullAndArrivalTsBetween(eq(user), any(), any()))
                .thenReturn(List.of(s));

        ReportModels.UserDashboardResponse res =
                reportsService.getUserDashboard(userId, ReportModels.Mode.W, anchorUtc);

        assertThat(res.dashboard().punctuality().percent()).isEqualTo(0f);
    }

    @Test
    void userDashboard_week_whenNoPlanningForDay_shouldComputeZeroPunctuality() {
        long userId = 1L;
        UserEntity user = mock(UserEntity.class);
        when(userService.findEntityOrThrow(userId)).thenReturn(user);

        OffsetDateTime anchorUtc = OffsetDateTime.of(2026, 1, 7, 12, 0, 0, 0, ZoneOffset.UTC);

        // Planning only Monday (but schedule is Wednesday)
        when(planningService.getForUser(user)).thenReturn(List.of(
                planning(PlanningEntity.WeekDay.MONDAY, LocalTime.of(9, 0))
        ));

        ScheduleEntity s = schedule(user,
                OffsetDateTime.parse("2026-01-07T09:00:00+01:00"),
                OffsetDateTime.parse("2026-01-07T17:00:00+01:00")
        );

        when(scheduleRepository.findByUserAndArrivalTsBetween(eq(user), any(), any()))
                .thenReturn(List.of(s));
        when(scheduleRepository.findByUserAndDepartureTsIsNotNullAndArrivalTsBetween(eq(user), any(), any()))
                .thenReturn(List.of(s));

        ReportModels.UserDashboardResponse res =
                reportsService.getUserDashboard(userId, ReportModels.Mode.W, anchorUtc);

        assertThat(res.dashboard().punctuality().percent()).isEqualTo(0f);
    }

    @Test
    void userDashboard_week_whenNoPlannings_shouldReturnZeroAttendance() {
        long userId = 1L;
        UserEntity user = mock(UserEntity.class);
        when(userService.findEntityOrThrow(userId)).thenReturn(user);

        OffsetDateTime anchorUtc = OffsetDateTime.of(2026, 1, 7, 12, 0, 0, 0, ZoneOffset.UTC);

        when(planningService.getForUser(user)).thenReturn(List.of()); // triggers plannings.isEmpty()

        // schedules don’t matter, but keep it simple
        when(scheduleRepository.findByUserAndArrivalTsBetween(eq(user), any(), any()))
                .thenReturn(List.of());

        when(scheduleRepository.findByUserAndDepartureTsIsNotNullAndArrivalTsBetween(eq(user), any(), any()))
                .thenReturn(List.of());

        ReportModels.UserDashboardResponse res =
                reportsService.getUserDashboard(userId, ReportModels.Mode.W, anchorUtc);

        assertThat(res.dashboard().attendance().percent()).isEqualTo(0f);
    }

    @Test
    void userDashboard_week_attendance_shouldCapAt100Percent() {
        long userId = 1L;
        UserEntity user = mock(UserEntity.class);
        when(userService.findEntityOrThrow(userId)).thenReturn(user);

        OffsetDateTime anchorUtc = OffsetDateTime.of(2026, 1, 7, 12, 0, 0, 0, ZoneOffset.UTC);

        // Only Monday is expected
        when(planningService.getForUser(user)).thenReturn(List.of(
                planning(PlanningEntity.WeekDay.MONDAY, LocalTime.of(9, 0))
        ));

        ScheduleEntity mon = schedule(user,
                OffsetDateTime.parse("2026-01-05T09:00:00+01:00"),
                OffsetDateTime.parse("2026-01-05T17:00:00+01:00")
        );
        ScheduleEntity tue = schedule(user,
                OffsetDateTime.parse("2026-01-06T09:00:00+01:00"),
                OffsetDateTime.parse("2026-01-06T17:00:00+01:00")
        );
        ScheduleEntity wed = schedule(user,
                OffsetDateTime.parse("2026-01-07T09:00:00+01:00"),
                OffsetDateTime.parse("2026-01-07T17:00:00+01:00")
        );

        when(scheduleRepository.findByUserAndArrivalTsBetween(eq(user), any(), any()))
                .thenReturn(List.of(mon, tue, wed));

        when(scheduleRepository.findByUserAndDepartureTsIsNotNullAndArrivalTsBetween(eq(user), any(), any()))
                .thenReturn(List.of(mon, tue, wed));

        ReportModels.UserDashboardResponse res =
                reportsService.getUserDashboard(userId, ReportModels.Mode.W, anchorUtc);

        assertThat(res.dashboard().attendance().percent()).isEqualTo(100f);
    }

    @Test
    void userDashboard_week_shouldComputeAverageHoursPerWorkedDay() {
        long userId = 1L;
        UserEntity user = mock(UserEntity.class);
        when(userService.findEntityOrThrow(userId)).thenReturn(user);

        OffsetDateTime at = OffsetDateTime.of(2026, 1, 7, 12, 0, 0, 0, ZoneOffset.UTC);

        when(planningService.getForUser(user)).thenReturn(List.of(
                planning(PlanningEntity.WeekDay.MONDAY, LocalTime.of(9, 0)),
                planning(PlanningEntity.WeekDay.TUESDAY, LocalTime.of(9, 0))
        ));

        // total=12h, workedDays=2 => average=6
        ScheduleEntity s1 = schedule(user,
                OffsetDateTime.parse("2026-01-05T09:00:00+01:00"),
                OffsetDateTime.parse("2026-01-05T17:00:00+01:00"));
        ScheduleEntity s2 = schedule(user,
                OffsetDateTime.parse("2026-01-06T09:00:00+01:00"),
                OffsetDateTime.parse("2026-01-06T13:00:00+01:00"));

        when(scheduleRepository.findByUserAndArrivalTsBetween(eq(user), any(), any()))
                .thenReturn(List.of(s1, s2));
        when(scheduleRepository.findByUserAndDepartureTsIsNotNullAndArrivalTsBetween(eq(user), any(), any()))
                .thenReturn(List.of(s1, s2));

        var res = reportsService.getUserDashboard(userId, ReportModels.Mode.W, at);
        assertThat(res.dashboard().work().average()).isEqualTo(6.0f);
    }

    @Test
    void userDashboard_year_shouldComputeAverageHoursPerWorkedMonth() {
        long userId = 1L;
        UserEntity user = mock(UserEntity.class);
        when(userService.findEntityOrThrow(userId)).thenReturn(user);

        OffsetDateTime at = OffsetDateTime.of(2026, 6, 15, 12, 0, 0, 0, ZoneOffset.UTC);

        when(planningService.getForUser(user)).thenReturn(List.of(
                planning(PlanningEntity.WeekDay.MONDAY, LocalTime.of(9, 0))
        ));

        // 8h in Jan + 4h in Feb => total=12h, workedMonths=2 => average=6
        ScheduleEntity jan = schedule(user,
                OffsetDateTime.parse("2026-01-05T09:00:00+01:00"),
                OffsetDateTime.parse("2026-01-05T17:00:00+01:00"));
        ScheduleEntity feb = schedule(user,
                OffsetDateTime.parse("2026-02-02T09:00:00+01:00"),
                OffsetDateTime.parse("2026-02-02T13:00:00+01:00"));

        when(scheduleRepository.findByUserAndArrivalTsBetween(eq(user), any(), any()))
                .thenReturn(List.of(jan, feb));
        when(scheduleRepository.findByUserAndDepartureTsIsNotNullAndArrivalTsBetween(eq(user), any(), any()))
                .thenReturn(List.of(jan, feb));

        var res = reportsService.getUserDashboard(userId, ReportModels.Mode.Y, at);
        assertThat(res.dashboard().work().average()).isEqualTo(6.0f);
    }

    @Test
    void globalDashboard_whenAtNull_usesNowPath() {
        when(userService.getAll()).thenReturn(List.of());
        when(scheduleRepository.findByDepartureTsIsNotNullAndArrivalTsBetween(any(), any()))
                .thenReturn(List.of());

        reportsService.getGlobalDashboard(ReportModels.Mode.W, null);

        verify(scheduleRepository).findByDepartureTsIsNotNullAndArrivalTsBetween(any(), any());
    }

    @Test
    void periodRange_shouldRejectNullBounds() throws Exception {
        Class<?> pr = Class.forName(ReportsService.class.getName() + "$PeriodRange");
        var ctor = pr.getDeclaredConstructor(OffsetDateTime.class, OffsetDateTime.class);
        ctor.setAccessible(true);

        assertThatThrownBy(() -> ctor.newInstance(null, OffsetDateTime.now()))
                .hasRootCauseInstanceOf(IllegalArgumentException.class)
                .hasRootCauseMessage("Range bounds must not be null");
    }

    @Test
    void periodRange_shouldRejectFromNotBeforeTo() throws Exception {
        Class<?> pr = Class.forName(ReportsService.class.getName() + "$PeriodRange");
        var ctor = pr.getDeclaredConstructor(OffsetDateTime.class, OffsetDateTime.class);
        ctor.setAccessible(true);

        OffsetDateTime t = OffsetDateTime.parse("2026-01-01T00:00:00+01:00");
        assertThatThrownBy(() -> ctor.newInstance(t, t))
                .hasRootCauseInstanceOf(IllegalArgumentException.class)
                .hasRootCauseMessage("Range 'from' must be strictly before 'to'");
    }

    @Test
    void globalDashboard_week_nonEmptyUsers_shouldComputeAveragePunctuality() {
        UserEntity u1 = mock(UserEntity.class);
        UserEntity u2 = mock(UserEntity.class);
        when(userService.getAll()).thenReturn(List.of(u1, u2));

        when(planningService.getForUser(any())).thenReturn(List.of(
                planning(PlanningEntity.WeekDay.MONDAY, LocalTime.of(9, 0))
        ));

        // each user has 1 on-time schedule => punctuality 100 each => average 100
        ScheduleEntity s1 = schedule(u1,
                OffsetDateTime.parse("2026-01-05T09:00:00+01:00"),
                OffsetDateTime.parse("2026-01-05T17:00:00+01:00"));
        ScheduleEntity s2 = schedule(u2,
                OffsetDateTime.parse("2026-01-05T09:00:00+01:00"),
                OffsetDateTime.parse("2026-01-05T17:00:00+01:00"));

        when(scheduleRepository.findByUserAndArrivalTsBetween(eq(u1), any(), any())).thenReturn(List.of(s1));
        when(scheduleRepository.findByUserAndArrivalTsBetween(eq(u2), any(), any())).thenReturn(List.of(s2));

        when(scheduleRepository.findByDepartureTsIsNotNullAndArrivalTsBetween(any(), any()))
                .thenReturn(List.of()); // keep work empty

        OffsetDateTime at = OffsetDateTime.of(2026, 1, 7, 12, 0, 0, 0, ZoneOffset.UTC);
        var res = reportsService.getGlobalDashboard(ReportModels.Mode.W, at);

        assertThat(res.punctuality().percent()).isEqualTo(100f);
    }

    @Test
    void computeExpectedWorkingDays_whenEmptyDateRange_returnsZero() throws Exception {
        var m = ReportsService.class.getDeclaredMethod(
                "computeExpectedWorkingDays",
                List.class, LocalDate.class, LocalDate.class
        );
        m.setAccessible(true);

        List<PlanningEntity> plannings = List.of(planning(PlanningEntity.WeekDay.MONDAY, LocalTime.of(9, 0)));
        LocalDate d = LocalDate.of(2026, 1, 1);

        long result = (long) m.invoke(reportsService, plannings, d, d); // empty range
        assertThat(result).isEqualTo(0L);
    }

    @Test
    void average_whenEmptyStream_returnsZero() throws Exception {
        var m = ReportsService.class.getDeclaredMethod("average", java.util.stream.Stream.class);
        m.setAccessible(true);

        float result = (float) m.invoke(reportsService, java.util.stream.Stream.<Float>empty());
        assertThat(result).isEqualTo(0f);
    }

    /* -----------------------------
     * Helpers (REAL entities, no Mockito)
     * ----------------------------- */

    private PlanningEntity planning(PlanningEntity.WeekDay day, LocalTime start) {
        PlanningEntity p = new PlanningEntity();
        p.setWeekDay(day);
        p.setStartTime(start);
        p.setEndTime(start.plusHours(8)); // default
        return p;
    }

    private ScheduleEntity schedule(UserEntity user, OffsetDateTime arrival, OffsetDateTime departure) {
        ScheduleEntity s = new ScheduleEntity();
        s.setUser(user);
        s.setArrivalTs(arrival);
        s.setDepartureTs(departure);
        return s;
    }
}
