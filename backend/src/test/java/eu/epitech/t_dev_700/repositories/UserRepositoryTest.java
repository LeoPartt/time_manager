package eu.epitech.t_dev_700.repositories;

import eu.epitech.t_dev_700.entities.AccountEntity;
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

        // IMPORTANT:
        // Only set the OWNING side (UserEntity.account). Do NOT set account.user here,
        // otherwise Hibernate may try to persist Account while it points to a transient User.
        testUser.setAccount(testAccount);
    }

    // ---- CREATE / READ ----

    @Test
    void save_shouldPersistUser() {
        UserEntity saved = userRepository.save(testUser);
        entityManager.flush();

        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getFirstName()).isEqualTo("John");
        assertThat(saved.getLastName()).isEqualTo("Doe");
        assertThat(saved.getEmail()).isEqualTo("john.doe@example.com");
        assertThat(saved.getPhoneNumber()).isEqualTo("+1234567890");
    }

    @Test
    void save_shouldCascadePersistAccount() {
        UserEntity saved = userRepository.save(testUser);
        entityManager.flush();
        entityManager.clear();

        UserEntity found = userRepository.findById(saved.getId()).orElseThrow();

        assertThat(found.getAccount()).isNotNull();
        assertThat(found.getAccount().getUsername()).isEqualTo("testuser");
    }

    @Test
    void findById_whenExists_shouldReturnUser() {
        UserEntity saved = userRepository.save(testUser);
        entityManager.flush();

        Optional<UserEntity> found = userRepository.findById(saved.getId());

        assertThat(found).isPresent();
        assertThat(found.get().getFirstName()).isEqualTo("John");
    }

    @Test
    void findById_whenNotExists_shouldReturnEmpty() {
        assertThat(userRepository.findById(999L)).isEmpty();
    }

    @Test
    void findByIdIncludeDeleted_shouldReturnUser() {
        // No soft-delete fields/annotations exist in the UserEntity you pasted.
        UserEntity saved = userRepository.save(testUser);
        entityManager.flush();

        Optional<UserEntity> found = userRepository.findByIdIncludeDeleted(saved.getId());

        assertThat(found).isPresent();
        assertThat(found.get().getId()).isEqualTo(saved.getId());
    }

    @Test
    void findAll_shouldReturnAllUsers() {
        userRepository.save(testUser);

        AccountEntity account2 = new AccountEntity();
        account2.setUsername("janesmith");
        account2.setPassword("password");

        UserEntity user2 = new UserEntity();
        user2.setFirstName("Jane");
        user2.setLastName("Smith");
        user2.setEmail("jane.smith@example.com");
        user2.setPhoneNumber(null);
        user2.setAccount(account2);

        userRepository.save(user2);

        entityManager.flush();

        List<UserEntity> users = userRepository.findAll();
        assertThat(users).hasSize(2);
    }

    // ---- UPDATE ----

    @Test
    void update_shouldPersistChanges_onManagedEntity() {
        UserEntity saved = userRepository.save(testUser);
        entityManager.flush();
        entityManager.clear();

        UserEntity managed = userRepository.findById(saved.getId()).orElseThrow();
        managed.setFirstName("UpdatedName");

        entityManager.flush();
        entityManager.clear();

        UserEntity found = userRepository.findById(saved.getId()).orElseThrow();
        assertThat(found.getFirstName()).isEqualTo("UpdatedName");
    }

    @Test
    void update_shouldPersistChanges_onDetachedEntity_mergeBehavior() {
        UserEntity saved = userRepository.save(testUser);
        entityManager.flush();
        entityManager.clear();

        // detached instance
        saved.setLastName("DetachedUpdate");
        userRepository.save(saved);

        entityManager.flush();
        entityManager.clear();

        UserEntity found = userRepository.findById(saved.getId()).orElseThrow();
        assertThat(found.getLastName()).isEqualTo("DetachedUpdate");
    }

    // ---- DELETE ----

    @Test
    void delete_shouldRemoveEntity() {
        UserEntity saved = userRepository.save(testUser);
        entityManager.flush();
        entityManager.clear();

        // Reload (managed) then delete
        UserEntity managed = userRepository.findById(saved.getId()).orElseThrow();
        userRepository.delete(managed);

        entityManager.flush();
        entityManager.clear();

        assertThat(userRepository.findById(saved.getId())).isEmpty();
        assertThat(userRepository.findAll()).isEmpty();
    }

    // ---- VALIDATION ----

    @Test
    void save_withoutAccount_shouldFail() {
        testUser.setAccount(null);

        assertThatThrownBy(() -> {
            userRepository.save(testUser);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void save_withoutFirstName_shouldFail() {
        testUser.setFirstName(null);

        assertThatThrownBy(() -> {
            userRepository.save(testUser);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void save_withBlankFirstName_shouldFail() {
        testUser.setFirstName("   ");

        assertThatThrownBy(() -> {
            userRepository.save(testUser);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void save_firstNameTooLong_shouldFail() {
        testUser.setFirstName("a".repeat(101));

        assertThatThrownBy(() -> {
            userRepository.save(testUser);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void save_withoutLastName_shouldFail() {
        testUser.setLastName(null);

        assertThatThrownBy(() -> {
            userRepository.save(testUser);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void save_lastNameTooLong_shouldFail() {
        testUser.setLastName("a".repeat(101));

        assertThatThrownBy(() -> {
            userRepository.save(testUser);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void save_withoutEmail_shouldFail() {
        testUser.setEmail(null);

        assertThatThrownBy(() -> {
            userRepository.save(testUser);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void save_blankEmail_shouldFail() {
        testUser.setEmail("   ");

        assertThatThrownBy(() -> {
            userRepository.save(testUser);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void save_phoneNumberTooLong_shouldFail() {
        testUser.setPhoneNumber("1".repeat(33));

        assertThatThrownBy(() -> {
            userRepository.save(testUser);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void save_withNullPhoneNumber_shouldSucceed() {
        testUser.setPhoneNumber(null);

        UserEntity saved = userRepository.save(testUser);
        entityManager.flush();

        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getPhoneNumber()).isNull();
    }

    // ---- DB CONSTRAINT: tm_user.account_id is UNIQUE ----

    @Test
    void save_twoUsersWithSameAccount_shouldFail_dueToUniqueConstraint() {
        UserEntity u1 = userRepository.save(testUser);
        entityManager.flush();
        entityManager.clear();

        // Use the same persisted account for a second user
        AccountEntity sameAccount = entityManager.find(AccountEntity.class, u1.getAccount().getId());

        UserEntity user2 = new UserEntity();
        user2.setFirstName("Jane");
        user2.setLastName("Smith");
        user2.setEmail("jane.smith@example.com");
        user2.setPhoneNumber(null);
        user2.setAccount(sameAccount);

        assertThatThrownBy(() -> {
            userRepository.save(user2);
            entityManager.flush();
        }).isInstanceOf(DataIntegrityViolationException.class);
    }
}
