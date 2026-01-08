package eu.epitech.t_dev_700.entities;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.OffsetDateTime;

import static org.assertj.core.api.Assertions.assertThat;

class UserEntityTest {

    private UserEntity user;
    private AccountEntity account;

    @BeforeEach
    void setUp() {
        user = new UserEntity();
        user.setId(1L);
        user.setFirstName("John");
        user.setLastName("Doe");
        user.setEmail("john.doe@example.com");
        user.setPhoneNumber("+1234567890");

        account = new AccountEntity();
        account.setId(1L);
        account.setUsername("johndoe");
        account.setPassword("password");

        user.setAccount(account);
    }

    @Test
    void testGettersAndSetters() {
        assertThat(user.getId()).isEqualTo(1L);
        assertThat(user.getFirstName()).isEqualTo("John");
        assertThat(user.getLastName()).isEqualTo("Doe");
        assertThat(user.getEmail()).isEqualTo("john.doe@example.com");
        assertThat(user.getPhoneNumber()).isEqualTo("+1234567890");
        assertThat(user.getAccount()).isEqualTo(account);
        assertThat(user.getDeletedAt()).isNull();
    }

    @Test
    void testIsDeleted_whenNotDeleted_shouldReturnFalse() {
        assertThat(user.isDeleted()).isFalse();
    }

    @Test
    void testIsDeleted_whenDeleted_shouldReturnTrue() {
        user.setDeletedAt(OffsetDateTime.now());
        assertThat(user.isDeleted()).isTrue();
    }

    @Test
    void testEquals_sameId_shouldBeEqual() {
        UserEntity user2 = new UserEntity();
        user2.setId(1L);
        user2.setFirstName("Jane");

        assertThat(user).isEqualTo(user2);
    }

    @Test
    void testEquals_differentId_shouldNotBeEqual() {
        UserEntity user2 = new UserEntity();
        user2.setId(2L);
        user2.setFirstName("John");

        assertThat(user).isNotEqualTo(user2);
    }

    @Test
    void testEquals_nullId_shouldNotBeEqual() {
        UserEntity user2 = new UserEntity();
        user2.setFirstName("John");

        UserEntity user3 = new UserEntity();
        user3.setFirstName("Jane");

        assertThat(user2).isNotEqualTo(user3);
    }

    @Test
    void testEquals_sameInstance_shouldBeEqual() {
        assertThat(user).isEqualTo(user);
    }

    @Test
    void testEquals_null_shouldNotBeEqual() {
        assertThat(user).isNotEqualTo(null);
    }

    @Test
    void testEquals_differentClass_shouldNotBeEqual() {
        assertThat(user).isNotEqualTo("Some String");
    }

    @Test
    void testHashCode_sameId_shouldHaveSameHashCode() {
        UserEntity user2 = new UserEntity();
        user2.setId(1L);

        assertThat(user.hashCode()).isEqualTo(user2.hashCode());
    }

    @Test
    void testHashCode_differentId_shouldHaveDifferentHashCode() {
        UserEntity user2 = new UserEntity();
        user2.setId(2L);

        assertThat(user.hashCode()).isNotEqualTo(user2.hashCode());
    }

    @Test
    void testToString_shouldContainKeyInformation() {
        String toString = user.toString();
        assertThat(toString).contains("User");
        assertThat(toString).contains("id=1");
        assertThat(toString).contains("firstName='John'");
        assertThat(toString).contains("lastName='Doe'");
    }

    @Test
    void testSoftDelete() {
        assertThat(user.getDeletedAt()).isNull();

        OffsetDateTime deletionTime = OffsetDateTime.now();
        user.setDeletedAt(deletionTime);

        assertThat(user.getDeletedAt()).isEqualTo(deletionTime);
        assertThat(user.isDeleted()).isTrue();
    }
}
