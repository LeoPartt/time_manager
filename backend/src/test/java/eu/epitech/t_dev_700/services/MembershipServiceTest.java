package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.entities.MembershipEntity;
import eu.epitech.t_dev_700.entities.TeamEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.repositories.MembershipRepository;
import eu.epitech.t_dev_700.services.exceptions.NotAMember;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MembershipServiceTest {

    @Mock
    private MembershipRepository membershipRepository;

    @InjectMocks
    private MembershipService membershipService;

    private UserEntity user;
    private UserEntity otherUser;
    private TeamEntity team;

    @BeforeEach
    void setUp() {
        user = mock(UserEntity.class);
        otherUser = mock(UserEntity.class);
        team = mock(TeamEntity.class);
    }

    // ---------------------------
    // Simple read delegates
    // ---------------------------

    @Test
    void getMembershipsOfUser_delegatesToRepository() {
        List<MembershipEntity> list = List.of(mock(MembershipEntity.class));
        when(membershipRepository.findByUser(user)).thenReturn(list);

        List<MembershipEntity> result = membershipService.getMembershipsOfUser(user);

        assertThat(result).isSameAs(list);
        verify(membershipRepository).findByUser(user);
        verifyNoMoreInteractions(membershipRepository);
    }

    @Test
    void getMembershipsOfTeam_delegatesToRepository() {
        List<MembershipEntity> list = List.of(mock(MembershipEntity.class));
        when(membershipRepository.findByTeam(team)).thenReturn(list);

        List<MembershipEntity> result = membershipService.getMembershipsOfTeam(team);

        assertThat(result).isSameAs(list);
        verify(membershipRepository).findByTeam(team);
        verifyNoMoreInteractions(membershipRepository);
    }

    @Test
    void getUsersOfTeam_mapsMembershipsToUsers() {
        MembershipEntity m1 = mock(MembershipEntity.class);
        MembershipEntity m2 = mock(MembershipEntity.class);

        when(m1.getUser()).thenReturn(user);
        when(m2.getUser()).thenReturn(otherUser);

        when(membershipRepository.findByTeam(team)).thenReturn(List.of(m1, m2));

        List<UserEntity> result = membershipService.getUsersOfTeam(team);

        assertThat(result).containsExactly(user, otherUser);
        verify(membershipRepository).findByTeam(team);
        verify(m1).getUser();
        verify(m2).getUser();
    }

    // ---------------------------
    // Boolean delegates
    // ---------------------------

    @Test
    void isUserMemberOfTeam_returnsRepositoryResult() {
        when(membershipRepository.existsByUserAndTeam_Id(user, 10L)).thenReturn(true);

        assertThat(membershipService.isUserMemberOfTeam(user, 10L)).isTrue();

        verify(membershipRepository).existsByUserAndTeam_Id(user, 10L);
    }

    @Test
    void isUserManagerOfTeam_returnsRepositoryResult() {
        when(membershipRepository.existsByUserAndTeam_IdAndRole(user, 10L, MembershipEntity.TeamRole.MANAGER))
                .thenReturn(true);

        assertThat(membershipService.isUserManagerOfTeam(user, 10L)).isTrue();

        verify(membershipRepository).existsByUserAndTeam_IdAndRole(user, 10L, MembershipEntity.TeamRole.MANAGER);
    }

    @Test
    void isUserManager_returnsRepositoryResult() {
        when(membershipRepository.existsByUserAndRole(user, MembershipEntity.TeamRole.MANAGER)).thenReturn(false);

        assertThat(membershipService.isUserManager(user)).isFalse();

        verify(membershipRepository).existsByUserAndRole(user, MembershipEntity.TeamRole.MANAGER);
    }

    // ---------------------------
    // isUserManagerOfOther overloads
    // ---------------------------

    @Test
    void isUserManagerOfOther_withEntity_callsIdOverload() {
        when(otherUser.getId()).thenReturn(2L);
        when(membershipRepository.existsMembershipOfUserIdOnTeamsManagedByOther(2L, user)).thenReturn(false);

        assertThat(membershipService.isUserManagerOfOther(user, otherUser)).isTrue();

        verify(otherUser).getId();
        verify(membershipRepository).existsMembershipOfUserIdOnTeamsManagedByOther(2L, user);
    }

    @Test
    void isUserManagerOfOther_withUserId_returnsNegationOfRepositoryCall() {
        // method returns !existsMembershipOfUserIdOnTeamsManagedByOther(userId, manager)
        when(membershipRepository.existsMembershipOfUserIdOnTeamsManagedByOther(99L, user)).thenReturn(true);

        assertThat(membershipService.isUserManagerOfOther(user, 99L)).isFalse();

        verify(membershipRepository).existsMembershipOfUserIdOnTeamsManagedByOther(99L, user);
    }

    // ---------------------------
    // createMembership overloads
    // ---------------------------

    @Test
    void createMembership_defaultRole_savesMembershipWithMemberRole() {
        membershipService.createMembership(team, user);

        ArgumentCaptor<MembershipEntity> captor = ArgumentCaptor.forClass(MembershipEntity.class);
        verify(membershipRepository).save(captor.capture());

        MembershipEntity saved = captor.getValue();
        assertThat(saved.getUser()).isSameAs(user);
        assertThat(saved.getTeam()).isSameAs(team);
        assertThat(saved.getRole()).isEqualTo(MembershipEntity.TeamRole.MEMBER);
    }

    @Test
    void createMembership_withRole_savesMembershipWithGivenRole() {
        membershipService.createMembership(team, user, MembershipEntity.TeamRole.MANAGER);

        ArgumentCaptor<MembershipEntity> captor = ArgumentCaptor.forClass(MembershipEntity.class);
        verify(membershipRepository).save(captor.capture());

        MembershipEntity saved = captor.getValue();
        assertThat(saved.getUser()).isSameAs(user);
        assertThat(saved.getTeam()).isSameAs(team);
        assertThat(saved.getRole()).isEqualTo(MembershipEntity.TeamRole.MANAGER);
    }

    // ---------------------------
    // deleteMembership
    // ---------------------------

    @Test
    void deleteMembership_whenPresent_deletesEntity() {
        MembershipEntity membership = mock(MembershipEntity.class);
        when(membershipRepository.findByTeamAndUser(team, user)).thenReturn(Optional.of(membership));

        membershipService.deleteMembership(team, user);

        verify(membershipRepository).delete(membership);
    }

    @Test
    void deleteMembership_whenAbsent_throwsNotAMember() {
        when(team.getId()).thenReturn(10L);
        when(user.getId()).thenReturn(1L);

        when(membershipRepository.findByTeamAndUser(team, user)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> membershipService.deleteMembership(team, user))
                .isInstanceOf(NotAMember.class);

        verify(membershipRepository, never()).delete(any());
    }

    // ---------------------------
    // getManagerOfTeam
    // ---------------------------

    @Test
    void getManagerOfTeam_whenPresent_returnsManagerUser() {
        MembershipEntity managerMembership = mock(MembershipEntity.class);
        when(managerMembership.getUser()).thenReturn(user);

        when(membershipRepository.findByTeamAndRole(team, MembershipEntity.TeamRole.MANAGER))
                .thenReturn(Optional.of(managerMembership));

        UserEntity result = membershipService.getManagerOfTeam(team);

        assertThat(result).isSameAs(user);
        verify(managerMembership).getUser();
    }

    @Test
    void getManagerOfTeam_whenAbsent_returnsNull() {
        when(membershipRepository.findByTeamAndRole(team, MembershipEntity.TeamRole.MANAGER))
                .thenReturn(Optional.empty());

        UserEntity result = membershipService.getManagerOfTeam(team);

        assertThat(result).isNull();
    }

    // ---------------------------
    // deleteManagerOfTeam
    // ---------------------------

    @Test
    void deleteManagerOfTeam_whenPresent_demotesManagerToMember_andSaves() {
        MembershipEntity managerMembership = mock(MembershipEntity.class);

        when(membershipRepository.findByTeamAndRole(team, MembershipEntity.TeamRole.MANAGER))
                .thenReturn(Optional.of(managerMembership));

        membershipService.deleteManagerOfTeam(team);

        verify(managerMembership).setRole(MembershipEntity.TeamRole.MEMBER);
        verify(membershipRepository).save(managerMembership);
    }

    @Test
    void deleteManagerOfTeam_whenAbsent_doesNothing() {
        when(membershipRepository.findByTeamAndRole(team, MembershipEntity.TeamRole.MANAGER))
                .thenReturn(Optional.empty());

        membershipService.deleteManagerOfTeam(team);

        verify(membershipRepository, never()).save(any());
    }

    // ---------------------------
    // updateManagerOfTeam
    // ---------------------------

    @Test
    void updateManagerOfTeam_whenUserIsMember_demotesExistingManager_thenPromotesTarget_andSaves() {
        // existing manager membership -> will be demoted by deleteManagerOfTeam()
        MembershipEntity existingManager = mock(MembershipEntity.class);
        when(membershipRepository.findByTeamAndRole(team, MembershipEntity.TeamRole.MANAGER))
                .thenReturn(Optional.of(existingManager));

        // membership for the target user in the team -> will be promoted
        MembershipEntity targetMembership = mock(MembershipEntity.class);
        when(membershipRepository.findByTeamAndUser(team, user))
                .thenReturn(Optional.of(targetMembership));

        membershipService.updateManagerOfTeam(team, user);

        // demotion
        verify(existingManager).setRole(MembershipEntity.TeamRole.MEMBER);
        verify(membershipRepository).save(existingManager);

        // promotion
        verify(targetMembership).setRole(MembershipEntity.TeamRole.MANAGER);
        verify(membershipRepository).save(targetMembership);
    }

    @Test
    void updateManagerOfTeam_whenTargetNotMember_throwsNotAMember() {
        when(team.getId()).thenReturn(10L);
        when(user.getId()).thenReturn(1L);

        when(membershipRepository.findByTeamAndRole(team, MembershipEntity.TeamRole.MANAGER))
                .thenReturn(Optional.empty());
        when(membershipRepository.findByTeamAndUser(team, user))
                .thenReturn(Optional.empty());

        assertThatThrownBy(() -> membershipService.updateManagerOfTeam(team, user))
                .isInstanceOf(NotAMember.class);

        verify(membershipRepository, never()).save(any());
    }
}
