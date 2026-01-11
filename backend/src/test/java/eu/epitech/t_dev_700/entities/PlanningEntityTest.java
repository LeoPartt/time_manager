package eu.epitech.t_dev_700.entities;

import jakarta.persistence.PersistenceException;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

import java.time.LocalTime;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@DataJpaTest
@ActiveProfiles("test")
class PlanningEntityTest {

    @Autowired
    private TestEntityManager entityManager;

    // ---------- Helpers ----------

    private UserEntity persistUser() {
        AccountEntity account = new AccountEntity();
        account.setUsername("user");
        account.setPassword("password");
        account.setFlags((byte) 0);

        entityManager.persist(account);

        UserEntity user = new UserEntity();
        user.setAccount(account);
        user.setEmail("user@test.com");
        user.setFirstName("Test");
        user.setLastName("User");

        return entityManager.persistAndFlush(user);
    }

    private PlanningEntity createValidPlanning(UserEntity user) {
        PlanningEntity planning = new PlanningEntity();
        planning.setUser(user);
        planning.setWeekDay(PlanningEntity.WeekDay.MONDAY);
        planning.setStartTime(LocalTime.of(9, 0));
        planning.setEndTime(LocalTime.of(17, 0));
        return planning;
    }

    // ---------- Tests ----------

    @Test
    void persist_validPlanning_shouldSucceed() {
        UserEntity user = persistUser();
        PlanningEntity planning = createValidPlanning(user);

        PlanningEntity saved = entityManager.persistAndFlush(planning);

        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getUser()).isEqualTo(user);
        assertThat(saved.getWeekDay()).isEqualTo(PlanningEntity.WeekDay.MONDAY);
        assertThat(saved.getStartTime()).isEqualTo(LocalTime.of(9, 0));
        assertThat(saved.getEndTime()).isEqualTo(LocalTime.of(17, 0));
    }

    @Test
    void persist_withoutUser_shouldFail() {
        PlanningEntity planning = new PlanningEntity();
        planning.setWeekDay(PlanningEntity.WeekDay.MONDAY);
        planning.setStartTime(LocalTime.of(9, 0));
        planning.setEndTime(LocalTime.of(17, 0));

        assertThatThrownBy(() ->
                entityManager.persistAndFlush(planning)
        ).isInstanceOf(PersistenceException.class);
    }

    @Test
    void persist_endBeforeStart_shouldFail_dueToCheckConstraint() {
        UserEntity user = persistUser();

        PlanningEntity planning = new PlanningEntity();
        planning.setUser(user);
        planning.setWeekDay(PlanningEntity.WeekDay.MONDAY);
        planning.setStartTime(LocalTime.of(18, 0));
        planning.setEndTime(LocalTime.of(9, 0));

        assertThatThrownBy(() ->
                entityManager.persistAndFlush(planning)
        ).isInstanceOf(PersistenceException.class);
    }

    @Test
    void equals_sameId_shouldBeEqual() {
        UserEntity user = persistUser();

        PlanningEntity p1 = entityManager.persistAndFlush(createValidPlanning(user));
        PlanningEntity p2 = entityManager.find(PlanningEntity.class, p1.getId());

        assertThat(p1).isEqualTo(p2);
        assertThat(p1.hashCode()).isEqualTo(p2.hashCode());
    }

    @Test
    void equals_differentId_shouldNotBeEqual() {
        UserEntity user = persistUser();

        PlanningEntity p1 = entityManager.persistAndFlush(createValidPlanning(user));
        PlanningEntity p2 = entityManager.persistAndFlush(createValidPlanning(user));

        assertThat(p1).isNotEqualTo(p2);
    }

    @Test
    void equals_nullId_shouldNotBeEqual() {
        PlanningEntity p1 = new PlanningEntity();
        PlanningEntity p2 = new PlanningEntity();

        assertThat(p1).isNotEqualTo(p2);
    }

    @Test
    void equals_otherType_shouldReturnFalse() {
        PlanningEntity p = new PlanningEntity();

        assertThat(p.equals("not a planning")).isFalse();
    }
}
