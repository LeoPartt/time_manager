package eu.epitech.t_dev_700.repositories;

import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.entities.MembershipEntity;
import eu.epitech.t_dev_700.entities.TeamEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@DataJpaTest
@ActiveProfiles("test")
class MembershipRepositoryTest {

    @Autowired
    private MembershipRepository membershipRepository;

    @Autowired
    private TestEntityManager entityManager;

    private MembershipEntity testMembership;
    private UserEntity testUser;
    private TeamEntity testTeam;

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

        // Create team
        testTeam = new TeamEntity();
        testTeam.setName("Development Team");
        testTeam = entityManager.persist(testTeam);

        entityManager.flush();

        // Create membership
        testMembership = new MembershipEntity();
        testMembership.setUser(testUser);
        testMembership.setTeam(testTeam);
        testMembership.setRole(MembershipEntity.TeamRole.MEMBER);
    }

    @Test
    void testSaveMembership_shouldPersistMembership() {
        MembershipEntity saved = membershipRepository.save(testMembership);

        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getUser()).isEqualTo(testUser);
        assertThat(saved.getTeam()).isEqualTo(testTeam);
        assertThat(saved.getRole()).isEqualTo(MembershipEntity.TeamRole.MEMBER);
    }

    @Test
    void testFindById_whenExists_shouldReturnMembership() {
        MembershipEntity saved = membershipRepository.save(testMembership);
        entityManager.flush();

        Optional<MembershipEntity> found = membershipRepository.findById(saved.getId());

        assertThat(found).isPresent();
        assertThat(found.get().getRole()).isEqualTo(MembershipEntity.TeamRole.MEMBER);
    }

    @Test
    void testFindById_whenNotExists_shouldReturnEmpty() {
        Optional<MembershipEntity> found = membershipRepository.findById(999L);

        assertThat(found).isEmpty();
    }

    @Test
    void testFindAll_shouldReturnAllActiveMemberships() {
        membershipRepository.save(testMembership);

        AccountEntity account2 = new AccountEntity();
        account2.setUsername("jane");
        account2.setPassword("password");

        UserEntity user2 = new UserEntity();
        user2.setFirstName("Jane");
        user2.setLastName("Smith");
        user2.setEmail("jane@example.com");
        user2.setPhoneNumber("+654321");
        user2.setAccount(account2);
        account2.setUser(user2);
        user2 = entityManager.persist(user2);
        entityManager.flush();

        MembershipEntity membership2 = new MembershipEntity();
        membership2.setUser(user2);
        membership2.setTeam(testTeam);
        membership2.setRole(MembershipEntity.TeamRole.MANAGER);
        membershipRepository.save(membership2);

        List<MembershipEntity> memberships = membershipRepository.findAll();

        assertThat(memberships).hasSize(2);
    }

    @Test
    void testUpdateMembership_shouldPersistChanges() {
        MembershipEntity saved = membershipRepository.save(testMembership);
        entityManager.flush();
        entityManager.clear();

        saved.setRole(MembershipEntity.TeamRole.MANAGER);
        MembershipEntity updated = membershipRepository.save(saved);
        entityManager.flush();

        MembershipEntity found = membershipRepository.findById(updated.getId()).orElseThrow();
        assertThat(found.getRole()).isEqualTo(MembershipEntity.TeamRole.MANAGER);
    }

    @Test
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    void testDeleteMembership_shouldRemove() {
        MembershipEntity saved = membershipRepository.save(testMembership);
        Long membershipId = saved.getId();

        membershipRepository.delete(saved);

        Optional<MembershipEntity> found = membershipRepository.findById(membershipId);
        assertThat(found).isEmpty();
    }

    @Test
    void testSaveMembership_withDuplicateUserAndTeam_shouldThrowException() {
        membershipRepository.save(testMembership);
        entityManager.flush();

        MembershipEntity duplicate = new MembershipEntity();
        duplicate.setUser(testUser);
        duplicate.setTeam(testTeam);
        duplicate.setRole(MembershipEntity.TeamRole.MANAGER);

        assertThatThrownBy(() -> {
            membershipRepository.save(duplicate);
            entityManager.flush();
        }).isInstanceOf(Exception.class)
         .hasMessageContaining("Unique index or primary key violation");
    }

    @Test
    void testSaveMembership_withManagerRole_shouldPersist() {
        testMembership.setRole(MembershipEntity.TeamRole.MANAGER);
        MembershipEntity saved = membershipRepository.save(testMembership);

        assertThat(saved.getRole()).isEqualTo(MembershipEntity.TeamRole.MANAGER);
    }

    @Test
    void testSoftDeletedMembership_shouldNotBeFound() {
        MembershipEntity saved = membershipRepository.save(testMembership);
        saved.setDeletedAt(OffsetDateTime.now());
        entityManager.persist(saved);
        entityManager.flush();
        entityManager.clear();

        Optional<MembershipEntity> found = membershipRepository.findById(saved.getId());
        assertThat(found).isEmpty();
    }

    @Test
    void testSaveMembership_withDifferentTeam_shouldSucceed() {
        membershipRepository.save(testMembership);

        TeamEntity anotherTeam = new TeamEntity();
        anotherTeam.setName("QA Team");
        anotherTeam = entityManager.persist(anotherTeam);
        entityManager.flush();

        MembershipEntity anotherMembership = new MembershipEntity();
        anotherMembership.setUser(testUser);
        anotherMembership.setTeam(anotherTeam);
        anotherMembership.setRole(MembershipEntity.TeamRole.MEMBER);

        MembershipEntity saved = membershipRepository.save(anotherMembership);

        assertThat(saved.getId()).isNotNull();
    }

    @Test
    void testSaveMembership_withDifferentUser_shouldSucceed() {
        membershipRepository.save(testMembership);

        AccountEntity account2 = new AccountEntity();
        account2.setUsername("bob");
        account2.setPassword("password");

        UserEntity anotherUser = new UserEntity();
        anotherUser.setFirstName("Bob");
        anotherUser.setLastName("Johnson");
        anotherUser.setEmail("bob@example.com");
        anotherUser.setPhoneNumber("+111222");
        anotherUser.setAccount(account2);
        account2.setUser(anotherUser);
        anotherUser = entityManager.persist(anotherUser);
        entityManager.flush();

        MembershipEntity anotherMembership = new MembershipEntity();
        anotherMembership.setUser(anotherUser);
        anotherMembership.setTeam(testTeam);
        anotherMembership.setRole(MembershipEntity.TeamRole.MANAGER);

        MembershipEntity saved = membershipRepository.save(anotherMembership);

        assertThat(saved.getId()).isNotNull();
    }
}
