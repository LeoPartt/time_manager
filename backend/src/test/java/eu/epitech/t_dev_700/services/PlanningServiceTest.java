package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.entities.PlanningEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.mappers.PlanningMapper;
import eu.epitech.t_dev_700.models.PlanningModels;
import eu.epitech.t_dev_700.repositories.PlanningRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class PlanningServiceTest {

    @Mock
    private PlanningRepository planningRepository;

    @Mock
    private PlanningMapper planningMapper;

    @Mock
    private MembershipService membershipService;

    @InjectMocks
    private PlanningService planningService;

    private UserEntity user;
    private UserEntity owner;
    private PlanningEntity planning;

    @BeforeEach
    void setUp() {
        user = mock(UserEntity.class);
        owner = mock(UserEntity.class);
        planning = mock(PlanningEntity.class);
    }

    @Test
    void getForUser_shouldReturnRepositoryResult() {
        List<PlanningEntity> expected = List.of(mock(PlanningEntity.class), mock(PlanningEntity.class));
        when(planningRepository.findByUser(user)).thenReturn(expected);

        List<PlanningEntity> result = planningService.getForUser(user);

        assertSame(expected, result);
        verify(planningRepository).findByUser(user);
        verifyNoMoreInteractions(planningRepository);
    }

    @Test
    void listForUser_shouldMapEntitiesToResponses() {
        List<PlanningEntity> entities = List.of(mock(PlanningEntity.class));
        PlanningModels.PlanningResponse[] mapped = new PlanningModels.PlanningResponse[] {
                mock(PlanningModels.PlanningResponse.class)
        };

        when(planningRepository.findByUser(user)).thenReturn(entities);
        // Assuming PlanningMapper (used by CRUDService) has a method like listEntity(List<...>)
        // If your mapper method name differs, adjust this stub accordingly.
        when(planningMapper.listEntity(entities)).thenReturn(mapped);

        PlanningModels.PlanningResponse[] result = planningService.listForUser(user);

        assertArrayEquals(mapped, result);
        verify(planningRepository).findByUser(user);
        verify(planningMapper).listEntity(entities);
    }

    @Test
    void isOwner_shouldReturnTrueWhenUserIsOwner() {
        Long planningId = 42L;

        when(planningRepository.findById(planningId)).thenReturn(Optional.of(planning));
        when(planning.getUser()).thenReturn(user);

        boolean result = planningService.isOwner(user, planningId);

        assertTrue(result);
        verify(planningRepository).findById(planningId);
        verify(planning).getUser();
    }

    @Test
    void isOwner_shouldReturnFalseWhenUserIsNotOwner() {
        Long planningId = 42L;

        when(planningRepository.findById(planningId)).thenReturn(Optional.of(planning));
        when(planning.getUser()).thenReturn(owner);

        boolean result = planningService.isOwner(user, planningId);

        assertFalse(result);
        verify(planningRepository).findById(planningId);
        verify(planning).getUser();
    }

    @Test
    void isManagerOfOwner_shouldDelegateToMembershipServiceWithOwner() {
        Long planningId = 42L;

        when(planningRepository.findById(planningId)).thenReturn(Optional.of(planning));
        when(planning.getUser()).thenReturn(owner);
        when(membershipService.isUserManagerOfOther(user, owner)).thenReturn(true);

        boolean result = planningService.isManagerOfOwner(user, planningId);

        assertTrue(result);

        verify(planningRepository).findById(planningId);
        verify(planning).getUser();

        // verify the exact call
        verify(membershipService).isUserManagerOfOther(user, owner);
    }

    @Test
    void isManagerOfOwner_shouldReturnFalseIfMembershipServiceSaysNo() {
        Long planningId = 42L;

        when(planningRepository.findById(planningId)).thenReturn(Optional.of(planning));
        when(planning.getUser()).thenReturn(owner);
        when(membershipService.isUserManagerOfOther(user, owner)).thenReturn(false);

        boolean result = planningService.isManagerOfOwner(user, planningId);

        assertFalse(result);
        verify(membershipService).isUserManagerOfOther(user, owner);
    }
}
