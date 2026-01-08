package eu.epitech.t_dev_700.repositories;

import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import jakarta.validation.ConstraintViolationException;
import org.hibernate.Session;
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
class UserRepositoryTest {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TestEntityManager entityManager;

    private UserEntity testUser;
    private AccountEntity testAccount;

    @BeforeEach
    void setUp() {

        testAccount = new AccountEntity();
        testAccount.setUsername("testuser");
        testAccount.setPassword("hashedPassword");

        testUser = new UserEntity();
        testUser.setFirstName("John");
        testUser.setLastName("Doe");
        testUser.setEmail("john.doe@example.com");
        testUser.setPhoneNumber("+1234567890");
        testUser.setAccount(testAccount);
        testAccount.setUser(testUser);
    }

    @Test
    void testSaveUser_shouldPersistUser() {
        UserEntity saved = userRepository.save(testUser);

        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getFirstName()).isEqualTo("John");
        assertThat(saved.getLastName()).isEqualTo("Doe");
        assertThat(saved.getEmail()).isEqualTo("john.doe@example.com");
    }

    @Test
    void testSaveUser_shouldCascadeAccount() {
        UserEntity saved = userRepository.save(testUser);
        entityManager.flush();
        entityManager.clear();

        UserEntity found = userRepository.findById(saved.getId()).orElseThrow();
        assertThat(found.getAccount()).isNotNull();
        assertThat(found.getAccount().getUsername()).isEqualTo("testuser");
    }

    @Test
    void testFindById_whenExists_shouldReturnUser() {
        UserEntity saved = userRepository.save(testUser);
        entityManager.flush();

        Optional<UserEntity> found = userRepository.findById(saved.getId());

        assertThat(found).isPresent();
        assertThat(found.get().getFirstName()).isEqualTo("John");
    }

    @Test
    void testFindById_whenNotExists_shouldReturnEmpty() {
        Optional<UserEntity> found = userRepository.findById(999L);

        assertThat(found).isEmpty();
    }

    @Test
    void testFindAll_shouldReturnAllActiveUsers() {
        userRepository.save(testUser);

        UserEntity user2 = new UserEntity();
        user2.setFirstName("Jane");
        user2.setLastName("Smith");
        user2.setEmail("jane.smith@example.com");
        user2.setPhoneNumber("+0987654321");
        AccountEntity account2 = new AccountEntity();
        account2.setUsername("janesmith");
        account2.setPassword("password");
        user2.setAccount(account2);
        account2.setUser(user2);
        userRepository.save(user2);

        List<UserEntity> users = userRepository.findAll();

        assertThat(users).hasSize(2);
    }

    @Test
    void testUpdateUser_shouldPersistChanges() {
        UserEntity saved = userRepository.save(testUser);
        entityManager.flush();
        entityManager.clear();

        saved.setFirstName("UpdatedName");
        UserEntity updated = userRepository.save(saved);
        entityManager.flush();

        UserEntity found = userRepository.findById(updated.getId()).orElseThrow();
        assertThat(found.getFirstName()).isEqualTo("UpdatedName");
    }

    @Test
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    void testDeleteUser_shouldSoftDelete() {
        UserEntity saved = userRepository.save(testUser);
        entityManager.flush();
        entityManager.clear();

        // Reload to ensure it's managed
        UserEntity managed = userRepository.findById(saved.getId()).orElseThrow();
        userRepository.delete(managed);
        entityManager.flush();
        entityManager.clear();

        assertThat(userRepository.findAll()).isEmpty();
    }

    @Test
    void testSaveUser_withoutFirstName_shouldThrowException() {
        testUser.setFirstName(null);

        assertThatThrownBy(() -> {
            userRepository.save(testUser);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void testSaveUser_withoutLastName_shouldThrowException() {
        testUser.setLastName(null);

        assertThatThrownBy(() -> {
            userRepository.save(testUser);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void testSaveUser_withBlankFirstName_shouldThrowException() {
        testUser.setFirstName("   ");

        assertThatThrownBy(() -> {
            userRepository.save(testUser);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void testSaveUser_withOptionalFieldsNull_shouldSucceed() {
        testUser.setPhoneNumber(null);

        UserEntity saved = userRepository.save(testUser);

        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getPhoneNumber()).isNull();
    }

    @Test
    void testSoftDeletedUser_shouldHaveDeletedAtSet() {
        UserEntity saved = userRepository.save(testUser);
        Long userId = saved.getId();
        entityManager.flush();
        entityManager.clear();

        // Reload entity and set deletedAt
        UserEntity managed = entityManager.find(UserEntity.class, userId);
        managed.setDeletedAt(OffsetDateTime.now());
        entityManager.persist(managed);
        entityManager.flush();
        entityManager.clear();

        // Query without @SQLRestriction using native query
        Object[] result = (Object[]) entityManager.getEntityManager()
                .createNativeQuery("SELECT id, deleted_at FROM tm_user WHERE id = ?1")
                .setParameter(1, userId)
                .getSingleResult();

        assertThat(result).isNotNull();
        assertThat(result[1]).isNotNull(); // deleted_at column should be set
    }
}
