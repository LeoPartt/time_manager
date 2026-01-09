package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.entities.MembershipEntity;
import eu.epitech.t_dev_700.entities.TeamEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.repositories.MembershipRepository;
import eu.epitech.t_dev_700.services.exceptions.NotAMember;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
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

    @Test
    void deleteMembership_whenAbsent_throwsNotAMember() {
        when(team.getId()).thenReturn(10L);
        when(user.getId()).thenReturn(1L);

        when(membershipRepository.findByTeamAndUser(team, user)).thenReturn(Optional.empty());

        assertThrows(NotAMember.class, () -> membershipService.deleteMembership(team, user));

        verify(membershipRepository, never()).delete(any());
    }

    @Test
    void isUserManagerOfOther_withEntity_callsIdOverload() {
        when(otherUser.getId()).thenReturn(2L);
        when(membershipRepository.existsMembershipOfUserIdOnTeamsManagedByOther(2L, user)).thenReturn(false);

        assertTrue(membershipService.isUserManagerOfOther(user, otherUser));

        verify(otherUser).getId();
        verify(membershipRepository).existsMembershipOfUserIdOnTeamsManagedByOther(2L, user);
    }

    @Test
    void updateManagerOfTeam_whenTargetNotMember_throwsNotAMember() {
        when(team.getId()).thenReturn(10L);
        when(user.getId()).thenReturn(1L);

        when(membershipRepository.findByTeamAndRole(team, MembershipEntity.TeamRole.MANAGER))
                .thenReturn(Optional.empty());
        when(membershipRepository.findByTeamAndUser(team, user))
                .thenReturn(Optional.empty());

        assertThrows(NotAMember.class, () -> membershipService.updateManagerOfTeam(team, user));

        verify(membershipRepository, never()).save(any());
    }
}
