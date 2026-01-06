package eu.epitech.t_dev_700.repositories;

import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.entities.ScheduleEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
@ActiveProfiles("test")
class ScheduleRepositoryTest {

    @Autowired
    private ScheduleRepository scheduleRepository;

    @Autowired
    private TestEntityManager entityManager;

    private ScheduleEntity testSchedule;
    private UserEntity testUser;
    private OffsetDateTime arrivalTime;
    private OffsetDateTime departureTime;

    @BeforeEach
    void setUp() {
        // Create user with account
        AccountEntity account = new AccountEntity();
        account.setUsername("testuser");
        account.setPassword("password");

        testUser = new UserEntity();
        testUser.setFirstName("John");
        testUser.setLastName("Doe");
        testUser.setEmail("john@example.com");
        testUser.setPhoneNumber("+123456");
        testUser.setAccount(account);
        account.setUser(testUser);
        testUser = entityManager.persist(testUser);
        entityManager.flush();

        arrivalTime = OffsetDateTime.now().minusHours(8);
        departureTime = OffsetDateTime.now();

        testSchedule = new ScheduleEntity();
        testSchedule.setUser(testUser);
        testSchedule.setArrivalTs(arrivalTime);
        testSchedule.setDepartureTs(departureTime);
    }

    private ScheduleEntity persistSchedule(UserEntity user, OffsetDateTime arrival, OffsetDateTime departure) {
        ScheduleEntity s = new ScheduleEntity();
        s.setUser(user);
        s.setArrivalTs(arrival);
        s.setDepartureTs(departure);
        return entityManager.persistAndFlush(s);
    }

    @Test
    void testSaveSchedule_shouldPersistSchedule() {
        ScheduleEntity saved = scheduleRepository.save(testSchedule);

        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getUser()).isEqualTo(testUser);
        assertThat(saved.getArrivalTs()).isEqualTo(arrivalTime);
        assertThat(saved.getDepartureTs()).isEqualTo(departureTime);
    }

    @Test
    void testSaveSchedule_withoutDeparture_shouldSucceed() {
        testSchedule.setDepartureTs(null);

        ScheduleEntity saved = scheduleRepository.save(testSchedule);

        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getArrivalTs()).isNotNull();
        assertThat(saved.getDepartureTs()).isNull();
    }

    @Test
    void testFindById_whenExists_shouldReturnSchedule() {
        ScheduleEntity saved = scheduleRepository.save(testSchedule);
        entityManager.flush();

        Optional<ScheduleEntity> found = scheduleRepository.findById(saved.getId());

        assertThat(found).isPresent();
        assertThat(found.get().getUser()).isEqualTo(testUser);
    }

    @Test
    void testFindById_whenNotExists_shouldReturnEmpty() {
        Optional<ScheduleEntity> found = scheduleRepository.findById(999L);

        assertThat(found).isEmpty();
    }

    @Test
    void testFindAll_shouldReturnAllSchedules() {
        scheduleRepository.save(testSchedule);

        ScheduleEntity schedule2 = new ScheduleEntity();
        schedule2.setUser(testUser);
        schedule2.setArrivalTs(OffsetDateTime.now().minusHours(16));
        schedule2.setDepartureTs(OffsetDateTime.now().minusHours(8));
        scheduleRepository.save(schedule2);

        List<ScheduleEntity> schedules = scheduleRepository.findAll();

        assertThat(schedules).hasSizeGreaterThanOrEqualTo(2);
    }

    @Test
    void testUpdateSchedule_shouldPersistChanges() {
        ScheduleEntity saved = scheduleRepository.save(testSchedule);
        entityManager.flush();
        entityManager.clear();

        OffsetDateTime newDeparture = OffsetDateTime.now().plusHours(1);
        saved.setDepartureTs(newDeparture);
        ScheduleEntity updated = scheduleRepository.save(saved);
        entityManager.flush();

        ScheduleEntity found = scheduleRepository.findById(updated.getId()).orElseThrow();
        assertThat(found.getDepartureTs()).isEqualTo(newDeparture);
    }

    @Test
    void testDeleteSchedule_shouldRemove() {
        ScheduleEntity saved = scheduleRepository.save(testSchedule);
        Long scheduleId = saved.getId();
        entityManager.flush();

        scheduleRepository.delete(saved);
        entityManager.flush();

        Optional<ScheduleEntity> found = scheduleRepository.findById(scheduleId);
        assertThat(found).isEmpty();
    }

    @Test
    void testSaveMultipleSchedulesForSameUser_shouldSucceed() {
        scheduleRepository.save(testSchedule);

        ScheduleEntity schedule2 = new ScheduleEntity();
        schedule2.setUser(testUser);
        schedule2.setArrivalTs(OffsetDateTime.now().minusDays(1));
        schedule2.setDepartureTs(OffsetDateTime.now().minusDays(1).plusHours(8));

        ScheduleEntity saved = scheduleRepository.save(schedule2);

        assertThat(saved.getId()).isNotNull();
    }

    @Test
    void testClockIn_onlyArrivalTime() {
        ScheduleEntity clockIn = new ScheduleEntity();
        clockIn.setUser(testUser);
        clockIn.setArrivalTs(OffsetDateTime.now());

        ScheduleEntity saved = scheduleRepository.save(clockIn);

        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getArrivalTs()).isNotNull();
        assertThat(saved.getDepartureTs()).isNull();
    }

    @Test
    void testClockOut_updateDepartureTime() {
        ScheduleEntity clockIn = new ScheduleEntity();
        clockIn.setUser(testUser);
        clockIn.setArrivalTs(OffsetDateTime.now().minusHours(4));
        ScheduleEntity saved = scheduleRepository.save(clockIn);
        entityManager.flush();
        entityManager.clear();

        assertThat(saved.getDepartureTs()).isNull();

        // Clock out
        saved.setDepartureTs(OffsetDateTime.now());
        ScheduleEntity updated = scheduleRepository.save(saved);
        entityManager.flush();

        ScheduleEntity found = scheduleRepository.findById(updated.getId()).orElseThrow();
        assertThat(found.getDepartureTs()).isNotNull();
        assertThat(found.getDepartureTs()).isAfter(found.getArrivalTs());
    }

    @Test
    void testSaveSchedule_withSameArrivalAndDeparture_shouldSucceed() {
        OffsetDateTime sameTime = OffsetDateTime.now();
        testSchedule.setArrivalTs(sameTime);
        testSchedule.setDepartureTs(sameTime);

        ScheduleEntity saved = scheduleRepository.save(testSchedule);

        assertThat(saved.getArrivalTs()).isEqualTo(saved.getDepartureTs());
    }

    @Test
    void testFindByUser_shouldReturnOnlyUserSchedules() {
        scheduleRepository.save(testSchedule);

        // Another user + schedule
        AccountEntity account2 = new AccountEntity();
        account2.setUsername("other");
        account2.setPassword("pw");

        UserEntity otherUser = new UserEntity();
        otherUser.setFirstName("Other");
        otherUser.setLastName("User");
        otherUser.setEmail("other@example.com");
        otherUser.setPhoneNumber("+000");
        otherUser.setAccount(account2);
        account2.setUser(otherUser);

        otherUser = entityManager.persist(otherUser);
        entityManager.flush();

        persistSchedule(otherUser,
                OffsetDateTime.parse("2026-01-01T10:00:00+01:00"),
                null);

        List<ScheduleEntity> result = scheduleRepository.findByUser(testUser);

        assertThat(result).allMatch(s -> s.getUser().getId().equals(testUser.getId()));
    }

    @Test
    void testFindByUserAndDepartureTsIsNull_shouldReturnOpenSchedule() {
        OffsetDateTime t0 = OffsetDateTime.parse("2026-01-05T09:00:00+01:00");

        persistSchedule(testUser, t0.minusHours(4), t0.minusHours(2)); // closed
        ScheduleEntity open = persistSchedule(testUser, t0.minusHours(1), null); // open

        Optional<ScheduleEntity> found = scheduleRepository.findByUserAndDepartureTsIsNull(testUser);

        assertThat(found).isPresent();
        assertThat(found.get().getId()).isEqualTo(open.getId());
    }

    @Test
    void testFindCurrentSchedules_shouldReturnOnlyCurrent_andOrderByArrivalDesc() {
        OffsetDateTime now = OffsetDateTime.parse("2026-01-06T12:00:00+01:00");

        // Not current (ended before now)
        persistSchedule(testUser,
                now.minusHours(10),
                now.minusHours(8));

        // Current (open)
        ScheduleEntity currentOpen = persistSchedule(testUser,
                now.minusHours(3),
                null);

        // Current (ends after now)
        ScheduleEntity currentClosedLater = persistSchedule(testUser,
                now.minusHours(5),
                now.plusHours(1));

        // Not current (starts after now -> arrival > now)
        persistSchedule(testUser,
                now.plusHours(1),
                null);

        List<ScheduleEntity> result = scheduleRepository.findCurrentSchedules(testUser, now);

        assertThat(result)
                .extracting(ScheduleEntity::getId)
                .containsExactly(
                        currentOpen.getId(),          // arrival -3h (newer) first
                        currentClosedLater.getId()    // arrival -5h second
                );
    }

    @Test
    void testFindFrom_shouldIncludeOpenAndDeparturesAfterFrom_andOrderByArrivalAsc() {
        OffsetDateTime base = OffsetDateTime.parse("2026-01-06T12:00:00+01:00");
        OffsetDateTime from = base.minusHours(4);

        // Excluded: departure before from
        persistSchedule(testUser,
                base.minusHours(10),
                base.minusHours(6)); // departure < from

        // Included: departure >= from
        ScheduleEntity includedClosed = persistSchedule(testUser,
                base.minusHours(8),
                base.minusHours(2)); // departure >= from

        // Included: open (departure null)
        ScheduleEntity includedOpen = persistSchedule(testUser,
                base.minusHours(1),
                null);

        List<ScheduleEntity> result = scheduleRepository.findFrom(testUser, from);

        assertThat(result)
                .extracting(ScheduleEntity::getId)
                .containsExactly(
                        includedClosed.getId(), // arrival -8h first
                        includedOpen.getId()    // arrival -1h second
                );
    }

    @Test
    void testFindUntil_shouldReturnArrivalsBeforeOrEqualToTo_andOrderByArrivalAsc() {
        OffsetDateTime to = OffsetDateTime.parse("2026-01-06T12:00:00+01:00");

        ScheduleEntity a = persistSchedule(testUser, to.minusHours(6), to.minusHours(5));
        ScheduleEntity b = persistSchedule(testUser, to.minusHours(2), null);

        // Excluded (arrival after to)
        persistSchedule(testUser, to.plusMinutes(1), null);

        List<ScheduleEntity> result = scheduleRepository.findUntil(testUser, to);

        assertThat(result)
                .extracting(ScheduleEntity::getId)
                .containsExactly(a.getId(), b.getId());
    }

    @Test
    void testFindOverlapping_shouldReturnSchedulesOverlappingWindow_includingOpen() {
        OffsetDateTime from = OffsetDateTime.parse("2026-01-06T08:00:00+01:00");
        OffsetDateTime to = OffsetDateTime.parse("2026-01-06T12:00:00+01:00");

        // Overlaps (open, arrived before to)
        ScheduleEntity open = persistSchedule(testUser,
                OffsetDateTime.parse("2026-01-06T10:00:00+01:00"),
                null);

        // Overlaps (departure after from)
        ScheduleEntity overlapClosed = persistSchedule(testUser,
                OffsetDateTime.parse("2026-01-06T07:00:00+01:00"),
                OffsetDateTime.parse("2026-01-06T09:00:00+01:00"));

        // Excluded: ends before from (departure < from)
        persistSchedule(testUser,
                OffsetDateTime.parse("2026-01-06T06:00:00+01:00"),
                OffsetDateTime.parse("2026-01-06T07:59:59+01:00"));

        // Excluded: starts after to (arrival > to)
        persistSchedule(testUser,
                OffsetDateTime.parse("2026-01-06T12:00:01+01:00"),
                null);

        List<ScheduleEntity> result = scheduleRepository.findOverlapping(testUser, from, to);

        // Ordered by arrival asc per query
        assertThat(result)
                .extracting(ScheduleEntity::getId)
                .containsExactly(overlapClosed.getId(), open.getId());
    }
}
