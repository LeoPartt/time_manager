package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.entities.ScheduleEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.models.ClockModels;
import eu.epitech.t_dev_700.models.UserScheduleQuery;
import eu.epitech.t_dev_700.repositories.ScheduleRepository;
import eu.epitech.t_dev_700.services.components.UserComponent;
import eu.epitech.t_dev_700.services.exceptions.InvalidClocking;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ClockServiceTest {

    @Mock
    private UserComponent userComponent;

    @Mock
    private ScheduleRepository scheduleRepository;

    @InjectMocks
    private ClockService clockService;

    private UserEntity user;

    @BeforeEach
    void setUp() {
        user = new UserEntity();
        user.setId(1L);
    }

    // -------------------------
    // getUserClocks(id, query)
    // -------------------------

    @Test
    void testGetUserClocks_currentTrue_shouldCallFindCurrentSchedules() {
        when(userComponent.getUser(1L)).thenReturn(user);
        UserScheduleQuery query = new UserScheduleQuery();
        query.setCurrent(true);

        when(scheduleRepository.findCurrentSchedules(eq(user), any()))
                .thenReturn(List.of());

        Long[] result = clockService.getUserClocks(1L, query);

        assertThat(result).isEmpty();

        verify(userComponent).getUser(1L);
        verify(scheduleRepository).findCurrentSchedules(eq(user), any(OffsetDateTime.class));
        verifyNoMoreInteractions(scheduleRepository);
    }

    @Test
    void testGetUserClocks_fromAndTo_shouldCallFindOverlapping_withCorrectOrder() {
        when(userComponent.getUser(1L)).thenReturn(user);
        OffsetDateTime from = OffsetDateTime.parse("2026-01-01T10:00:00+01:00");
        OffsetDateTime to = OffsetDateTime.parse("2026-01-10T10:00:00+01:00");

        UserScheduleQuery query = new UserScheduleQuery();
        query.setCurrent(false);
        query.setFrom(from);
        query.setTo(to);

        when(scheduleRepository.findOverlapping(user, from, to))
                .thenReturn(List.of());

        Long[] result = clockService.getUserClocks(1L, query);

        assertThat(result).isEmpty();

        verify(userComponent).getUser(1L);
        verify(scheduleRepository).findOverlapping(user, from, to);
        verifyNoMoreInteractions(scheduleRepository);
    }

    @Test
    void testGetUserClocks_fromOnly_shouldCallFindFrom() {
        when(userComponent.getUser(1L)).thenReturn(user);
        OffsetDateTime from = OffsetDateTime.parse("2026-01-01T10:00:00+01:00");

        UserScheduleQuery query = new UserScheduleQuery();
        query.setCurrent(false);
        query.setFrom(from);
        query.setTo(null);

        when(scheduleRepository.findFrom(user, from))
                .thenReturn(List.of());

        Long[] result = clockService.getUserClocks(1L, query);

        assertThat(result).isEmpty();

        verify(userComponent).getUser(1L);
        verify(scheduleRepository).findFrom(user, from);
        verifyNoMoreInteractions(scheduleRepository);
    }

    @Test
    void testGetUserClocks_toOnly_shouldCallFindUntil() {
        when(userComponent.getUser(1L)).thenReturn(user);
        OffsetDateTime to = OffsetDateTime.parse("2026-01-10T10:00:00+01:00");

        UserScheduleQuery query = new UserScheduleQuery();
        query.setCurrent(false);
        query.setFrom(null);
        query.setTo(to);

        when(scheduleRepository.findUntil(user, to))
                .thenReturn(List.of());

        Long[] result = clockService.getUserClocks(1L, query);

        assertThat(result).isEmpty();

        verify(userComponent).getUser(1L);
        verify(scheduleRepository).findUntil(user, to);
        verifyNoMoreInteractions(scheduleRepository);
    }

    @Test
    void testGetUserClocks_noFromNoTo_shouldCallFindByUser() {
        when(userComponent.getUser(1L)).thenReturn(user);
        UserScheduleQuery query = new UserScheduleQuery();
        query.setCurrent(false);
        query.setFrom(null);
        query.setTo(null);

        when(scheduleRepository.findByUser(user))
                .thenReturn(List.of());

        Long[] result = clockService.getUserClocks(1L, query);

        assertThat(result).isEmpty();

        verify(userComponent).getUser(1L);
        verify(scheduleRepository).findByUser(user);
        verifyNoMoreInteractions(scheduleRepository);
    }

    // --------------------------------
    // getUserClocks(List<ScheduleEntity>)
    // --------------------------------

    @Test
    void testGetUserClocks_flatten_shouldReturnArrivalOnly_whenDepartureNull() {
        OffsetDateTime arrival = OffsetDateTime.parse("2026-01-01T10:00:00+01:00");

        ScheduleEntity s = new ScheduleEntity();
        s.setUser(user);
        s.setArrivalTs(arrival);
        s.setDepartureTs(null);

        Long[] result = clockService.getUserClocks(List.of(s));

        assertThat(result).containsExactly(arrival.toEpochSecond());
    }

    @Test
    void testGetUserClocks_flatten_shouldReturnArrivalAndDeparture_whenDepartureNotNull() {
        OffsetDateTime arrival = OffsetDateTime.parse("2026-01-01T10:00:00+01:00");
        OffsetDateTime departure = OffsetDateTime.parse("2026-01-01T12:00:00+01:00");

        ScheduleEntity s = new ScheduleEntity();
        s.setUser(user);
        s.setArrivalTs(arrival);
        s.setDepartureTs(departure);

        Long[] result = clockService.getUserClocks(List.of(s));

        assertThat(result).containsExactly(arrival.toEpochSecond(), departure.toEpochSecond());
    }

    @Test
    void testGetUserClocks_flatten_shouldPreserveScheduleOrder() {
        OffsetDateTime a1 = OffsetDateTime.parse("2026-01-01T10:00:00+01:00");
        OffsetDateTime d1 = OffsetDateTime.parse("2026-01-01T11:00:00+01:00");
        OffsetDateTime a2 = OffsetDateTime.parse("2026-01-02T10:00:00+01:00");

        ScheduleEntity s1 = new ScheduleEntity();
        s1.setUser(user);
        s1.setArrivalTs(a1);
        s1.setDepartureTs(d1);

        ScheduleEntity s2 = new ScheduleEntity();
        s2.setUser(user);
        s2.setArrivalTs(a2);
        s2.setDepartureTs(null);

        Long[] result = clockService.getUserClocks(List.of(s1, s2));

        assertThat(result).containsExactly(
                a1.toEpochSecond(),
                d1.toEpochSecond(),
                a2.toEpochSecond()
        );
    }

    // -------------------------
    // postClock(body, user)
    // -------------------------

    @Test
    void testPostClock_in_whenNoOpenSchedule_shouldCreateNewSchedule() {
        OffsetDateTime ts = OffsetDateTime.parse("2026-01-01T10:00:00+01:00");
        ClockModels.PostClockRequest body = new ClockModels.PostClockRequest(ClockModels.ClockAction.IN, ts);

        when(scheduleRepository.findByUserAndDepartureTsIsNull(user)).thenReturn(Optional.empty());
        when(scheduleRepository.save(any(ScheduleEntity.class))).thenAnswer(inv -> inv.getArgument(0));

        clockService.postClock(body, user);

        verify(scheduleRepository).findByUserAndDepartureTsIsNull(user);

        ArgumentCaptor<ScheduleEntity> captor = ArgumentCaptor.forClass(ScheduleEntity.class);
        verify(scheduleRepository).save(captor.capture());

        ScheduleEntity saved = captor.getValue();
        assertThat(saved.getUser()).isEqualTo(user);
        assertThat(saved.getArrivalTs()).isEqualTo(ts);
        assertThat(saved.getDepartureTs()).isNull();
    }

    @Test
    void testPostClock_in_whenOpenScheduleExists_shouldThrowInvalidClocking() {
        OffsetDateTime ts = OffsetDateTime.parse("2026-01-01T10:00:00+01:00");
        ClockModels.PostClockRequest body = new ClockModels.PostClockRequest(ClockModels.ClockAction.IN, ts);

        ScheduleEntity open = new ScheduleEntity();
        open.setUser(user);
        open.setArrivalTs(OffsetDateTime.parse("2026-01-01T09:00:00+01:00"));
        open.setDepartureTs(null);

        when(scheduleRepository.findByUserAndDepartureTsIsNull(user)).thenReturn(Optional.of(open));

        assertThatThrownBy(() -> clockService.postClock(body, user))
                .isInstanceOf(InvalidClocking.class);

        verify(scheduleRepository).findByUserAndDepartureTsIsNull(user);
        verify(scheduleRepository, never()).save(any());
    }

    @Test
    void testPostClock_out_whenOpenScheduleExists_shouldCloseIt() {
        OffsetDateTime outTs = OffsetDateTime.parse("2026-01-01T12:00:00+01:00");
        ClockModels.PostClockRequest body = new ClockModels.PostClockRequest(ClockModels.ClockAction.OUT, outTs);

        ScheduleEntity open = new ScheduleEntity();
        open.setUser(user);
        open.setArrivalTs(OffsetDateTime.parse("2026-01-01T10:00:00+01:00"));
        open.setDepartureTs(null);

        when(scheduleRepository.findByUserAndDepartureTsIsNull(user)).thenReturn(Optional.of(open));
        when(scheduleRepository.save(any(ScheduleEntity.class))).thenAnswer(inv -> inv.getArgument(0));

        clockService.postClock(body, user);

        verify(scheduleRepository).findByUserAndDepartureTsIsNull(user);

        ArgumentCaptor<ScheduleEntity> captor = ArgumentCaptor.forClass(ScheduleEntity.class);
        verify(scheduleRepository).save(captor.capture());

        ScheduleEntity saved = captor.getValue();
        assertThat(saved).isSameAs(open);
        assertThat(saved.getDepartureTs()).isEqualTo(outTs);
    }

    @Test
    void testPostClock_out_whenNoOpenSchedule_shouldThrowInvalidClocking() {
        OffsetDateTime outTs = OffsetDateTime.parse("2026-01-01T12:00:00+01:00");
        ClockModels.PostClockRequest body = new ClockModels.PostClockRequest(ClockModels.ClockAction.OUT, outTs);

        when(scheduleRepository.findByUserAndDepartureTsIsNull(user)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> clockService.postClock(body, user))
                .isInstanceOf(InvalidClocking.class);

        verify(scheduleRepository).findByUserAndDepartureTsIsNull(user);
        verify(scheduleRepository, never()).save(any());
    }
}
