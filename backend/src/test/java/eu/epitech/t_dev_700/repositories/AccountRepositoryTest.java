package eu.epitech.t_dev_700.repositories;

import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import jakarta.validation.ConstraintViolationException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.test.context.ActiveProfiles;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@DataJpaTest
@ActiveProfiles("test")
class AccountRepositoryTest {

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager entityManager;

    private AccountEntity testAccount;

    @BeforeEach
    void setUp() {
        testAccount = new AccountEntity();
        testAccount.setUsername("testuser");
        testAccount.setPassword("hashedPassword");
        // flags default is 0 in entity field initialization
    }

    @Test
    void save_shouldPersistAccount_andAssignId() {
        AccountEntity saved = accountRepository.save(testAccount);
        entityManager.flush(); // IDENTITY -> make sure id is assigned + constraints checked

        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getUsername()).isEqualTo("testuser");
        assertThat(saved.getPassword()).isEqualTo("hashedPassword");

        // verify default persisted value from DB
        entityManager.clear();
        AccountEntity found = accountRepository.findById(saved.getId()).orElseThrow();
        assertThat(found.getFlags()).isEqualTo((byte) 0);
    }

    @Test
    void findById_whenExists_shouldReturnAccount() {
        AccountEntity saved = accountRepository.save(testAccount);
        entityManager.flush();
        entityManager.clear();

        Optional<AccountEntity> found = accountRepository.findById(saved.getId());

        assertThat(found).isPresent();
        assertThat(found.get().getUsername()).isEqualTo("testuser");
    }

    @Test
    void findById_whenNotExists_shouldReturnEmpty() {
        Optional<AccountEntity> found = accountRepository.findById(999L);
        assertThat(found).isEmpty();
    }

    @Test
    void findByUsername_whenExists_shouldReturnAccount() {
        accountRepository.save(testAccount);
        entityManager.flush();
        entityManager.clear();

        Optional<AccountEntity> found = accountRepository.findByUsername("testuser");

        assertThat(found).isPresent();
        assertThat(found.get().getUsername()).isEqualTo("testuser");
    }

    @Test
    void findByUsername_whenNotExists_shouldReturnEmpty() {
        Optional<AccountEntity> found = accountRepository.findByUsername("unknown");
        assertThat(found).isEmpty();
    }

    @Test
    void findAll_shouldReturnAllAccounts() {
        accountRepository.save(testAccount);

        AccountEntity account2 = new AccountEntity();
        account2.setUsername("seconduser");
        account2.setPassword("password2");
        accountRepository.save(account2);

        entityManager.flush();
        entityManager.clear();

        List<AccountEntity> accounts = accountRepository.findAll();

        // assuming no seed data: should be exactly 2
        assertThat(accounts)
                .extracting(AccountEntity::getUsername)
                .contains("testuser", "seconduser");
    }

    @Test
    void update_shouldPersistChanges() {
        AccountEntity saved = accountRepository.save(testAccount);
        entityManager.flush();
        entityManager.clear();

        AccountEntity toUpdate = accountRepository.findById(saved.getId()).orElseThrow();
        toUpdate.setPassword("newHashedPassword");
        accountRepository.save(toUpdate);
        entityManager.flush();
        entityManager.clear();

        AccountEntity found = accountRepository.findById(saved.getId()).orElseThrow();
        assertThat(found.getPassword()).isEqualTo("newHashedPassword");
    }

    @Test
    void delete_shouldRemoveAccount() {
        AccountEntity saved = accountRepository.save(testAccount);
        entityManager.flush();

        Long id = saved.getId();
        accountRepository.deleteById(id);
        entityManager.flush();
        entityManager.clear();

        assertThat(accountRepository.findById(id)).isEmpty();
    }

    @Test
    void save_withoutUsername_shouldThrowConstraintViolationException() {
        testAccount.setUsername(null);

        assertThatThrownBy(() -> {
            accountRepository.save(testAccount);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void save_withoutPassword_shouldThrowConstraintViolationException() {
        testAccount.setPassword(null);

        assertThatThrownBy(() -> {
            accountRepository.save(testAccount);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void save_withBlankUsername_shouldThrowConstraintViolationException() {
        testAccount.setUsername("   ");

        assertThatThrownBy(() -> {
            accountRepository.save(testAccount);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void save_withTooLongUsername_shouldThrowConstraintViolationException() {
        testAccount.setUsername("a".repeat(256)); // @Size(max = 255)

        assertThatThrownBy(() -> {
            accountRepository.save(testAccount);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void save_withDuplicateUsername_shouldThrowDataIntegrityViolationException() {
        accountRepository.save(testAccount);
        entityManager.flush();

        AccountEntity duplicate = new AccountEntity();
        duplicate.setUsername("testuser");
        duplicate.setPassword("password");

        assertThatThrownBy(() -> {
            accountRepository.save(duplicate);
            entityManager.flush();
        }).isInstanceOf(DataIntegrityViolationException.class);
    }

    @Test
    void flags_shouldPersist() {
        testAccount.setFlags((byte) 5);

        AccountEntity saved = accountRepository.save(testAccount);
        entityManager.flush();
        entityManager.clear();

        AccountEntity found = accountRepository.findById(saved.getId()).orElseThrow();
        assertThat(found.getFlags()).isEqualTo((byte) 5);
    }

    @Test
    void accountUserRelationship_shouldBeReadableFromAccountSide() {
        // Account is inverse side (mappedBy="account"), so persist the owning side (UserEntity)
        UserEntity user = new UserEntity();
        user.setFirstName("John");
        user.setLastName("Doe");
        user.setEmail("john@example.com");
        user.setPhoneNumber("+123456");

        // Set both sides to keep object graph consistent
        user.setAccount(testAccount);
        testAccount.setUser(user);

        entityManager.persist(user);
        entityManager.flush();

        Long accountId = user.getAccount().getId();
        entityManager.clear();

        AccountEntity found = accountRepository.findById(accountId).orElseThrow();

        // user is LAZY in your UserEntity? Here, in @DataJpaTest transaction, accessing is OK.
        assertThat(found.getUser()).isNotNull();
        assertThat(found.getUser().getFirstName()).isEqualTo("John");
    }

    @Test
    void isAdmin_shouldReflectFlagsBitmaskLogic() {
        testAccount.setFlags(AccountEntity.FLAG_ADMIN);

        AccountEntity saved = accountRepository.save(testAccount);
        entityManager.flush();
        entityManager.clear();

        AccountEntity found = accountRepository.findById(saved.getId()).orElseThrow();
        assertThat(found.isAdmin()).isTrue();
        assertThat(found.hasFlag(AccountEntity.FLAG_ADMIN)).isTrue();
    }
}
