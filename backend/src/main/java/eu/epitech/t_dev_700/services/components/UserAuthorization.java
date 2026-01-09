package eu.epitech.t_dev_700.services.components;

import eu.epitech.t_dev_700.doc.ApiAuthRoles;
import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.services.MembershipService;
import eu.epitech.t_dev_700.services.PlanningService;
import eu.epitech.t_dev_700.utils.AuthRole;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Component("userAuth")
@RequiredArgsConstructor
public class UserAuthorization {

    private final MembershipService membershipService;
    private final PlanningService planningService;

    public static UserEntity getCurrentUser(Authentication auth) {
        return ((AccountEntity) auth.getPrincipal()).getUser();
    }

    public static UserEntity getCurrentUser() {
        return getCurrentUser(SecurityContextHolder
                .getContext()
                .getAuthentication());
    }

    @ApiAuthRoles(AuthRole.ADMINISTRATOR)
    public boolean isAdministrator(Authentication authentication) {
        return ((AccountEntity) authentication.getPrincipal()).isAdmin();
    }

    @ApiAuthRoles(AuthRole.MEMBER_OF)
    public boolean isMemberOfTeam(Authentication authentication, Long teamId) {
        UserEntity currentUser = getCurrentUser(authentication);
        return isAdministrator(authentication)
               || membershipService.isUserMemberOfTeam(currentUser, teamId);
    }

    @ApiAuthRoles({AuthRole.MEMBER_OF, AuthRole.MANAGER})
    public boolean isMemberOfTeamOrManager(Authentication authentication, Long teamId) {
        UserEntity currentUser = getCurrentUser(authentication);
        return isAdministrator(authentication)
               || membershipService.isUserMemberOfTeam(currentUser, teamId)
               || membershipService.isUserManager(currentUser);
    }

    @ApiAuthRoles(AuthRole.MANAGER_OF)
    public boolean isManagerOfTeam(Authentication authentication, Long teamId) {
        UserEntity currentUser = getCurrentUser(authentication);
        return isAdministrator(authentication)
               || membershipService.isUserManagerOfTeam(currentUser, teamId);
    }

    @ApiAuthRoles(AuthRole.MANAGER)
    public boolean isManager(Authentication authentication) {
        UserEntity currentUser = getCurrentUser(authentication);
        return isAdministrator(authentication)
               || membershipService.isUserManager(currentUser);
    }

    @ApiAuthRoles({AuthRole.SELF, AuthRole.MANAGER})
    public boolean isSelfOrManager(Authentication authentication, Long userId) {
        UserEntity currentUser = getCurrentUser(authentication);
        return isAdministrator(authentication)
               || isSelf(currentUser, userId)
               || membershipService.isUserManager(currentUser);
    }

    @ApiAuthRoles({AuthRole.SELF, AuthRole.MANAGER_OF})
    public boolean isSelfOrManagerOfUser(Authentication authentication, Long userId) {
        UserEntity currentUser = getCurrentUser(authentication);
        return isAdministrator(authentication)
               || isSelf(currentUser, userId)
               || membershipService.isUserManagerOfOther(currentUser, userId);
    }

    @ApiAuthRoles(AuthRole.MANAGER_OF)
    public boolean isManagerOfUser(Authentication authentication, Long userId) {
        UserEntity currentUser = getCurrentUser(authentication);
        return isAdministrator(authentication)
               || membershipService.isUserManagerOfOther(currentUser, userId);
    }

    @ApiAuthRoles(AuthRole.SELF)
    public boolean isSelf(Authentication authentication, Long userId) {
        UserEntity currentUser = getCurrentUser(authentication);
        return isSelf(currentUser, userId);
    }

    @ApiAuthRoles(AuthRole.MANAGER_OF)
    public boolean isManagerOfOwner(Authentication authentication, Long planningId) {
        UserEntity currentUser = getCurrentUser(authentication);
        return isAdministrator(authentication)
               || planningService.isManagerOfOwner(currentUser, planningId);
    }

    @ApiAuthRoles({AuthRole.SELF, AuthRole.MANAGER_OF})
    public boolean isOwnerOrManagerOfOwner(Authentication authentication, Long planningId) {
        UserEntity currentUser = getCurrentUser(authentication);
        return isAdministrator(authentication)
               || planningService.isOwner(currentUser, planningId)
               || planningService.isManagerOfOwner(currentUser, planningId);
    }

    private boolean isSelf(UserEntity currentUser, Long userId) {
        return currentUser.getId().equals(userId);
    }
}
