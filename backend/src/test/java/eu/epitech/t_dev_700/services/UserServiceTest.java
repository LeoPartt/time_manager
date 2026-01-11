package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.mappers.UserMapper;
import eu.epitech.t_dev_700.models.PlanningModels;
import eu.epitech.t_dev_700.models.TeamModels;
import eu.epitech.t_dev_700.models.UserModels;
import eu.epitech.t_dev_700.models.UserScheduleQuery;
import eu.epitech.t_dev_700.repositories.UserRepository;
import eu.epitech.t_dev_700.services.components.UserAuthorization;
import eu.epitech.t_dev_700.services.exceptions.ResourceNotFound;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock private UserRepository userRepository;
    @Mock private UserMapper userMapper;

    @Mock private TeamService teamService;
    @Mock private ClockService clockService;
    @Mock private PlanningService planningService;
    @Mock private UserAuthorization userAuthorization;

    @InjectMocks private UserService userService;

    private UserEntity userEntity;
    private UserModels.UserResponse userResponse;
    private UserModels.PostUserRequest postRequest;
    private UserModels.PutUserRequest putRequest;
    private UserModels.PatchUserRequest patchRequest;

    @BeforeEach
    void setUp() {
        AccountEntity account = new AccountEntity();
        account.setId(1L);
        account.setUsername("johndoe");
        account.setPassword("hashedPassword");

        userEntity = new UserEntity();
        userEntity.setId(1L);
        userEntity.setFirstName("John");
        userEntity.setLastName("Doe");
        userEntity.setEmail("john.doe@example.com");
        userEntity.setPhoneNumber("+1234567890");
        userEntity.setAccount(account);

        userResponse = new UserModels.UserResponse(
                1L,
                "johndoe",
                "John",
                "Doe",
                "john.doe@example.com",
                "+1234567890",
                false,
                false
        );

        postRequest = new UserModels.PostUserRequest(
                "johndoe",
                "password123",
                "John",
                "Doe",
                "john.doe@example.com",
                "+1234567890"
        );

        putRequest = new UserModels.PutUserRequest(
                "johndoe",
                "John",
                "Doe",
                "john.doe@example.com",
                "+1234567890"
        );

        patchRequest = new UserModels.PatchUserRequest(
                null,
                "Jane",
                null,
                null,
                null
        );
    }

    @Test
    void testList_shouldReturnAllUsers() {
        List<UserEntity> entities = Collections.singletonList(userEntity);
        UserModels.UserResponse[] models = new UserModels.UserResponse[]{userResponse};

        when(userRepository.findAll()).thenReturn(entities);
        when(userMapper.listEntity(entities)).thenReturn(models);

        UserModels.UserResponse[] result = userService.list();

        assertThat(result).hasSize(1);
        assertThat(result[0]).isEqualTo(userResponse);
        verify(userRepository).findAll();
        verify(userMapper).listEntity(entities);
    }

    @Test
    void testGet_whenUserExists_shouldReturnUser() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(userEntity));
        when(userMapper.toModel(userEntity)).thenReturn(userResponse);

        UserModels.UserResponse result = userService.get(1L);

        assertThat(result).isEqualTo(userResponse);
        verify(userRepository).findById(1L);
        verify(userMapper).toModel(userEntity);
    }

    @Test
    void testGet_whenUserNotExists_shouldThrowException() {
        when(userRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> userService.get(999L))
                .isInstanceOf(ResourceNotFound.class);

        verify(userRepository).findById(999L);
        verify(userMapper, never()).toModel(any());
    }

    @Test
    void testCreate_shouldCreateUser() {
        when(userMapper.createEntity(postRequest)).thenReturn(userEntity);
        when(userRepository.save(userEntity)).thenReturn(userEntity);
        when(userMapper.toModel(userEntity)).thenReturn(userResponse);

        UserModels.UserResponse result = userService.create(postRequest);

        assertThat(result).isEqualTo(userResponse);
        verify(userMapper).createEntity(postRequest);
        verify(userRepository).save(userEntity);
        verify(userMapper).toModel(userEntity);
    }

    @Test
    void testReplace_whenUserExists_shouldReplaceUser() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(userEntity));
        doNothing().when(userMapper).replaceEntity(userEntity, putRequest);
        when(userRepository.save(userEntity)).thenReturn(userEntity);
        when(userMapper.toModel(userEntity)).thenReturn(userResponse);

        UserModels.UserResponse result = userService.replace(1L, putRequest);

        assertThat(result).isEqualTo(userResponse);
        verify(userRepository).findById(1L);
        verify(userMapper).replaceEntity(userEntity, putRequest);
        verify(userRepository).save(userEntity);
        verify(userMapper).toModel(userEntity);
    }

    @Test
    void testReplace_whenUserNotExists_shouldThrowException() {
        when(userRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> userService.replace(999L, putRequest))
                .isInstanceOf(ResourceNotFound.class);

        verify(userRepository).findById(999L);
        verify(userMapper, never()).replaceEntity(any(), any());
        verify(userRepository, never()).save(any());
    }

    @Test
    void testUpdate_whenUserExists_shouldUpdateUser() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(userEntity));
        doNothing().when(userMapper).updateEntity(userEntity, patchRequest);
        when(userRepository.save(userEntity)).thenReturn(userEntity);
        when(userMapper.toModel(userEntity)).thenReturn(userResponse);

        UserModels.UserResponse result = userService.update(1L, patchRequest);

        assertThat(result).isEqualTo(userResponse);
        verify(userRepository).findById(1L);
        verify(userMapper).updateEntity(userEntity, patchRequest);
        verify(userRepository).save(userEntity);
        verify(userMapper).toModel(userEntity);
    }

    @Test
    void testUpdate_whenUserNotExists_shouldThrowException() {
        when(userRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> userService.update(999L, patchRequest))
                .isInstanceOf(ResourceNotFound.class);

        verify(userRepository).findById(999L);
        verify(userMapper, never()).updateEntity(any(), any());
        verify(userRepository, never()).save(any());
    }

    @Test
    void testDelete_whenUserExists_shouldDeleteUser() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(userEntity));
        doNothing().when(userRepository).delete(userEntity);

        userService.delete(1L);

        verify(userRepository).findById(1L);
        verify(userRepository).delete(userEntity);
    }

    @Test
    void testDelete_whenUserNotExists_shouldThrowException() {
        when(userRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> userService.delete(999L))
                .isInstanceOf(ResourceNotFound.class);

        verify(userRepository).findById(999L);
        verify(userRepository, never()).delete(any());
    }

    @Test
    void testFindEntityOrThrow_whenUserExists_shouldReturnUser() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(userEntity));

        UserEntity result = userService.findEntityOrThrow(1L);

        assertThat(result).isEqualTo(userEntity);
        verify(userRepository).findById(1L);
    }

    @Test
    void testFindEntityOrThrow_whenUserNotExists_shouldThrowException() {
        when(userRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> userService.findEntityOrThrow(999L))
                .isInstanceOf(ResourceNotFound.class)
                .hasMessageContaining("User")
                .hasMessageContaining("999");

        verify(userRepository).findById(999L);
    }

    // -----------------------------
    // NEW TESTS for UserService API
    // -----------------------------

    @Test
    void testGetCurrentUser_shouldReturnMappedUser() {
        when(userAuthorization.getCurrentUser()).thenReturn(userEntity);
        when(userRepository.findById(1L)).thenReturn(Optional.ofNullable(userEntity));
        when(userMapper.toModel(userEntity)).thenReturn(userResponse);

        UserModels.UserResponse result = userService.getCurrentUser();

        assertThat(result).isEqualTo(userResponse);
        verify(userAuthorization).getCurrentUser();
        verify(userMapper).toModel(userEntity);
        verifyNoMoreInteractions(userAuthorization, userMapper);
    }

    @Test
    void testGetTeams_shouldReturnTeamsForUser() {
        TeamModels.TeamResponse[] teams = new TeamModels.TeamResponse[0];

        when(userRepository.findById(1L)).thenReturn(Optional.of(userEntity));
        when(teamService.getByUser(userEntity)).thenReturn(teams);

        TeamModels.TeamResponse[] result = userService.getTeams(1L);

        assertThat(result).isSameAs(teams);
        verify(userRepository).findById(1L);
        verify(teamService).getByUser(userEntity);
    }

    @Test
    void testGetClocks_shouldDelegateToClockService() {
        UserScheduleQuery query = new UserScheduleQuery();
        Long[] clocks = new Long[]{1L, 2L};

        when(clockService.getUserClocks(1L, query)).thenReturn(clocks);

        Long[] result = userService.getClocks(1L, query);

        assertThat(result).isSameAs(clocks);
        verify(clockService).getUserClocks(1L, query);
    }

    @Test
    void testGetPlannings_shouldReturnPlanningsForUser() {
        PlanningModels.PlanningResponse[] plannings = new PlanningModels.PlanningResponse[0];

        when(userRepository.findById(1L)).thenReturn(Optional.of(userEntity));
        when(planningService.listForUser(userEntity)).thenReturn(plannings);

        PlanningModels.PlanningResponse[] result = userService.getPlannings(1L);

        assertThat(result).isSameAs(plannings);
        verify(userRepository).findById(1L);
        verify(planningService).listForUser(userEntity);
    }

    @Test
    void testCreatePlanning_shouldDelegateToPlanningService() {
        PlanningModels.PostPlanningRequest body = mock(PlanningModels.PostPlanningRequest.class);
        PlanningModels.PlanningResponse created = mock(PlanningModels.PlanningResponse.class);

        when(planningService.create(body)).thenReturn(created);

        PlanningModels.PlanningResponse result = userService.createPlanning(body);

        assertThat(result).isSameAs(created);
        verify(planningService).create(body);
    }
}
