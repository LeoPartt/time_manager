package eu.epitech.t_dev_700.mappers;

import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.models.UserModels;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatCode;
import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(classes = {
        UserMapperImpl.class,
        PasswordMapperImpl.class
})
class UserMapperTest {

    @Autowired
    private UserMapper userMapper;

    @MockitoBean
    private PasswordEncoder passwordEncoder;

    private UserEntity userEntity;
    private AccountEntity accountEntity;

    @BeforeEach
    void setUp() {
        accountEntity = new AccountEntity();
        accountEntity.setId(1L);
        accountEntity.setUsername("johndoe");
        accountEntity.setPassword("hashedPassword");

        userEntity = new UserEntity();
        userEntity.setId(1L);
        userEntity.setFirstName("John");
        userEntity.setLastName("Doe");
        userEntity.setEmail("john.doe@example.com");
        userEntity.setPhoneNumber("+1234567890");

        userEntity.setAccount(accountEntity);
        accountEntity.setUser(userEntity);

        when(passwordEncoder.encode(anyString())).thenReturn("encoded");
        when(passwordEncoder.matches(anyString(), anyString())).thenReturn(true);
    }

    @Test
    void testToModel_shouldMapEntityToModel() {
        UserModels.UserResponse model = userMapper.toModel(userEntity);

        assertThat(model).isNotNull();
        assertThat(model.id()).isEqualTo(1L);
        assertThat(model.username()).isEqualTo("johndoe");
        assertThat(model.firstName()).isEqualTo("John");
        assertThat(model.lastName()).isEqualTo("Doe");
        assertThat(model.email()).isEqualTo("john.doe@example.com");
        assertThat(model.phoneNumber()).isEqualTo("+1234567890");
        assertThat(model.isManager()).isEqualTo(userEntity.isManager());
        assertThat(model.isAdministrator()).isEqualTo(accountEntity.isAdmin());
    }

    @Test
    void testListEntity_shouldMapEntitiesToModels() {
        UserEntity user2 = new UserEntity();
        user2.setId(2L);
        user2.setFirstName("Jane");
        user2.setLastName("Smith");
        user2.setEmail("jane@example.com");
        user2.setPhoneNumber("+0987654321");

        AccountEntity account2 = new AccountEntity();
        account2.setId(2L);
        account2.setUsername("janesmith");
        account2.setPassword("password");

        user2.setAccount(account2);
        account2.setUser(user2);

        List<UserEntity> entities = Arrays.asList(userEntity, user2);

        UserModels.UserResponse[] models = userMapper.listEntity(entities);

        assertThat(models).hasSize(2);

        assertThat(models[0].id()).isEqualTo(1L);
        assertThat(models[0].username()).isEqualTo("johndoe");
        assertThat(models[0].isManager()).isEqualTo(userEntity.isManager());
        assertThat(models[0].isAdministrator()).isEqualTo(userEntity.getAccount().isAdmin());

        assertThat(models[1].id()).isEqualTo(2L);
        assertThat(models[1].username()).isEqualTo("janesmith");
        assertThat(models[1].isManager()).isEqualTo(user2.isManager());
        assertThat(models[1].isAdministrator()).isEqualTo(user2.getAccount().isAdmin());
    }

    @Test
    void testCreateEntity_shouldMapRequestToEntity() {
        UserModels.PostUserRequest request = new UserModels.PostUserRequest(
                "newuser",
                "plainPassword",
                "Alice",
                "Wonder",
                "alice@example.com",
                "+1112223333"
        );

        UserEntity entity = userMapper.createEntity(request);

        assertThat(entity).isNotNull();
        assertThat(entity.getId()).isNull();
        assertThat(entity.getFirstName()).isEqualTo("Alice");
        assertThat(entity.getLastName()).isEqualTo("Wonder");
        assertThat(entity.getEmail()).isEqualTo("alice@example.com");
        assertThat(entity.getPhoneNumber()).isEqualTo("+1112223333");

        assertThat(entity.getAccount()).isNotNull();
        assertThat(entity.getAccount().getUsername()).isEqualTo("newuser");
        assertThat(entity.getAccount().getPassword()).isNotBlank();

        assertThat(passwordEncoder.matches("plainPassword", entity.getAccount().getPassword())).isTrue();
    }

    @Test
    void testCreateEntity_withNullPassword_shouldNotEncode() {
        UserModels.PostUserRequest request = new UserModels.PostUserRequest(
                "newuser",
                null,
                "Alice",
                "Wonder",
                "alice@example.com",
                "+1112223333"
        );

        UserEntity entity = userMapper.createEntity(request);

        assertThat(entity.getAccount()).isNotNull();
        assertThat(entity.getAccount().getPassword()).isNull();
    }

    @Test
    void testCreateEntity_withBlankPassword_shouldNotEncode() {
        UserModels.PostUserRequest request = new UserModels.PostUserRequest(
                "newuser",
                "   ",
                "Alice",
                "Wonder",
                "alice@example.com",
                "+1112223333"
        );

        UserEntity entity = userMapper.createEntity(request);

        assertThat(entity.getAccount()).isNotNull();
        assertThat(entity.getAccount().getPassword()).isEqualTo("   ");
    }

    @Test
    void testReplaceEntity_shouldUpdateAllFields() {
        UserModels.PutUserRequest request = new UserModels.PutUserRequest(
                "updatedjohn",
                "UpdatedJohn",
                "UpdatedDoe",
                "updated@example.com",
                "+9999999999"
        );

        userMapper.replaceEntity(userEntity, request);

        assertThat(userEntity.getFirstName()).isEqualTo("UpdatedJohn");
        assertThat(userEntity.getLastName()).isEqualTo("UpdatedDoe");
        assertThat(userEntity.getEmail()).isEqualTo("updated@example.com");
        assertThat(userEntity.getPhoneNumber()).isEqualTo("+9999999999");
        assertThat(userEntity.getAccount().getUsername()).isEqualTo("updatedjohn");
    }

    @Test
    void testUpdateEntity_shouldUpdateOnlyProvidedFields() {
        UserModels.PatchUserRequest request = new UserModels.PatchUserRequest(
                "newusername",
                "Jane",
                null,
                "newemail@example.com",
                null
        );

        String originalLastName = userEntity.getLastName();
        String originalPhone = userEntity.getPhoneNumber();

        userMapper.updateEntity(userEntity, request);

        assertThat(userEntity.getFirstName()).isEqualTo("Jane");
        assertThat(userEntity.getLastName()).isEqualTo(originalLastName);
        assertThat(userEntity.getEmail()).isEqualTo("newemail@example.com");
        assertThat(userEntity.getPhoneNumber()).isEqualTo(originalPhone);
        assertThat(userEntity.getAccount().getUsername()).isEqualTo("newusername");
    }

    @Test
    void testUpdateEntity_withAllNulls_shouldNotChangeEntity_includingUsername() {
        UserModels.PatchUserRequest request = new UserModels.PatchUserRequest(
                null, null, null, null, null
        );

        String originalFirstName = userEntity.getFirstName();
        String originalLastName = userEntity.getLastName();
        String originalEmail = userEntity.getEmail();
        String originalPhone = userEntity.getPhoneNumber();
        String originalUsername = userEntity.getAccount().getUsername();

        userMapper.updateEntity(userEntity, request);

        assertThat(userEntity.getFirstName()).isEqualTo(originalFirstName);
        assertThat(userEntity.getLastName()).isEqualTo(originalLastName);
        assertThat(userEntity.getEmail()).isEqualTo(originalEmail);
        assertThat(userEntity.getPhoneNumber()).isEqualTo(originalPhone);
        assertThat(userEntity.getAccount().getUsername()).isEqualTo(originalUsername);
    }

    @Test
    void testListEntity_stream_shouldMapEntitiesToModels() {
        UserEntity user2 = new UserEntity();
        AccountEntity account2 = new AccountEntity();
        account2.setUsername("janesmith");
        user2.setId(2L);
        user2.setFirstName("Jane");
        user2.setAccount(account2);
        account2.setUser(user2);

        UserModels.UserResponse[] models = userMapper.listEntity(Stream.of(userEntity, user2));

        assertThat(models).hasSize(2);
        assertThat(models[0].username()).isEqualTo("johndoe");
        assertThat(models[1].username()).isEqualTo("janesmith");
    }

    @Test
    void replaceAccountUsername_whenUserNull_shouldReturnWithoutThrowing() {
        UserModels.PutUserRequest req = new UserModels.PutUserRequest(
                "updatedjohn", "UpdatedJohn", "UpdatedDoe", "updated@example.com", "+9999999999"
        );

        assertThatCode(() -> userMapper.replaceAccountUsername(req, null))
                .doesNotThrowAnyException();
    }

    @Test
    void replaceEntity_whenAccountNull_shouldCreateAccount_setBackReference_andSetUsername() {
        UserEntity entity = new UserEntity();
        entity.setAccount(null); // force acc == null branch

        UserModels.PutUserRequest req = new UserModels.PutUserRequest(
                "newusername", "Fn", "Ln", "a@b.com", "123"
        );

        userMapper.replaceEntity(entity, req);

        assertThat(entity.getAccount()).isNotNull();
        assertThat(entity.getAccount().getUser()).isSameAs(entity);  // acc.setUser(user)
        assertThat(entity.getAccount().getUsername()).isEqualTo("newusername");
    }

    @Test
    void updateAccountUsername_whenUserNull_shouldReturnWithoutThrowing() {
        UserModels.PatchUserRequest req = new UserModels.PatchUserRequest(
                "u", null, null, null, null
        );

        assertThatCode(() -> userMapper.updateAccountUsername(req, null))
                .doesNotThrowAnyException();
    }

    @Test
    void updateAccountUsername_whenUsernameNull_shouldNotCreateOrModifyAccount() {
        UserEntity entity = new UserEntity();
        entity.setAccount(null); // if method were wrong, it would create it

        UserModels.PatchUserRequest req = new UserModels.PatchUserRequest(
                null, "Jane", null, null, null
        );

        // call mapper update, which triggers @AfterMapping
        userMapper.updateEntity(entity, req);

        assertThat(entity.getAccount()).isNull();
    }

    @Test
    void updateEntity_whenAccountNull_andUsernameProvided_shouldCreateAccount_setBackReference_andSetUsername() {
        UserEntity entity = new UserEntity();
        entity.setAccount(null); // force acc == null branch

        UserModels.PatchUserRequest req = new UserModels.PatchUserRequest(
                "fresh", null, null, null, null
        );

        userMapper.updateEntity(entity, req);

        assertThat(entity.getAccount()).isNotNull();
        assertThat(entity.getAccount().getUser()).isSameAs(entity);
        assertThat(entity.getAccount().getUsername()).isEqualTo("fresh");
    }

    @Test
    void toModel_whenEntityNull_shouldReturnNull() {
        assertThat(userMapper.toModel(null)).isNull();
    }

    @Test
    void toModel_whenAccountNull_shouldMapUsernameNull_andIsAdministratorFalse() {
        UserEntity u = new UserEntity();
        u.setId(1L);
        u.setFirstName("John");
        u.setAccount(null); // forces entityAccountUsername + entityAccountAdmin null branches

        UserModels.UserResponse res = userMapper.toModel(u);

        assertThat(res).isNotNull();
        assertThat(res.username()).isNull();
        assertThat(res.isAdministrator()).isFalse();
    }

    @Test
    void createEntity_whenReqNull_shouldReturnNull() {
        assertThat(userMapper.createEntity(null)).isNull();
    }

    @Test
    void generatedImpl_postUserRequestToAccountEntity_null_shouldReturnNull() throws Exception {
        UserMapperImpl impl = (UserMapperImpl) userMapper;

        Method m = UserMapperImpl.class.getDeclaredMethod(
                "postUserRequestToAccountEntity",
                UserModels.PostUserRequest.class
        );
        m.setAccessible(true);

        Object out = assertDoesNotThrow(() -> m.invoke(impl, new Object[]{null}));

        assertThat(out).isNull();
    }

    @Test
    void replaceEntity_whenBodyNull_shouldDoNothing() {
        UserEntity u = new UserEntity();
        u.setFirstName("Before");

        userMapper.replaceEntity(u, null);

        assertThat(u.getFirstName()).isEqualTo("Before"); // unchanged
    }

    @Test
    void updateEntity_whenBodyNull_shouldDoNothing() {
        UserEntity u = new UserEntity();
        u.setFirstName("Before");

        userMapper.updateEntity(u, null);

        assertThat(u.getFirstName()).isEqualTo("Before"); // unchanged
    }

    @Test
    void updateEntity_whenSomeFieldsNull_shouldNotOverwriteThoseFields() {
        UserModels.PatchUserRequest req = new UserModels.PatchUserRequest(
                "changedUsername", // keep non-null to execute after-mapping path
                null,              // firstName null -> branch false
                null,              // lastName null -> branch false
                null,              // email null -> branch false
                null               // phone null -> branch false
        );

        String originalFirstName = userEntity.getFirstName();
        String originalLastName = userEntity.getLastName();
        String originalEmail = userEntity.getEmail();
        String originalPhone = userEntity.getPhoneNumber();

        userMapper.updateEntity(userEntity, req);

        assertThat(userEntity.getFirstName()).isEqualTo(originalFirstName);
        assertThat(userEntity.getLastName()).isEqualTo(originalLastName);
        assertThat(userEntity.getEmail()).isEqualTo(originalEmail);
        assertThat(userEntity.getPhoneNumber()).isEqualTo(originalPhone);

        assertThat(userEntity.getAccount().getUsername()).isEqualTo("changedUsername");
    }

    @Test
    void updateEntity_whenLastNameAndPhoneProvided_shouldUpdateThoseFields() {
        // Arrange
        userEntity.setFirstName("John");
        userEntity.setLastName("Doe");
        userEntity.setEmail("john.doe@example.com");
        userEntity.setPhoneNumber("+111111111");

        UserModels.PatchUserRequest req = new UserModels.PatchUserRequest(
                null,          // username (keep null so updateAccountUsername returns early)
                null,          // firstName
                "NewLastName", // ✅ lastName -> should hit the branch
                null,          // email
                "+222222222"   // ✅ phoneNumber -> should hit the branch
        );

        // Act
        userMapper.updateEntity(userEntity, req);

        // Assert: updated fields
        assertThat(userEntity.getLastName()).isEqualTo("NewLastName");
        assertThat(userEntity.getPhoneNumber()).isEqualTo("+222222222");

        // Assert: untouched fields
        assertThat(userEntity.getFirstName()).isEqualTo("John");
        assertThat(userEntity.getEmail()).isEqualTo("john.doe@example.com");
    }

}
