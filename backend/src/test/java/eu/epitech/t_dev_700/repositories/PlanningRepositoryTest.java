package eu.epitech.t_dev_700.repositories;

import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.entities.PlanningEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

import java.time.LocalTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
@ActiveProfiles("test")
class PlanningRepositoryTest {

    @Autowired
    private PlanningRepository planningRepository;

    @Autowired
    private TestEntityManager em;

    private UserEntity user1;
    private UserEntity user2;

    @BeforeEach
    void setup() {
        user1 = persistUser("John", "Doe", "john.doe@acme.test", "john_doe", "pass");
        user2 = persistUser("Jane", "Smith", "jane.smith@acme.test", "jane_smith", "pass");
    }

    private UserEntity persistUser(
            String firstName,
            String lastName,
            String email,
            String username,
            String rawPassword
    ) {
        AccountEntity account = new AccountEntity();
        account.setUsername(username);
        account.setPassword(rawPassword);

        UserEntity user = new UserEntity();
        user.setAccount(account);   // cascade PERSIST => pas besoin de em.persist(account)
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);

        em.persist(user);           // persist user => persist account via cascade
        em.flush();                 // garantit que l'id est généré tout de suite

        return user;
    }

    @Test
    void findByUser_shouldReturnOnlyUserPlannings() {
        PlanningEntity p1 = new PlanningEntity();
        p1.setUser(user1);
        p1.setWeekDay(PlanningEntity.WeekDay.MONDAY);
        p1.setStartTime(LocalTime.of(9, 0));
        p1.setEndTime(LocalTime.of(17, 0));
        em.persist(p1);

        PlanningEntity p2 = new PlanningEntity();
        p2.setUser(user1);
        p2.setWeekDay(PlanningEntity.WeekDay.TUESDAY);
        p2.setStartTime(LocalTime.of(10, 0));
        p2.setEndTime(LocalTime.of(18, 0));
        em.persist(p2);

        PlanningEntity p3 = new PlanningEntity();
        p3.setUser(user2);
        p3.setWeekDay(PlanningEntity.WeekDay.MONDAY);
        p3.setStartTime(LocalTime.of(8, 0));
        p3.setEndTime(LocalTime.of(16, 0));
        em.persist(p3);

        em.flush();
        em.clear();

        List<PlanningEntity> result = planningRepository.findByUser(user1);

        assertThat(result).hasSize(2);
        assertThat(result).allSatisfy(p ->
                assertThat(p.getUser().getId()).isEqualTo(user1.getId())
        );
    }

    @Test
    void findByUser_shouldReturnEmptyList_whenNoPlanning() {
        List<PlanningEntity> result = planningRepository.findByUser(user1);
        assertThat(result).isEmpty();
    }
}
