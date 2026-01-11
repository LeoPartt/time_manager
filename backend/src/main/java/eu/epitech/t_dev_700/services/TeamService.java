package eu.epitech.t_dev_700.services;

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
import eu.epitech.t_dev_700.utils.CRUDHookUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TeamService extends CRUDService<
        TeamEntity,
        TeamModels.TeamResponse,
        TeamModels.PostTeamRequest,
        TeamModels.PutTeamRequest,
        TeamModels.PatchTeamRequest
        > {

    private final TeamMapper teamMapper;
    private final UserMapper userMapper;
    private final MembershipService membershipService;
    private final UserComponent userComponent;
    private final UserAuthorization userAuthorization;

    protected TeamService(
            TeamRepository teamRepository,
            TeamMapper teamMapper,
            UserMapper userMapper,
            MembershipService membershipService,
            UserComponent userComponent,
            UserAuthorization userAuthorization) {
        super(teamRepository, teamMapper, "team");
        this.teamMapper = teamMapper;
        this.userMapper = userMapper;
        this.membershipService = membershipService;
        this.userComponent = userComponent;
        this.userAuthorization = userAuthorization;
    }

    @CRUDHookUtils.CRUDHook(action = CRUDHookUtils.Action.CREATE, moment = CRUDHookUtils.Moment.AFTER)
    public void onTeamCreation(TeamEntity entity, TeamModels.PostTeamRequest request) {
        UserEntity currentUser = userAuthorization.getCurrentUser();
        if (currentUser == null) return;
        this.membershipService.createMembership(entity, currentUser, MembershipEntity.TeamRole.MANAGER);
    }

    @Transactional(readOnly = true)
    public TeamModels.TeamResponse[] getByUser(UserEntity user) {
        return teamMapper.listEntity(membershipService
                        .getMembershipsOfUser(user)
                        .stream()
                        .map(MembershipEntity::getTeam));
    }

    @Transactional(readOnly = true)
    public UserModels.UserResponse[] getByTeam(TeamEntity entity) {
        return userMapper.listEntity(membershipService
                .getMembershipsOfTeam(entity)
                .stream()
                .map(MembershipEntity::getUser));
    }

    @Transactional(readOnly = true)
    public UserModels.UserResponse[] getByTeam(Long id) {
        return this.getByTeam(this.findEntityOrThrow(id));
    }

    @Transactional
    public void postMembership(Long id, Long userId) {
        this.membershipService.createMembership(this.findEntityOrThrow(id), this.userComponent.getUser(userId));
    }

    @Transactional
    public void deleteMembership(Long id, Long userId) {
        this.membershipService.deleteMembership(this.findEntityOrThrow(id), this.userComponent.getUser(userId));
    }

    @Transactional(readOnly = true)
    public UserModels.UserResponse getManager(Long id) {
        return userMapper.toModel(this.membershipService.getManagerOfTeam(this.findEntityOrThrow(id)));
    }

    @Transactional
    public UserModels.UserResponse updateManager(Long id, Long userId) {
        UserEntity user = this.userComponent.getUser(userId);
        this.membershipService.updateManagerOfTeam(this.findEntityOrThrow(id), user);
        return userMapper.toModel(user);
    }

    @Transactional
    public void deleteManager(Long id) {
        this.membershipService.deleteManagerOfTeam(this.findEntityOrThrow(id));
    }
}
