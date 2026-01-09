package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.entities.ScheduleEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.models.ClockModels;
import eu.epitech.t_dev_700.models.UserScheduleQuery;
import eu.epitech.t_dev_700.repositories.ScheduleRepository;
import eu.epitech.t_dev_700.services.components.UserComponent;
import eu.epitech.t_dev_700.services.exceptions.ForbiddenFutureClocking;
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

import static eu.epitech.t_dev_700.models.ClockModels.ClockAction;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
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
        // If UserEntity requires fields (id, email, etc.), set them here.
        // e.g. user.setId(42L);
    }

    // ---------------------------
    // getUserClocks(Long, Query)
    // ---------------------------

    @Test
    void getUserClocks_whenCurrentTrue_usesFindCurrentSchedules() {
        Long userId = 1L;
        when(userComponent.getUser(userId)).thenReturn(user);

        UserScheduleQuery query = mock(UserScheduleQuery.class);
        when(query.getCurrent()).thenReturn(true);

        OffsetDateTime a = OffsetDateTime.parse("2025-01-01T10:00:00+00:00");
        OffsetDateTime d = OffsetDateTime.parse("2025-01-01T18:00:00+00:00");
        ScheduleEntity s = new ScheduleEntity(user, a);
        s.setDepartureTs(d);

        when(scheduleRepository.findCurrentSchedules(eq(user), any(OffsetDateTime.class)))
                .thenReturn(List.of(s));

        Long[] result = clockService.getUserClocks(userId, query);

        assertArrayEquals(new Long[]{a.toEpochSecond(), d.toEpochSecond()}, result);
        verify(scheduleRepository).findCurrentSchedules(eq(user), any(OffsetDateTime.class));
        verify(scheduleRepository, never()).findOverlapping(any(), any(), any());
        verify(scheduleRepository, never()).findFrom(any(), any());
        verify(scheduleRepository, never()).findUntil(any(), any());
        verify(scheduleRepository, never()).findByUser(any());
    }

    @Test
    void getUserClocks_whenFromAndToProvided_usesFindOverlapping() {
        Long userId = 2L;
        when(userComponent.getUser(userId)).thenReturn(user);

        UserScheduleQuery query = mock(UserScheduleQuery.class);
        when(query.getCurrent()).thenReturn(false);

        OffsetDateTime from = OffsetDateTime.parse("2025-01-01T00:00:00+00:00");
        OffsetDateTime to = OffsetDateTime.parse("2025-01-31T23:59:59+00:00");
        when(query.getFrom()).thenReturn(from);
        when(query.getTo()).thenReturn(to);

        OffsetDateTime a = OffsetDateTime.parse("2025-01-10T09:00:00+00:00");
        ScheduleEntity s = new ScheduleEntity(user, a); // departure null

        when(scheduleRepository.findOverlapping(user, from, to)).thenReturn(List.of(s));

        Long[] result = clockService.getUserClocks(userId, query);

        assertArrayEquals(new Long[]{a.toEpochSecond()}, result);
        verify(scheduleRepository).findOverlapping(user, from, to);
        verify(scheduleRepository, never()).findFrom(any(), any());
        verify(scheduleRepository, never()).findUntil(any(), any());
        verify(scheduleRepository, never()).findByUser(any());
    }

    @Test
    void getUserClocks_whenOnlyFromProvided_usesFindFrom() {
        Long userId = 3L;
        when(userComponent.getUser(userId)).thenReturn(user);

        UserScheduleQuery query = mock(UserScheduleQuery.class);
        when(query.getCurrent()).thenReturn(false);

        OffsetDateTime from = OffsetDateTime.parse("2025-02-01T00:00:00+00:00");
        when(query.getFrom()).thenReturn(from);
        when(query.getTo()).thenReturn(null);

        OffsetDateTime a = OffsetDateTime.parse("2025-02-02T08:00:00+00:00");
        OffsetDateTime d = OffsetDateTime.parse("2025-02-02T16:00:00+00:00");
        ScheduleEntity s = new ScheduleEntity(user, a);
        s.setDepartureTs(d);

        when(scheduleRepository.findFrom(user, from)).thenReturn(List.of(s));

        Long[] result = clockService.getUserClocks(userId, query);

        assertArrayEquals(new Long[]{a.toEpochSecond(), d.toEpochSecond()}, result);
        verify(scheduleRepository).findFrom(user, from);
        verify(scheduleRepository, never()).findUntil(any(), any());
        verify(scheduleRepository, never()).findByUser(any());
    }

    @Test
    void getUserClocks_whenOnlyToProvided_usesFindUntil() {
        Long userId = 4L;
        when(userComponent.getUser(userId)).thenReturn(user);

        UserScheduleQuery query = mock(UserScheduleQuery.class);
        when(query.getCurrent()).thenReturn(false);

        OffsetDateTime to = OffsetDateTime.parse("2025-03-01T00:00:00+00:00");
        when(query.getFrom()).thenReturn(null);
        when(query.getTo()).thenReturn(to);

        OffsetDateTime a = OffsetDateTime.parse("2025-02-28T12:00:00+00:00");
        ScheduleEntity s = new ScheduleEntity(user, a); // departure null

        when(scheduleRepository.findUntil(user, to)).thenReturn(List.of(s));

        Long[] result = clockService.getUserClocks(userId, query);

        assertArrayEquals(new Long[]{a.toEpochSecond()}, result);
        verify(scheduleRepository).findUntil(user, to);
        verify(scheduleRepository, never()).findByUser(any());
    }

    @Test
    void getUserClocks_whenNoFilters_usesFindByUser() {
        Long userId = 5L;
        when(userComponent.getUser(userId)).thenReturn(user);

        UserScheduleQuery query = mock(UserScheduleQuery.class);
        when(query.getCurrent()).thenReturn(false);
        when(query.getFrom()).thenReturn(null);
        when(query.getTo()).thenReturn(null);

        OffsetDateTime a1 = OffsetDateTime.parse("2025-04-01T09:00:00+00:00");
        OffsetDateTime d1 = OffsetDateTime.parse("2025-04-01T17:00:00+00:00");
        ScheduleEntity s1 = new ScheduleEntity(user, a1);
        s1.setDepartureTs(d1);

        OffsetDateTime a2 = OffsetDateTime.parse("2025-04-02T10:00:00+00:00");
        ScheduleEntity s2 = new ScheduleEntity(user, a2); // open schedule

        when(scheduleRepository.findByUser(user)).thenReturn(List.of(s1, s2));

        Long[] result = clockService.getUserClocks(userId, query);

        assertArrayEquals(new Long[]{
                a1.toEpochSecond(), d1.toEpochSecond(),
                a2.toEpochSecond()
        }, result);

        verify(scheduleRepository).findByUser(user);
    }

    // ---------------------------
    // getUserClocks(List<ScheduleEntity>)
    // ---------------------------

    @Test
    void getUserClocks_fromList_flattensArrivalAndDeparture_whenDepartureNullOrNot() {
        OffsetDateTime a1 = OffsetDateTime.parse("2025-05-01T09:00:00+00:00");
        OffsetDateTime d1 = OffsetDateTime.parse("2025-05-01T17:00:00+00:00");
        ScheduleEntity s1 = new ScheduleEntity(user, a1);
        s1.setDepartureTs(d1);

        OffsetDateTime a2 = OffsetDateTime.parse("2025-05-02T10:00:00+00:00");
        ScheduleEntity s2 = new ScheduleEntity(user, a2); // departure null

        Long[] result = clockService.getUserClocks(List.of(s1, s2));

        assertArrayEquals(new Long[]{a1.toEpochSecond(), d1.toEpochSecond(), a2.toEpochSecond()}, result);
    }

    // ---------------------------
    // postClock(PostClockRequest, UserEntity)
    // ---------------------------

    @Test
    void postClock_whenTimestampIsInFuture_throwsForbiddenFutureClocking() {
        ClockModels.PostClockRequest body = mock(ClockModels.PostClockRequest.class);

        when(body.timestamp()).thenReturn(OffsetDateTime.now().plusMinutes(1));
        // remove this: when(body.io()).thenReturn(ClockAction.IN);

        assertThrows(ForbiddenFutureClocking.class, () -> clockService.postClock(body, user));
        verifyNoInteractions(scheduleRepository);
    }

    @Test
    void postClock_IN_whenOpenScheduleExists_throwsInvalidClockingAction() {
        ClockModels.PostClockRequest body = mock(ClockModels.PostClockRequest.class);
        when(body.timestamp()).thenReturn(OffsetDateTime.now().minusMinutes(1));
        when(body.io()).thenReturn(ClockAction.IN);

        ScheduleEntity existingOpen = new ScheduleEntity(user, OffsetDateTime.now().minusHours(2));
        when(scheduleRepository.findByUserAndDepartureTsIsNull(user))
                .thenReturn(Optional.of(existingOpen));

        assertThrows(RuntimeException.class, () -> clockService.postClock(body, user));
        // If InvalidClockingAction extends RuntimeException, you can replace RuntimeException with InvalidClockingAction.
        verify(scheduleRepository).findByUserAndDepartureTsIsNull(user);
        verify(scheduleRepository, never()).save(any());
    }

    @Test
    void postClock_IN_whenNoOpenSchedule_savesNewSchedule() {
        OffsetDateTime ts = OffsetDateTime.parse("2025-06-01T08:30:00+00:00");

        ClockModels.PostClockRequest body = mock(ClockModels.PostClockRequest.class);
        when(body.timestamp()).thenReturn(ts);
        when(body.io()).thenReturn(ClockAction.IN);

        when(scheduleRepository.findByUserAndDepartureTsIsNull(user))
                .thenReturn(Optional.empty());

        ArgumentCaptor<ScheduleEntity> captor = ArgumentCaptor.forClass(ScheduleEntity.class);
        when(scheduleRepository.save(any(ScheduleEntity.class))).thenAnswer(inv -> inv.getArgument(0));

        clockService.postClock(body, user);

        verify(scheduleRepository).save(captor.capture());
        ScheduleEntity saved = captor.getValue();

        assertNotNull(saved);
        assertEquals(ts, saved.getArrivalTs());
        assertNull(saved.getDepartureTs());
        assertEquals(user, saved.getUser());
    }

    @Test
    void postClock_OUT_whenOpenScheduleExists_setsDepartureAndSaves() {
        OffsetDateTime arrival = OffsetDateTime.parse("2025-06-01T08:00:00+00:00");
        OffsetDateTime departure = OffsetDateTime.parse("2025-06-01T12:00:00+00:00");

        ScheduleEntity open = new ScheduleEntity(user, arrival);

        ClockModels.PostClockRequest body = mock(ClockModels.PostClockRequest.class);
        when(body.timestamp()).thenReturn(departure);
        when(body.io()).thenReturn(ClockAction.OUT);

        when(scheduleRepository.findByUserAndDepartureTsIsNull(user))
                .thenReturn(Optional.of(open));

        ArgumentCaptor<ScheduleEntity> captor = ArgumentCaptor.forClass(ScheduleEntity.class);
        when(scheduleRepository.save(any(ScheduleEntity.class))).thenAnswer(inv -> inv.getArgument(0));

        clockService.postClock(body, user);

        verify(scheduleRepository).save(captor.capture());
        ScheduleEntity saved = captor.getValue();

        assertEquals(arrival, saved.getArrivalTs());
        assertEquals(departure, saved.getDepartureTs());
        assertEquals(user, saved.getUser());
    }

    @Test
    void postClock_OUT_whenNoOpenSchedule_throwsInvalidClockingAction() {
        ClockModels.PostClockRequest body = mock(ClockModels.PostClockRequest.class);
        when(body.timestamp()).thenReturn(OffsetDateTime.now().minusMinutes(1));
        when(body.io()).thenReturn(ClockAction.OUT);

        when(scheduleRepository.findByUserAndDepartureTsIsNull(user))
                .thenReturn(Optional.empty());

        assertThrows(RuntimeException.class, () -> clockService.postClock(body, user));
        // If InvalidClockingAction extends RuntimeException, replace RuntimeException with InvalidClockingAction.
        verify(scheduleRepository).findByUserAndDepartureTsIsNull(user);
        verify(scheduleRepository, never()).save(any());
    }

    // ---------------------------
    // postClock(PostClockRequest, Long) overload
    // ---------------------------

    @Test
    void postClock_withUserId_loadsUserAndDelegates() {
        Long userId = 10L;
        when(userComponent.getUser(userId)).thenReturn(user);

        ClockModels.PostClockRequest body = mock(ClockModels.PostClockRequest.class);
        when(body.timestamp()).thenReturn(OffsetDateTime.now().minusMinutes(1));
        when(body.io()).thenReturn(ClockAction.IN);

        when(scheduleRepository.findByUserAndDepartureTsIsNull(user))
                .thenReturn(Optional.empty());

        clockService.postClock(body, userId);

        verify(userComponent).getUser(userId);
        verify(scheduleRepository).save(any(ScheduleEntity.class));
    }
}
