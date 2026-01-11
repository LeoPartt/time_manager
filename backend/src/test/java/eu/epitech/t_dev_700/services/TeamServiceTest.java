package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.entities.MembershipEntity;
import eu.epitech.t_dev_700.entities.TeamEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.mappers.TeamMapper;
import eu.epitech.t_dev_700.mappers.UserMapper;
import eu.epitech.t_dev_700.models.TeamModels;
import eu.epitech.t_dev_700.models.UserModels;
import eu.epitech.t_dev_700.repositories.TeamRepository;
import eu.epitech.t_dev_700.services.components.UserAuthorization;
import eu.epitech.t_dev_700.services.components.UserComponent;
import eu.epitech.t_dev_700.services.exceptions.ResourceNotFound;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TeamServiceTest {

    @Mock private TeamRepository teamRepository;
    @Mock private TeamMapper teamMapper;
    @Mock private UserMapper userMapper;
    @Mock private MembershipService membershipService;
    @Mock private UserComponent userComponent;
    @Mock private UserAuthorization userAuthorization;

    @InjectMocks private TeamService teamService;

    private TeamEntity teamEntity;
    private TeamModels.TeamResponse teamResponse;
    private TeamModels.PostTeamRequest postRequest;
    private TeamModels.PutTeamRequest putRequest;
    private TeamModels.PatchTeamRequest patchRequest;

    private UserEntity currentUser;
    private UserEntity otherUser;

    @BeforeEach
    void setUp() {
        teamEntity = new TeamEntity();
        teamEntity.setId(1L);
        teamEntity.setName("Development Team");
        teamEntity.setDescription("A team of developers");

        teamResponse = new TeamModels.TeamResponse(
                1L,
                "Development Team",
                "A team of developers"
        );

        postRequest = new TeamModels.PostTeamRequest(
                "Development Team",
                "A team of developers"
        );

        putRequest = new TeamModels.PutTeamRequest(
                "Development Team Updated",
                "Updated description"
        );

        patchRequest = new TeamModels.PatchTeamRequest(
                null,
                "Patched description"
        );

        currentUser = new UserEntity();
        currentUser.setId(10L);
        currentUser.setAccount(new AccountEntity());

        otherUser = new UserEntity();
        otherUser.setId(20L);
        otherUser.setAccount(new AccountEntity());

        SecurityContext ctx = SecurityContextHolder.createEmptyContext();
        // principal can be currentUser or currentUser.getAccount() depending on your UserAuthorization implementation
        ctx.setAuthentication(new UsernamePasswordAuthenticationToken(currentUser.getAccount(), null, List.of()));
        SecurityContextHolder.setContext(ctx);
    }

    @AfterEach
    void tearDown() {
        SecurityContextHolder.clearContext();
    }

    // -------------------------
    // CRUDService inherited ops
    // -------------------------

    @Test
    void list_shouldReturnAllTeams() {
        List<TeamEntity> entities = Collections.singletonList(teamEntity);
        TeamModels.TeamResponse[] models = new TeamModels.TeamResponse[]{teamResponse};

        when(teamRepository.findAll()).thenReturn(entities);
        when(teamMapper.listEntity(entities)).thenReturn(models);

        TeamModels.TeamResponse[] result = teamService.list();

        assertThat(result).containsExactly(teamResponse);
        verify(teamRepository).findAll();
        verify(teamMapper).listEntity(entities);
        verifyNoMoreInteractions(teamRepository, teamMapper);
        verifyNoInteractions(membershipService, userMapper, userComponent);
    }

    @Test
    void get_whenExists_shouldReturnTeam() {
        when(teamRepository.findById(1L)).thenReturn(Optional.of(teamEntity));
        when(teamMapper.toModel(teamEntity)).thenReturn(teamResponse);

        TeamModels.TeamResponse result = teamService.get(1L);

        assertThat(result).isEqualTo(teamResponse);
        verify(teamRepository).findById(1L);
        verify(teamMapper).toModel(teamEntity);
        verifyNoMoreInteractions(teamRepository, teamMapper);
        verifyNoInteractions(membershipService, userMapper, userComponent);
    }

    @Test
    void get_whenMissing_shouldThrowResourceNotFound_withExactMessage() {
        when(teamRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> teamService.get(999L))
                .isInstanceOf(ResourceNotFound.class)
                .hasMessage("Resource 'team' #999 not found");

        verify(teamRepository).findById(999L);
        verifyNoInteractions(teamMapper);
    }

    @Test
    void get_whenMissing_shouldExposeDetails() {
        when(teamRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> teamService.get(999L))
                .isInstanceOf(ResourceNotFound.class)
                .satisfies(ex -> {
                    ResourceNotFound rn = (ResourceNotFound) ex;
                    assertThat(rn.details().resource()).isEqualTo("team");
                    assertThat(rn.details().id()).isEqualTo(999L);
                });
    }

    @Test
    void create_shouldCreateTeam() {
        when(teamMapper.createEntity(postRequest)).thenReturn(teamEntity);
        when(teamRepository.save(teamEntity)).thenReturn(teamEntity);
        when(teamMapper.toModel(teamEntity)).thenReturn(teamResponse);

        TeamModels.TeamResponse result = teamService.create(postRequest);

        assertThat(result).isEqualTo(teamResponse);
        verify(teamMapper).createEntity(postRequest);
        verify(teamRepository).save(teamEntity);
        verify(teamMapper).toModel(teamEntity);
        verifyNoMoreInteractions(teamRepository, teamMapper);
        verifyNoInteractions(membershipService, userMapper, userComponent);
    }

    @Test
    void replace_whenExists_shouldReplaceTeam() {
        when(teamRepository.findById(1L)).thenReturn(Optional.of(teamEntity));
        doNothing().when(teamMapper).replaceEntity(teamEntity, putRequest);
        when(teamRepository.save(teamEntity)).thenReturn(teamEntity);
        when(teamMapper.toModel(teamEntity)).thenReturn(teamResponse);

        TeamModels.TeamResponse result = teamService.replace(1L, putRequest);

        assertThat(result).isEqualTo(teamResponse);
        verify(teamRepository).findById(1L);
        verify(teamMapper).replaceEntity(teamEntity, putRequest);
        verify(teamRepository).save(teamEntity);
        verify(teamMapper).toModel(teamEntity);
        verifyNoMoreInteractions(teamRepository, teamMapper);
        verifyNoInteractions(membershipService, userMapper, userComponent);
    }

    @Test
    void replace_whenMissing_shouldThrowResourceNotFound() {
        when(teamRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> teamService.replace(999L, putRequest))
                .isInstanceOf(ResourceNotFound.class)
                .hasMessage("Resource 'team' #999 not found");

        verify(teamRepository).findById(999L);
        verifyNoMoreInteractions(teamRepository);
        verifyNoInteractions(teamMapper, membershipService, userMapper, userComponent);
    }

    @Test
    void update_whenExists_shouldUpdateTeam() {
        when(teamRepository.findById(1L)).thenReturn(Optional.of(teamEntity));
        doNothing().when(teamMapper).updateEntity(teamEntity, patchRequest);
        when(teamRepository.save(teamEntity)).thenReturn(teamEntity);
        when(teamMapper.toModel(teamEntity)).thenReturn(teamResponse);

        TeamModels.TeamResponse result = teamService.update(1L, patchRequest);

        assertThat(result).isEqualTo(teamResponse);
        verify(teamRepository).findById(1L);
        verify(teamMapper).updateEntity(teamEntity, patchRequest);
        verify(teamRepository).save(teamEntity);
        verify(teamMapper).toModel(teamEntity);
        verifyNoMoreInteractions(teamRepository, teamMapper);
        verifyNoInteractions(membershipService, userMapper, userComponent);
    }

    @Test
    void update_whenMissing_shouldThrowResourceNotFound() {
        when(teamRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> teamService.update(999L, patchRequest))
                .isInstanceOf(ResourceNotFound.class)
                .hasMessage("Resource 'team' #999 not found");

        verify(teamRepository).findById(999L);
        verifyNoMoreInteractions(teamRepository);
        verifyNoInteractions(teamMapper, membershipService, userMapper, userComponent);
    }

    @Test
    void delete_whenExists_shouldDeleteTeam() {
        when(teamRepository.findById(1L)).thenReturn(Optional.of(teamEntity));
        doNothing().when(teamRepository).delete(teamEntity);

        teamService.delete(1L);

        verify(teamRepository).findById(1L);
        verify(teamRepository).delete(teamEntity);
        verifyNoMoreInteractions(teamRepository);
        verifyNoInteractions(teamMapper, membershipService, userMapper, userComponent);
    }

    @Test
    void delete_whenMissing_shouldThrowResourceNotFound() {
        when(teamRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> teamService.delete(999L))
                .isInstanceOf(ResourceNotFound.class)
                .hasMessage("Resource 'team' #999 not found");

        verify(teamRepository).findById(999L);
        verifyNoMoreInteractions(teamRepository);
        verifyNoInteractions(teamMapper, membershipService, userMapper, userComponent);
    }

    @Test
    void findEntityOrThrow_whenExists_shouldReturnEntity() {
        when(teamRepository.findById(1L)).thenReturn(Optional.of(teamEntity));

        TeamEntity result = teamService.findEntityOrThrow(1L);

        assertThat(result).isSameAs(teamEntity);
        verify(teamRepository).findById(1L);
        verifyNoMoreInteractions(teamRepository);
        verifyNoInteractions(teamMapper, membershipService, userMapper, userComponent);
    }

    @Test
    void findEntityOrThrow_whenMissing_shouldThrowResourceNotFound_withExactMessage() {
        when(teamRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> teamService.findEntityOrThrow(999L))
                .isInstanceOf(ResourceNotFound.class)
                .hasMessage("Resource 'team' #999 not found");

        verify(teamRepository).findById(999L);
    }

    // -------------------------
    // TeamService-specific ops
    // -------------------------

    @Test
    void onTeamCreation_whenNoCurrentUser_shouldDoNothing() {
        try (MockedStatic<UserAuthorization> mocked = Mockito.mockStatic(UserAuthorization.class)) {
            mocked.when(userAuthorization::getCurrentUser).thenReturn(null);

            teamService.onTeamCreation(teamEntity, postRequest);

            verifyNoInteractions(membershipService);
        }
    }

    @Test
    void onTeamCreation_whenCurrentUser_shouldCreateManagerMembership() {
        try (MockedStatic<UserAuthorization> mocked = Mockito.mockStatic(UserAuthorization.class)) {
            mocked.when(userAuthorization::getCurrentUser).thenReturn(currentUser);

            teamService.onTeamCreation(teamEntity, postRequest);

            verify(membershipService).createMembership(teamEntity, currentUser, MembershipEntity.TeamRole.MANAGER);
            verifyNoMoreInteractions(membershipService);
        }
    }

    @Test
    @SuppressWarnings("unchecked")
    void getByUser_shouldMapMembershipTeams_andPassCorrectTeamsToMapper() {
        MembershipEntity m = new MembershipEntity();
        m.setTeam(teamEntity);

        TeamModels.TeamResponse[] expected = new TeamModels.TeamResponse[]{teamResponse};

        when(membershipService.getMembershipsOfUser(currentUser)).thenReturn(List.of(m));

        ArgumentCaptor<java.util.stream.Stream<TeamEntity>> captor =
                ArgumentCaptor.forClass((Class) java.util.stream.Stream.class);

        when(teamMapper.listEntity(captor.capture())).thenReturn(expected);

        TeamModels.TeamResponse[] result = teamService.getByUser(currentUser);

        assertThat(result).containsExactly(teamResponse);

        // stream is single-use; consume once
        assertThat(captor.getValue().toList()).containsExactly(teamEntity);

        verify(membershipService).getMembershipsOfUser(currentUser);
        verify(teamMapper).listEntity(any(java.util.stream.Stream.class));
        verifyNoMoreInteractions(membershipService, teamMapper);
        verifyNoInteractions(teamRepository, userMapper, userComponent);
    }

    @Test
    @SuppressWarnings("unchecked")
    void getByTeam_entity_shouldMapMembershipUsers() {
        MembershipEntity m = new MembershipEntity();
        m.setUser(otherUser);

        UserModels.UserResponse otherUserResponse = mock(UserModels.UserResponse.class);
        UserModels.UserResponse[] expected = new UserModels.UserResponse[]{otherUserResponse};

        when(membershipService.getMembershipsOfTeam(teamEntity)).thenReturn(List.of(m));

        when(userMapper.listEntity(any(java.util.stream.Stream.class))).thenReturn(expected);

        UserModels.UserResponse[] result = teamService.getByTeam(teamEntity);

        assertThat(result).containsExactly(otherUserResponse);
        verify(membershipService).getMembershipsOfTeam(teamEntity);
        verify(userMapper).listEntity(any(java.util.stream.Stream.class));
        verifyNoMoreInteractions(membershipService, userMapper);
        verifyNoInteractions(teamRepository, teamMapper, userComponent);
    }

    @Test
    @SuppressWarnings("unchecked")
    void getByTeam_entity_shouldMapMembershipUsers_andPassCorrectUsersToMapper() {
        MembershipEntity m = new MembershipEntity();
        m.setUser(otherUser);

        UserModels.UserResponse otherUserResponse = mock(UserModels.UserResponse.class);
        UserModels.UserResponse[] expected = new UserModels.UserResponse[]{otherUserResponse};

        when(membershipService.getMembershipsOfTeam(teamEntity)).thenReturn(List.of(m));

        ArgumentCaptor<java.util.stream.Stream<UserEntity>> captor =
                ArgumentCaptor.forClass((Class) java.util.stream.Stream.class);

        when(userMapper.listEntity(captor.capture())).thenReturn(expected);

        UserModels.UserResponse[] result = teamService.getByTeam(teamEntity);

        assertThat(result).containsExactly(otherUserResponse);

        // ⚠️ Streams are single-use; only consume it once
        List<UserEntity> passedUsers = captor.getValue().toList();
        assertThat(passedUsers).containsExactly(otherUser);

        verify(membershipService).getMembershipsOfTeam(teamEntity);
        verify(userMapper).listEntity(any(java.util.stream.Stream.class));
        verifyNoMoreInteractions(membershipService, userMapper);
        verifyNoInteractions(teamRepository, teamMapper, userComponent);
    }

    @Test
    @SuppressWarnings("unchecked")
    void getByTeam_id_shouldPassEmptyUsersStreamToMapper() {
        TeamService spy = Mockito.spy(teamService);
        doReturn(teamEntity).when(spy).findEntityOrThrow(1L);

        when(membershipService.getMembershipsOfTeam(teamEntity)).thenReturn(List.of());

        ArgumentCaptor<java.util.stream.Stream<UserEntity>> captor =
                ArgumentCaptor.forClass((Class) java.util.stream.Stream.class);

        when(userMapper.listEntity(captor.capture()))
                .thenReturn(new UserModels.UserResponse[]{});

        UserModels.UserResponse[] result = spy.getByTeam(1L);

        assertThat(result).isEmpty();
        assertThat(captor.getValue().toList()).isEmpty(); // consume once

        verify(spy).findEntityOrThrow(1L);
        verify(membershipService).getMembershipsOfTeam(teamEntity);
        verify(userMapper).listEntity(any(java.util.stream.Stream.class));
    }

    @Test
    void postMembership_shouldCreateMembershipForTeamAndUser() {
        TeamService spy = Mockito.spy(teamService);
        doReturn(teamEntity).when(spy).findEntityOrThrow(1L);
        when(userComponent.getUser(20L)).thenReturn(otherUser);

        spy.postMembership(1L, 20L);

        verify(spy).findEntityOrThrow(1L);
        verify(userComponent).getUser(20L);
        verify(membershipService).createMembership(teamEntity, otherUser);
        verifyNoMoreInteractions(membershipService);
    }

    @Test
    void deleteMembership_shouldDeleteMembershipForTeamAndUser() {
        TeamService spy = Mockito.spy(teamService);
        doReturn(teamEntity).when(spy).findEntityOrThrow(1L);
        when(userComponent.getUser(20L)).thenReturn(otherUser);

        spy.deleteMembership(1L, 20L);

        verify(spy).findEntityOrThrow(1L);
        verify(userComponent).getUser(20L);
        verify(membershipService).deleteMembership(teamEntity, otherUser);
        verifyNoMoreInteractions(membershipService);
    }

    @Test
    void getManager_shouldReturnMappedManager() {
        UserModels.UserResponse managerModel = mock(UserModels.UserResponse.class);

        TeamService spy = Mockito.spy(teamService);
        doReturn(teamEntity).when(spy).findEntityOrThrow(1L);
        when(membershipService.getManagerOfTeam(teamEntity)).thenReturn(currentUser);
        when(userMapper.toModel(currentUser)).thenReturn(managerModel);

        UserModels.UserResponse result = spy.getManager(1L);

        assertThat(result).isSameAs(managerModel);
        verify(spy).findEntityOrThrow(1L);
        verify(membershipService).getManagerOfTeam(teamEntity);
        verify(userMapper).toModel(currentUser);
        verifyNoMoreInteractions(membershipService, userMapper);
    }

    @Test
    void updateManager_shouldUpdateAndReturnMappedUser() {
        UserModels.UserResponse updatedManagerModel = mock(UserModels.UserResponse.class);

        TeamService spy = Mockito.spy(teamService);
        doReturn(teamEntity).when(spy).findEntityOrThrow(1L);
        when(userComponent.getUser(20L)).thenReturn(otherUser);
        when(userMapper.toModel(otherUser)).thenReturn(updatedManagerModel);

        UserModels.UserResponse result = spy.updateManager(1L, 20L);

        assertThat(result).isSameAs(updatedManagerModel);
        verify(spy).findEntityOrThrow(1L);
        verify(userComponent).getUser(20L);
        verify(membershipService).updateManagerOfTeam(teamEntity, otherUser);
        verify(userMapper).toModel(otherUser);
        verifyNoMoreInteractions(membershipService, userMapper);
    }

    @Test
    void deleteManager_shouldDelegateToMembershipService() {
        TeamService spy = Mockito.spy(teamService);
        doReturn(teamEntity).when(spy).findEntityOrThrow(1L);

        spy.deleteManager(1L);

        verify(spy).findEntityOrThrow(1L);
        verify(membershipService).deleteManagerOfTeam(teamEntity);
        verifyNoMoreInteractions(membershipService);
    }
}
