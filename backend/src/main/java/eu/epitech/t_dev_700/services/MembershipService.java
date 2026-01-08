package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.entities.MembershipEntity;
import eu.epitech.t_dev_700.entities.TeamEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.repositories.MembershipRepository;
import eu.epitech.t_dev_700.services.exceptions.NotAMember;
import eu.epitech.t_dev_700.utils.RBoundBiConsumer;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MembershipService {

    private final MembershipRepository membershipRepository;

    @Transactional(readOnly = true)
    public List<MembershipEntity> getMembershipsOfUser(UserEntity user) {
        return membershipRepository.findByUser(user);
    }

    @Transactional(readOnly = true)
    public List<MembershipEntity> getMembershipsOfTeam(TeamEntity team) {
        return membershipRepository.findByTeam(team);
    }

    @Transactional(readOnly = true)
    public List<UserEntity> getUsersOfTeam(TeamEntity team) {
        return membershipRepository.findByTeam(team).stream()
                .map(MembershipEntity::getUser)
                .toList();
    }

    @Transactional(readOnly = true)
    public boolean isUserMemberOfTeam(UserEntity user, Long teamId) {
        return membershipRepository.existsByUserAndTeam_Id(user, teamId);
    }

    @Transactional(readOnly = true)
    public boolean isUserManagerOfTeam(UserEntity user, Long teamId) {
        return membershipRepository.existsByUserAndTeam_IdAndRole(user, teamId, MembershipEntity.TeamRole.MANAGER);
    }

    @Transactional(readOnly = true)
    public boolean isUserManager(UserEntity user) {
        return membershipRepository.existsByUserAndRole(user, MembershipEntity.TeamRole.MANAGER);
    }

    @Transactional(readOnly = true)
    public boolean isUserManagerOfOther(UserEntity user, UserEntity otherUser) {
        return this.isUserManagerOfOther(user, otherUser.getId());
    }

    @Transactional(readOnly = true)
    public boolean isUserManagerOfOther(UserEntity user, Long userId) {
        return !membershipRepository.existsMembershipOfUserIdOnTeamsManagedByOther(userId, user);
    }

    @Transactional
    public void createMembership(TeamEntity team, UserEntity user) {
        this.createMembership(team, user, MembershipEntity.TeamRole.MEMBER);
    }

    @Transactional
    public void createMembership(TeamEntity team, UserEntity user, MembershipEntity.TeamRole role) {
        membershipRepository.save(new MembershipEntity(user, team, role));
    }

    @Transactional
    public void deleteMembership(TeamEntity team, UserEntity user) {
        this.membershipRepository.findByTeamAndUser(team, user).ifPresentOrElse(
                membershipRepository::delete,
                new NotAMember(team.getId(), user.getId())
        );
    }

    @Transactional(readOnly = true)
    public UserEntity getManagerOfTeam(TeamEntity team) {
        return membershipRepository
                .findByTeamAndRole(team, MembershipEntity.TeamRole.MANAGER)
                .map(MembershipEntity::getUser)
                .orElse(null);
    }

    @Transactional
    public void updateManagerOfTeam(TeamEntity team, UserEntity user) {
        this.deleteManagerOfTeam(team);
        this.membershipRepository
                .findByTeamAndUser(team, user)
                .ifPresentOrElse(RBoundBiConsumer
                                .of(MembershipEntity::setRole, MembershipEntity.TeamRole.MANAGER)
                                .andThen(membershipRepository::save),
                        new NotAMember(team.getId(), user.getId()));
    }

    @Transactional
    public void deleteManagerOfTeam(TeamEntity team) {
        this.membershipRepository
                .findByTeamAndRole(team, MembershipEntity.TeamRole.MANAGER)
                .ifPresent(RBoundBiConsumer
                        .of(MembershipEntity::setRole, MembershipEntity.TeamRole.MEMBER)
                        .andThen(membershipRepository::save)
                );
    }

}
