package eu.epitech.t_dev_700.repositories;

import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.entities.ScheduleEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.test.context.ActiveProfiles;

import java.time.Duration;
import java.time.OffsetDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;

@DataJpaTest
@ActiveProfiles("test")
class ScheduleRepositoryTest {

    @Autowired
    private ScheduleRepository scheduleRepository;

    @Autowired
    private TestEntityManager entityManager;

    private UserEntity testUser;
    private UserEntity otherUser;

    private ScheduleEntity testSchedule;

    // Keep a single reference time per test run to avoid micro-differences.
    private OffsetDateTime refNow;

    // ---------- Helpers ----------

    private static OffsetDateTime t(String iso) {
        return OffsetDateTime.parse(iso).truncatedTo(ChronoUnit.SECONDS);
    }

    private static OffsetDateTime nowFixed() {
        return OffsetDateTime.now().truncatedTo(ChronoUnit.SECONDS);
    }

    private static Duration durationOnTimeline(OffsetDateTime start, OffsetDateTime end) {
        return Duration.between(start.toInstant(), end.toInstant());
    }

    private UserEntity persistUser(String username, String email) {
        AccountEntity account = new AccountEntity();
        account.setUsername(username);
        account.setPassword("password");

        UserEntity user = new UserEntity();
        user.setFirstName("First");
        user.setLastName("Last");
        user.setEmail(email);
        user.setPhoneNumber("+000");
        user.setAccount(account);
        account.setUser(user);

        return entityManager.persistAndFlush(user);
    }

    private ScheduleEntity persistSchedule(UserEntity user, OffsetDateTime arrival, OffsetDateTime departure) {
        ScheduleEntity s = new ScheduleEntity();
        s.setUser(user);
        s.setArrivalTs(arrival.truncatedTo(ChronoUnit.SECONDS));
        s.setDepartureTs(departure == null ? null : departure.truncatedTo(ChronoUnit.SECONDS));
        return entityManager.persistAndFlush(s);
    }

    // ---------- Setup ----------

    @BeforeEach
    void setUp() {
        testUser = persistUser("testuser", "john@example.com");
        otherUser = persistUser("other", "other@example.com");

        // One consistent "now" for the whole setup (avoid calling now twice)
        refNow = nowFixed();

        OffsetDateTime arrivalTime = refNow.minusHours(8);
        OffsetDateTime departureTime = refNow;

        testSchedule = new ScheduleEntity();
        testSchedule.setUser(testUser);
        testSchedule.setArrivalTs(arrivalTime);
        testSchedule.setDepartureTs(departureTime);
    }

    // ---------- CRUD ----------

    @Test
    void testSaveSchedule_shouldPersistSchedule() {
        ScheduleEntity saved = scheduleRepository.saveAndFlush(testSchedule);
        entityManager.clear();

        ScheduleEntity found = scheduleRepository.findById(saved.getId()).orElseThrow();

        assertThat(found.getId()).isNotNull();
        assertThat(found.getUser().getId()).isEqualTo(testUser.getId());

        // Always true regardless of timezone normalization:
        assertThat(found.getDepartureTs()).isNotNull();
        assertThat(found.getDepartureTs().toInstant()).isAfterOrEqualTo(found.getArrivalTs().toInstant());

        // Since we built departure from arrival in setup, duration should still be 8h on the timeline.
        assertThat(durationOnTimeline(found.getArrivalTs(), found.getDepartureTs()))
                .isEqualTo(Duration.ofHours(8));
    }

    @Test
    void testSaveSchedule_withoutDeparture_shouldSucceed() {
        testSchedule.setDepartureTs(null);

        ScheduleEntity saved = scheduleRepository.saveAndFlush(testSchedule);
        entityManager.clear();

        ScheduleEntity found = scheduleRepository.findById(saved.getId()).orElseThrow();

        assertThat(found.getId()).isNotNull();
        assertThat(found.getArrivalTs()).isNotNull();
        assertThat(found.getDepartureTs()).isNull();
    }

    @Test
    void testSaveSchedule_withDepartureBeforeArrival_shouldFail_dueToCheckConstraint() {
        ScheduleEntity invalid = new ScheduleEntity();
        invalid.setUser(testUser);
        invalid.setArrivalTs(t("2026-01-06T12:00:00+01:00"));
        invalid.setDepartureTs(t("2026-01-06T11:59:59+01:00"));

        assertThatThrownBy(() -> {
            scheduleRepository.save(invalid);
            entityManager.flush();
        }).isInstanceOf(DataIntegrityViolationException.class);
    }

    @Test
    void testFindById_whenExists_shouldReturnSchedule() {
        ScheduleEntity saved = scheduleRepository.save(testSchedule);
        entityManager.flush();

        Optional<ScheduleEntity> found = scheduleRepository.findById(saved.getId());

        assertThat(found).isPresent();
        assertThat(found.get().getUser().getId()).isEqualTo(testUser.getId());
    }

    @Test
    void testFindById_whenNotExists_shouldReturnEmpty() {
        assertThat(scheduleRepository.findById(999L)).isEmpty();
    }

    @Test
    void testFindAll_shouldReturnAllSchedules() {
        scheduleRepository.saveAndFlush(testSchedule);

        ScheduleEntity schedule2 = new ScheduleEntity();
        schedule2.setUser(testUser);
        schedule2.setArrivalTs(refNow.minusHours(16));
        schedule2.setDepartureTs(refNow.minusHours(8));
        scheduleRepository.saveAndFlush(schedule2);

        List<ScheduleEntity> schedules = scheduleRepository.findAll();
        assertThat(schedules).hasSize(2);
    }

    @Test
    void testUpdateSchedule_shouldPersistChanges_withoutTouchingArrival() {
        ScheduleEntity saved = scheduleRepository.saveAndFlush(testSchedule);
        entityManager.clear();

        ScheduleEntity before = scheduleRepository.findById(saved.getId()).orElseThrow();

        OffsetDateTime arrivalBefore = before.getArrivalTs();
        OffsetDateTime oldDeparture = before.getDepartureTs();

        // Update only departure, computed from persisted arrival (robust)
        before.setDepartureTs(arrivalBefore.plusHours(1));
        scheduleRepository.saveAndFlush(before);
        entityManager.clear();

        ScheduleEntity after = scheduleRepository.findById(saved.getId()).orElseThrow();

        // Arrival must not change
        assertThat(after.getArrivalTs().toInstant()).isEqualTo(arrivalBefore.toInstant());

        // Departure must change
        assertThat(after.getDepartureTs()).isNotNull();
        if (oldDeparture != null) {
            assertThat(after.getDepartureTs().toInstant()).isNotEqualTo(oldDeparture.toInstant());
        }

        // Constraint invariant
        assertThat(after.getDepartureTs().toInstant()).isAfterOrEqualTo(after.getArrivalTs().toInstant());

        // Exactly +1h relative to arrival on timeline
        assertThat(durationOnTimeline(after.getArrivalTs(), after.getDepartureTs()))
                .isEqualTo(Duration.ofHours(1));
    }

    @Test
    void testDeleteSchedule_shouldRemove() {
        ScheduleEntity saved = scheduleRepository.saveAndFlush(testSchedule);
        Long scheduleId = saved.getId();

        scheduleRepository.delete(saved);
        scheduleRepository.flush();

        assertThat(scheduleRepository.findById(scheduleId)).isEmpty();
    }

    // ---------- Domain-ish behaviors ----------

    @Test
    void testClockIn_onlyArrivalTime() {
        ScheduleEntity clockIn = new ScheduleEntity();
        clockIn.setUser(testUser);
        clockIn.setArrivalTs(refNow);

        ScheduleEntity saved = scheduleRepository.saveAndFlush(clockIn);

        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getArrivalTs()).isNotNull();
        assertThat(saved.getDepartureTs()).isNull();
    }

    @Test
    void testClockOut_updateDepartureTime() {
        ScheduleEntity clockIn = new ScheduleEntity();
        clockIn.setUser(testUser);
        clockIn.setArrivalTs(refNow.minusHours(4));

        ScheduleEntity saved = scheduleRepository.saveAndFlush(clockIn);
        entityManager.clear();

        ScheduleEntity open = scheduleRepository.findById(saved.getId()).orElseThrow();
        assertThat(open.getDepartureTs()).isNull();

        // Close relative to persisted arrival
        open.setDepartureTs(open.getArrivalTs().plusHours(4));
        scheduleRepository.saveAndFlush(open);
        entityManager.clear();

        ScheduleEntity found = scheduleRepository.findById(saved.getId()).orElseThrow();
        assertThat(found.getDepartureTs()).isNotNull();
        assertThat(found.getDepartureTs().toInstant()).isAfterOrEqualTo(found.getArrivalTs().toInstant());
        assertThat(durationOnTimeline(found.getArrivalTs(), found.getDepartureTs()))
                .isEqualTo(Duration.ofHours(4));
    }

    @Test
    void testSaveSchedule_withSameArrivalAndDeparture_shouldSucceed() {
        OffsetDateTime same = refNow;
        testSchedule.setArrivalTs(same);
        testSchedule.setDepartureTs(same);

        ScheduleEntity saved = scheduleRepository.saveAndFlush(testSchedule);
        entityManager.clear();

        ScheduleEntity found = scheduleRepository.findById(saved.getId()).orElseThrow();
        assertThat(durationOnTimeline(found.getArrivalTs(), found.getDepartureTs()))
                .isEqualTo(Duration.ZERO);
    }

    @Test
    void testSaveMultipleSchedulesForSameUser_shouldSucceed() {
        scheduleRepository.saveAndFlush(testSchedule);

        ScheduleEntity schedule2 = new ScheduleEntity();
        schedule2.setUser(testUser);
        schedule2.setArrivalTs(refNow.minusDays(1));
        schedule2.setDepartureTs(refNow.minusDays(1).plusHours(8));

        scheduleRepository.saveAndFlush(schedule2);

        assertThat(scheduleRepository.findByUser(testUser)).hasSize(2);
    }

    // ---------- Derived queries ----------

    @Test
    void testFindByUser_shouldReturnOnlyUserSchedules() {
        persistSchedule(testUser, t("2026-01-05T09:00:00+01:00"), null);
        persistSchedule(otherUser, t("2026-01-05T10:00:00+01:00"), null);

        List<ScheduleEntity> result = scheduleRepository.findByUser(testUser);

        assertThat(result).isNotEmpty();
        assertThat(result).allMatch(s -> s.getUser().getId().equals(testUser.getId()));
    }

    @Test
    void testFindByUserAndDepartureTsIsNull_shouldReturnOpenSchedule() {
        OffsetDateTime base = t("2026-01-05T09:00:00+01:00");

        persistSchedule(testUser, base.minusHours(4), base.minusHours(2));
        ScheduleEntity open = persistSchedule(testUser, base.minusHours(1), null);

        Optional<ScheduleEntity> found = scheduleRepository.findByUserAndDepartureTsIsNull(testUser);

        assertThat(found).isPresent();
        assertThat(found.get().getId()).isEqualTo(open.getId());
    }

    @Test
    void testFindByUserAndArrivalTsBetween_shouldBeInclusiveAndFilterByUser() {
        OffsetDateTime from = t("2026-01-06T08:00:00+01:00");
        OffsetDateTime to   = t("2026-01-06T12:00:00+01:00");

        ScheduleEntity atFrom = persistSchedule(testUser, from, null);
        ScheduleEntity middle = persistSchedule(testUser, t("2026-01-06T10:00:00+01:00"), null);
        ScheduleEntity atTo   = persistSchedule(testUser, to, null);

        persistSchedule(otherUser, t("2026-01-06T10:00:00+01:00"), null);

        List<ScheduleEntity> result = scheduleRepository.findByUserAndArrivalTsBetween(testUser, from, to);

        assertThat(result)
                .extracting(ScheduleEntity::getId)
                .containsExactlyInAnyOrder(atFrom.getId(), middle.getId(), atTo.getId());
    }

    @Test
    void testFindByDepartureTsIsNotNullAndArrivalTsBetween_shouldReturnClosedOnly_inWindow() {
        OffsetDateTime from = t("2026-01-06T08:00:00+01:00");
        OffsetDateTime to   = t("2026-01-06T12:00:00+01:00");

        ScheduleEntity closedInWindow = persistSchedule(
                testUser,
                t("2026-01-06T09:00:00+01:00"),
                t("2026-01-06T11:00:00+01:00")
        );

        persistSchedule(testUser, t("2026-01-06T10:00:00+01:00"), null);
        persistSchedule(testUser, t("2026-01-06T07:59:59+01:00"), t("2026-01-06T09:00:00+01:00"));

        List<ScheduleEntity> result =
                scheduleRepository.findByDepartureTsIsNotNullAndArrivalTsBetween(from, to);

        assertThat(result).extracting(ScheduleEntity::getId).containsExactly(closedInWindow.getId());
    }

    @Test
    void testFindByUserAndDepartureTsIsNotNullAndArrivalTsBetween_shouldFilterUserAndClosedOnly() {
        OffsetDateTime from = t("2026-01-06T08:00:00+01:00");
        OffsetDateTime to   = t("2026-01-06T12:00:00+01:00");

        ScheduleEntity included = persistSchedule(
                testUser,
                t("2026-01-06T09:00:00+01:00"),
                t("2026-01-06T10:00:00+01:00")
        );

        persistSchedule(otherUser, t("2026-01-06T09:30:00+01:00"), t("2026-01-06T10:30:00+01:00"));
        persistSchedule(testUser, t("2026-01-06T11:00:00+01:00"), null);

        List<ScheduleEntity> result =
                scheduleRepository.findByUserAndDepartureTsIsNotNullAndArrivalTsBetween(testUser, from, to);

        assertThat(result).extracting(ScheduleEntity::getId).containsExactly(included.getId());
    }

    @Test
    void testFindByUserIdInAndDepartureTsIsNotNullAndArrivalTsBetween_shouldFilterIdsAndClosedOnly() {
        OffsetDateTime from = t("2026-01-06T08:00:00+01:00");
        OffsetDateTime to   = t("2026-01-06T12:00:00+01:00");

        ScheduleEntity a1 = persistSchedule(testUser,  t("2026-01-06T09:00:00+01:00"), t("2026-01-06T10:00:00+01:00"));
        ScheduleEntity b1 = persistSchedule(otherUser, t("2026-01-06T11:00:00+01:00"), t("2026-01-06T11:30:00+01:00"));

        persistSchedule(testUser, t("2026-01-06T10:30:00+01:00"), null);
        persistSchedule(otherUser, t("2026-01-06T12:00:01+01:00"), t("2026-01-06T13:00:00+01:00"));

        Collection<Long> ids = List.of(testUser.getId(), otherUser.getId());

        List<ScheduleEntity> result =
                scheduleRepository.findByUserIdInAndDepartureTsIsNotNullAndArrivalTsBetween(ids, from, to);

        assertThat(result)
                .extracting(ScheduleEntity::getId)
                .containsExactlyInAnyOrder(a1.getId(), b1.getId());
    }

    // ---------- Custom JPQL queries ----------

    @Test
    void testFindCurrentSchedules_shouldReturnOnlyCurrent_andOrderByArrivalDesc() {
        OffsetDateTime now = t("2026-01-06T12:00:00+01:00");

        persistSchedule(testUser, now.minusHours(10), now.minusHours(8));
        ScheduleEntity currentOpen = persistSchedule(testUser, now.minusHours(3), null);
        ScheduleEntity currentClosedLater = persistSchedule(testUser, now.minusHours(5), now.plusHours(1));
        persistSchedule(testUser, now.plusHours(1), null);

        List<ScheduleEntity> result = scheduleRepository.findCurrentSchedules(testUser, now);

        assertThat(result)
                .extracting(ScheduleEntity::getId)
                .containsExactly(currentOpen.getId(), currentClosedLater.getId());
    }

    @Test
    void testFindFrom_shouldIncludeOpenAndDeparturesAfterFrom_andOrderByArrivalAsc() {
        OffsetDateTime base = t("2026-01-06T12:00:00+01:00");
        OffsetDateTime from = base.minusHours(4);

        persistSchedule(testUser, base.minusHours(10), base.minusHours(6));

        ScheduleEntity includedClosed = persistSchedule(testUser, base.minusHours(8), base.minusHours(2));
        ScheduleEntity includedOpen = persistSchedule(testUser, base.minusHours(1), null);

        List<ScheduleEntity> result = scheduleRepository.findFrom(testUser, from);

        assertThat(result)
                .extracting(ScheduleEntity::getId)
                .containsExactly(includedClosed.getId(), includedOpen.getId());
    }

    @Test
    void testFindUntil_shouldReturnArrivalsBeforeOrEqualToTo_andOrderByArrivalAsc() {
        OffsetDateTime to = t("2026-01-06T12:00:00+01:00");

        ScheduleEntity a = persistSchedule(testUser, to.minusHours(6), to.minusHours(5));
        ScheduleEntity b = persistSchedule(testUser, to.minusHours(2), null);
        ScheduleEntity c = persistSchedule(testUser, to, null);
        persistSchedule(testUser, to.plusSeconds(1), null);

        List<ScheduleEntity> result = scheduleRepository.findUntil(testUser, to);

        assertThat(result)
                .extracting(ScheduleEntity::getId)
                .containsExactly(a.getId(), b.getId(), c.getId());
    }

    @Test
    void testFindOverlapping_shouldReturnSchedulesOverlappingWindow_includingOpen_andOrderByArrivalAsc() {
        OffsetDateTime from = t("2026-01-06T08:00:00+01:00");
        OffsetDateTime to   = t("2026-01-06T12:00:00+01:00");

        ScheduleEntity open = persistSchedule(testUser, t("2026-01-06T10:00:00+01:00"), null);
        ScheduleEntity overlapClosed = persistSchedule(testUser, t("2026-01-06T07:00:00+01:00"), t("2026-01-06T09:00:00+01:00"));
        ScheduleEntity boundaryDeparture = persistSchedule(testUser, t("2026-01-06T06:00:00+01:00"), from);

        persistSchedule(testUser, t("2026-01-06T06:00:00+01:00"), t("2026-01-06T07:59:59+01:00"));
        persistSchedule(testUser, to.plusSeconds(1), null);

        List<ScheduleEntity> result = scheduleRepository.findOverlapping(testUser, from, to);

        assertThat(result)
                .extracting(ScheduleEntity::getId)
                .containsExactly(boundaryDeparture.getId(), overlapClosed.getId(), open.getId());
    }
}
