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

import static eu.epitech.t_dev_700.entities.MembershipEntity.TeamRole.MEMBER;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@DataJpaTest
@ActiveProfiles("test")
class MembershipRepositoryTest {

    @Autowired
    private MembershipRepository membershipRepository;

    @Autowired
    private TestEntityManager entityManager;

    private UserEntity john;
    private UserEntity jane;
    private UserEntity bob;

    private TeamEntity devTeam;
    private TeamEntity qaTeam;

    @BeforeEach
    void setUp() {
        john = persistUser("john", "John", "Doe", "john@example.com", "+123456");
        jane = persistUser("jane", "Jane", "Smith", "jane@example.com", "+654321");
        bob  = persistUser("bob", "Bob", "Johnson", "bob@example.com", "+111222");

        devTeam = persistTeam("Development Team");
        qaTeam  = persistTeam("QA Team");

        entityManager.flush();
        entityManager.clear();
    }


    // -------------------------------------------------------------------------
    // Helpers
    // -------------------------------------------------------------------------

    private UserEntity persistUser(String username, String firstName, String lastName, String email, String phone) {
        AccountEntity account = new AccountEntity();
        account.setUsername(username);
        account.setPassword("password");

        UserEntity user = new UserEntity();
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setPhoneNumber(phone);

        // matches your model: User owns account (and account links back)
        user.setAccount(account);
        account.setUser(user);

        return entityManager.persist(user);
    }

    private TeamEntity persistTeam(String name) {
        TeamEntity team = new TeamEntity();
        team.setName(name);
        return entityManager.persist(team);
    }

    // -------------------------------------------------------------------------
    // CRUD
    // -------------------------------------------------------------------------

    @Test
    void testSaveMembership_shouldPersistMembership() {
        MembershipEntity saved = membershipRepository.saveAndFlush(
                new MembershipEntity(john, devTeam, MEMBER)
        );

        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getRole()).isEqualTo(MEMBER);
        assertThat(saved.getUser().getId()).isEqualTo(john.getId());
        assertThat(saved.getTeam().getId()).isEqualTo(devTeam.getId());
    }

    @Test
    void testFindById_whenExists_shouldReturnMembership() {
        MembershipEntity saved = membershipRepository.saveAndFlush(
                new MembershipEntity(john, devTeam, MEMBER)
        );
        entityManager.clear();

        Optional<MembershipEntity> found = membershipRepository.findById(saved.getId());

        assertThat(found).isPresent();
        assertThat(found.get().getId()).isEqualTo(saved.getId());
        assertThat(found.get().getRole()).isEqualTo(MEMBER);
        assertThat(found.get().getUser().getId()).isEqualTo(john.getId());
        assertThat(found.get().getTeam().getId()).isEqualTo(devTeam.getId());
    }

    @Test
    void testFindById_whenNotExists_shouldReturnEmpty() {
        assertThat(membershipRepository.findById(999L)).isEmpty();
    }

    @Test
    void testFindAll_shouldReturnAllMemberships() {
        membershipRepository.saveAndFlush(new MembershipEntity(john, devTeam, MEMBER));
        membershipRepository.saveAndFlush(new MembershipEntity(jane, devTeam, MembershipEntity.TeamRole.MANAGER));

        List<MembershipEntity> memberships = membershipRepository.findAll();

        assertThat(memberships).hasSize(2);
    }

    @Test
    void testUpdateMembership_shouldPersistChanges() {
        MembershipEntity saved = membershipRepository.saveAndFlush(
                new MembershipEntity(john, devTeam, MEMBER)
        );
        entityManager.clear();

        MembershipEntity managed = membershipRepository.findById(saved.getId()).orElseThrow();
        managed.setRole(MembershipEntity.TeamRole.MANAGER);

        membershipRepository.saveAndFlush(managed);
        entityManager.clear();

        MembershipEntity reloaded = membershipRepository.findById(saved.getId()).orElseThrow();
        assertThat(reloaded.getRole()).isEqualTo(MembershipEntity.TeamRole.MANAGER);
    }

    @Test
    void testDeleteMembership_shouldRemove() {
        MembershipEntity saved = membershipRepository.saveAndFlush(
                new MembershipEntity(john, devTeam, MEMBER)
        );

        membershipRepository.delete(saved);
        membershipRepository.flush();

        assertThat(membershipRepository.findById(saved.getId())).isEmpty();
    }

    // -------------------------------------------------------------------------
    // Constraint: UNIQUE(user_id, team_id)
    // -------------------------------------------------------------------------

    @Test
    void testSaveMembership_withDuplicateUserAndTeam_shouldThrowDataIntegrityViolation() {
        membershipRepository.saveAndFlush(new MembershipEntity(john, devTeam, MEMBER));

        // Same (user, team) -> should violate ux_membership_user_team
        MembershipEntity duplicate = new MembershipEntity(john, devTeam, MembershipEntity.TeamRole.MANAGER);

        assertThatThrownBy(() -> membershipRepository.saveAndFlush(duplicate))
                .isInstanceOf(DataIntegrityViolationException.class);
    }

    @Test
    void testSaveMembership_withSameUserDifferentTeam_shouldSucceed() {
        membershipRepository.saveAndFlush(new MembershipEntity(john, devTeam, MEMBER));

        MembershipEntity saved = membershipRepository.saveAndFlush(
                new MembershipEntity(john, qaTeam, MEMBER)
        );

        assertThat(saved.getId()).isNotNull();
    }

    @Test
    void testSaveMembership_withSameTeamDifferentUser_shouldSucceed() {
        membershipRepository.saveAndFlush(new MembershipEntity(john, devTeam, MEMBER));

        MembershipEntity saved = membershipRepository.saveAndFlush(
                new MembershipEntity(jane, devTeam, MembershipEntity.TeamRole.MANAGER)
        );

        assertThat(saved.getId()).isNotNull();
    }

    // -------------------------------------------------------------------------
    // Repository methods: findBy*
    // -------------------------------------------------------------------------

    @Test
    void testFindByUser_shouldReturnMembershipsOfUser() {
        membershipRepository.saveAndFlush(new MembershipEntity(john, devTeam, MEMBER));
        membershipRepository.saveAndFlush(new MembershipEntity(john, qaTeam, MEMBER));

        membershipRepository.saveAndFlush(new MembershipEntity(jane, devTeam, MembershipEntity.TeamRole.MANAGER));

        List<MembershipEntity> result = membershipRepository.findByUser(john);

        assertThat(result).hasSize(2);
        assertThat(result).allMatch(m -> m.getUser().getId().equals(john.getId()));
    }

    @Test
    void testFindByTeam_shouldReturnMembershipsOfTeam() {
        membershipRepository.saveAndFlush(new MembershipEntity(john, devTeam, MEMBER));
        membershipRepository.saveAndFlush(new MembershipEntity(jane, devTeam, MembershipEntity.TeamRole.MANAGER));

        membershipRepository.saveAndFlush(new MembershipEntity(bob, qaTeam, MEMBER));

        List<MembershipEntity> result = membershipRepository.findByTeam(devTeam);

        assertThat(result).hasSize(2);
        assertThat(result).allMatch(m -> m.getTeam().getId().equals(devTeam.getId()));
    }

    @Test
    void testFindByTeamAndUser_whenExists_shouldReturnMembership() {
        membershipRepository.saveAndFlush(new MembershipEntity(john, devTeam, MEMBER));

        Optional<MembershipEntity> found = membershipRepository.findByTeamAndUser(devTeam, john);

        assertThat(found).isPresent();
        assertThat(found.get().getRole()).isEqualTo(MEMBER);
    }

    @Test
    void testFindByTeamAndUser_whenNotExists_shouldReturnEmpty() {
        membershipRepository.saveAndFlush(new MembershipEntity(john, devTeam, MEMBER));

        assertThat(membershipRepository.findByTeamAndUser(devTeam, jane)).isEmpty();
    }

    @Test
    void testFindByTeamAndRole_whenExists_shouldReturnOne() {
        membershipRepository.saveAndFlush(new MembershipEntity(john, devTeam, MEMBER));
        membershipRepository.saveAndFlush(new MembershipEntity(jane, devTeam, MembershipEntity.TeamRole.MANAGER));

        Optional<MembershipEntity> found = membershipRepository.findByTeamAndRole(devTeam, MembershipEntity.TeamRole.MANAGER);

        assertThat(found).isPresent();
        assertThat(found.get().getUser().getId()).isEqualTo(jane.getId());
    }

    @Test
    void testFindByTeamAndRole_whenNotExists_shouldReturnEmpty() {
        membershipRepository.saveAndFlush(new MembershipEntity(john, devTeam, MEMBER));

        assertThat(membershipRepository.findByTeamAndRole(devTeam, MembershipEntity.TeamRole.MANAGER)).isEmpty();
    }

    // -------------------------------------------------------------------------
    // Repository methods: existsBy*
    // -------------------------------------------------------------------------

    @Test
    void testExistsByUserAndTeam_Id_shouldWork() {
        membershipRepository.saveAndFlush(new MembershipEntity(john, devTeam, MEMBER));

        assertThat(membershipRepository.existsByUserAndTeam_Id(john, devTeam.getId())).isTrue();
        assertThat(membershipRepository.existsByUserAndTeam_Id(john, qaTeam.getId())).isFalse();
    }

    @Test
    void testExistsByUserAndTeam_IdAndRole_shouldWork() {
        membershipRepository.saveAndFlush(new MembershipEntity(john, devTeam, MEMBER));

        assertThat(membershipRepository.existsByUserAndTeam_IdAndRole(john, devTeam.getId(), MEMBER)).isTrue();
        assertThat(membershipRepository.existsByUserAndTeam_IdAndRole(john, devTeam.getId(), MembershipEntity.TeamRole.MANAGER)).isFalse();
    }

    @Test
    void testExistsByUserAndRole_shouldWork() {
        membershipRepository.saveAndFlush(new MembershipEntity(john, devTeam, MEMBER));
        membershipRepository.saveAndFlush(new MembershipEntity(jane, qaTeam, MembershipEntity.TeamRole.MANAGER));

        assertThat(membershipRepository.existsByUserAndRole(john, MEMBER)).isTrue();
        assertThat(membershipRepository.existsByUserAndRole(john, MembershipEntity.TeamRole.MANAGER)).isFalse();

        assertThat(membershipRepository.existsByUserAndRole(jane, MembershipEntity.TeamRole.MANAGER)).isTrue();
        assertThat(membershipRepository.existsByUserAndRole(jane, MEMBER)).isFalse();
    }

    // -------------------------------------------------------------------------
    // Custom JPQL method
    // -------------------------------------------------------------------------

    @Test
    void testExistsMembershipOfUserIdOnTeamsManagedByOther_shouldReturnTrue() {
        // jane manages devTeam
        membershipRepository.saveAndFlush(new MembershipEntity(jane, devTeam, MembershipEntity.TeamRole.MANAGER));
        // john is on devTeam
        membershipRepository.saveAndFlush(new MembershipEntity(john, devTeam, MEMBER));

        boolean result = membershipRepository.existsMembershipOfUserIdOnTeamsManagedByOther(john.getId(), jane);

        assertThat(result).isTrue();
    }

    @Test
    void testExistsMembershipOfUserIdOnTeamsManagedByOther_shouldReturnFalse_whenOtherIsNotManager() {
        membershipRepository.saveAndFlush(new MembershipEntity(jane, devTeam, MEMBER));
        membershipRepository.saveAndFlush(new MembershipEntity(john, devTeam, MEMBER));

        boolean result = membershipRepository.existsMembershipOfUserIdOnTeamsManagedByOther(john.getId(), jane);

        assertThat(result).isFalse();
    }

    @Test
    void testExistsMembershipOfUserIdOnTeamsManagedByOther_shouldReturnFalse_whenDifferentTeams() {
        membershipRepository.saveAndFlush(new MembershipEntity(jane, devTeam, MembershipEntity.TeamRole.MANAGER));
        membershipRepository.saveAndFlush(new MembershipEntity(john, qaTeam, MEMBER));

        boolean result = membershipRepository.existsMembershipOfUserIdOnTeamsManagedByOther(john.getId(), jane);

        assertThat(result).isFalse();
    }

    @Test
    void saveMembership_withoutUser_shouldFail() {
        MembershipEntity m = new MembershipEntity();
        m.setTeam(devTeam);
        m.setRole(MembershipEntity.TeamRole.MEMBER);

        assertThatThrownBy(() -> membershipRepository.saveAndFlush(m))
                .isInstanceOf(ConstraintViolationException.class)
                .satisfies(ex -> {
                    ConstraintViolationException cve = (ConstraintViolationException) ex;
                    assertThat(cve.getConstraintViolations())
                            .anyMatch(v -> v.getPropertyPath().toString().equals("user"));
                });
    }

}
