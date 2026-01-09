package eu.epitech.t_dev_700.repositories;

import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.entities.MembershipEntity;
import eu.epitech.t_dev_700.entities.TeamEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import jakarta.validation.ConstraintViolationException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.test.context.ActiveProfiles;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@DataJpaTest
@ActiveProfiles("test")
class TeamRepositoryTest {

    @Autowired
    private TeamRepository teamRepository;

    @Autowired
    private TestEntityManager entityManager;

    private TeamEntity testTeam;

    @BeforeEach
    void setUp() {
        testTeam = new TeamEntity();
        testTeam.setName("Development Team");
        testTeam.setDescription("A team of developers");
    }

    // --------------------
    // CRUD basics
    // --------------------

    @Test
    void testSaveTeam_shouldPersistTeam() {
        TeamEntity saved = teamRepository.save(testTeam);
        entityManager.flush();
        entityManager.clear();

        TeamEntity found = teamRepository.findById(saved.getId()).orElseThrow();
        assertThat(found.getId()).isNotNull();
        assertThat(found.getName()).isEqualTo("Development Team");
        assertThat(found.getDescription()).isEqualTo("A team of developers");
        assertThat(found.getMemberships()).isEmpty();
    }

    @Test
    void testFindById_whenExists_shouldReturnTeam() {
        TeamEntity saved = teamRepository.save(testTeam);
        entityManager.flush();
        entityManager.clear();

        Optional<TeamEntity> found = teamRepository.findById(saved.getId());
        assertThat(found).isPresent();
        assertThat(found.get().getName()).isEqualTo("Development Team");
    }

    @Test
    void testFindById_whenNotExists_shouldReturnEmpty() {
        assertThat(teamRepository.findById(999L)).isEmpty();
    }

    @Test
    void testFindAll_shouldReturnAllTeams() {
        teamRepository.save(testTeam);

        TeamEntity team2 = new TeamEntity();
        team2.setName("QA Team");
        team2.setDescription("Quality assurance team");
        teamRepository.save(team2);

        entityManager.flush();
        entityManager.clear();

        List<TeamEntity> teams = teamRepository.findAll();
        assertThat(teams).hasSize(2);
        assertThat(teams).extracting(TeamEntity::getName)
                .containsExactlyInAnyOrder("Development Team", "QA Team");
    }

    @Test
    void testUpdateTeam_shouldPersistChanges() {
        TeamEntity saved = teamRepository.save(testTeam);
        entityManager.flush();
        entityManager.clear();

        TeamEntity managed = teamRepository.findById(saved.getId()).orElseThrow();
        managed.setName("Updated Team Name");

        teamRepository.save(managed);
        entityManager.flush();
        entityManager.clear();

        TeamEntity found = teamRepository.findById(saved.getId()).orElseThrow();
        assertThat(found.getName()).isEqualTo("Updated Team Name");
    }

    @Test
    void testDeleteTeam_shouldHardDelete() {
        TeamEntity saved = teamRepository.save(testTeam);
        Long id = saved.getId();
        entityManager.flush();

        teamRepository.delete(saved);
        entityManager.flush();
        entityManager.clear();

        assertThat(teamRepository.findById(id)).isEmpty();
    }

    // --------------------
    // Validation & constraints
    // --------------------

    @Test
    void testSaveTeam_withoutName_shouldThrowConstraintViolation() {
        testTeam.setName(null);

        assertThatThrownBy(() -> {
            teamRepository.save(testTeam);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void testSaveTeam_withBlankName_shouldThrowConstraintViolation() {
        testTeam.setName("   ");

        assertThatThrownBy(() -> {
            teamRepository.save(testTeam);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void testSaveTeam_withoutDescription_shouldSucceed() {
        testTeam.setDescription(null);

        TeamEntity saved = teamRepository.save(testTeam);
        entityManager.flush();
        entityManager.clear();

        TeamEntity found = teamRepository.findById(saved.getId()).orElseThrow();
        assertThat(found.getDescription()).isNull();
    }

    @Test
    void testSaveTeam_withLongName_100_shouldSucceed() {
        testTeam.setName("A".repeat(100));

        TeamEntity saved = teamRepository.save(testTeam);
        entityManager.flush();
        entityManager.clear();

        TeamEntity found = teamRepository.findById(saved.getId()).orElseThrow();
        assertThat(found.getName()).hasSize(100);
    }

    @Test
    void testSaveTeam_withNameTooLong_101_shouldThrowConstraintViolation() {
        testTeam.setName("A".repeat(101));

        assertThatThrownBy(() -> {
            teamRepository.save(testTeam);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void testSaveTeam_withDuplicateName_shouldThrowDataIntegrityViolation() {
        TeamEntity t1 = new TeamEntity();
        t1.setName("Same Name");
        t1.setDescription("First");

        TeamEntity t2 = new TeamEntity();
        t2.setName("Same Name");
        t2.setDescription("Second");

        teamRepository.saveAndFlush(t1);

        assertThatThrownBy(() -> teamRepository.saveAndFlush(t2))
                .isInstanceOf(DataIntegrityViolationException.class);
    }

    // --------------------
    // Relationship behavior: cascade + orphanRemoval
    // --------------------

    @Test
    void testMemberships_cascadePersist_shouldPersistMemberships() {
        TeamEntity team = new TeamEntity();
        team.setName("Team With Members");
        team.setDescription("Has memberships");

        UserEntity user = persistUser("memberuser", "john@example.com");

        MembershipEntity membership = new MembershipEntity();
        membership.setUser(user);
        membership.setRole(MembershipEntity.TeamRole.MEMBER);

        team.addMembership(membership);

        TeamEntity saved = teamRepository.save(team);
        entityManager.flush();
        entityManager.clear();

        TeamEntity found = teamRepository.findById(saved.getId()).orElseThrow();
        assertThat(found.getMemberships()).hasSize(1);

        MembershipEntity m = found.getMemberships().iterator().next();
        assertThat(m.getTeam()).isNotNull();
        assertThat(m.getTeam().getId()).isEqualTo(found.getId());
        assertThat(m.getUser()).isNotNull();
        assertThat(m.getUser().getEmail()).isEqualTo("john@example.com");
    }

    @Test
    void testMemberships_orphanRemoval_shouldRemoveMembershipRow() {
        TeamEntity team = new TeamEntity();
        team.setName("Team Orphan Removal");
        team.setDescription("Test orphan removal");

        UserEntity user = persistUser("orphanuser", "jane@example.com");

        MembershipEntity membership = new MembershipEntity();
        membership.setUser(user);
        membership.setRole(MembershipEntity.TeamRole.MEMBER);

        team.addMembership(membership);

        TeamEntity saved = teamRepository.save(team);
        entityManager.flush();
        entityManager.clear();

        TeamEntity managed = teamRepository.findById(saved.getId()).orElseThrow();
        MembershipEntity toRemove = managed.getMemberships().iterator().next();

        // Keep the membership id BEFORE removal so we can assert DB-level deletion
        Long membershipId = toRemove.getId();

        managed.removeMembership(toRemove);

        teamRepository.save(managed);
        entityManager.flush();
        entityManager.clear();

        TeamEntity found = teamRepository.findById(saved.getId()).orElseThrow();
        assertThat(found.getMemberships()).isEmpty();

        // Strong DB assertion without needing a MembershipRepository:
        // If orphanRemoval worked, the membership row should no longer exist.
        assertThat(entityManager.find(MembershipEntity.class, membershipId)).isNull();
    }

    // --------------------
    // Helpers
    // --------------------

    private UserEntity persistUser(String username, String email) {
        AccountEntity account = new AccountEntity();
        account.setUsername(username);
        account.setPassword("password");

        UserEntity user = new UserEntity();
        user.setFirstName("Test");
        user.setLastName("User");
        user.setEmail(email);
        user.setPhoneNumber("+123456");
        user.setAccount(account);
        account.setUser(user);

        user = entityManager.persist(user);
        entityManager.flush();
        return user;
    }
}
