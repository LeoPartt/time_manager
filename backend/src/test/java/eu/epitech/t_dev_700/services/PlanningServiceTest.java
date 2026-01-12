

package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.entities.PlanningEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.mappers.PlanningMapper;
import eu.epitech.t_dev_700.models.PlanningModels;
import eu.epitech.t_dev_700.repositories.PlanningRepository;
import eu.epitech.t_dev_700.repositories.UserRepository;
import eu.epitech.t_dev_700.services.exceptions.ResourceNotFound;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class PlanningServiceTest {

    @Mock
    private PlanningRepository planningRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private PlanningMapper planningMapper;

    @Mock
    private MembershipService membershipService;

    @InjectMocks
    private PlanningService planningService;

    private UserEntity user;
    private UserEntity owner;
    private PlanningEntity planning;
    private PlanningModels.PostPlanningRequest postRequest;
    private PlanningModels.PlanningResponse planningResponse;

    @BeforeEach
    void setUp() {
        user = mock(UserEntity.class);
        owner = mock(UserEntity.class);
        planning = mock(PlanningEntity.class);

        // Setup PostPlanningRequest
        postRequest = new PlanningModels.PostPlanningRequest(
                1L, // userId
                PlanningEntity.WeekDay.MONDAY,
                LocalTime.of(9, 0),
                LocalTime.of(17, 30)
        );

        // Setup PlanningResponse
        planningResponse = new PlanningModels.PlanningResponse(
                1L,
                1L,
                PlanningEntity.WeekDay.MONDAY,
                LocalTime.of(9, 0),
                LocalTime.of(17, 30)
        );
    }

    // ✅ NEW TEST - Create planning with user assignment
    @Test
    void create_shouldAssignUserAndSavePlanning() {
        // Given
        PlanningEntity newPlanning = new PlanningEntity();
        PlanningEntity savedPlanning = new PlanningEntity();
        savedPlanning.setId(1L);

        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(planningMapper.createEntity(postRequest)).thenReturn(newPlanning);
        when(planningRepository.save(newPlanning)).thenReturn(savedPlanning);
        when(planningMapper.toModel(savedPlanning)).thenReturn(planningResponse);

        // When
        PlanningModels.PlanningResponse result = planningService.create(postRequest);

        // Then
        assertNotNull(result);
        assertEquals(planningResponse, result);

        // Verify interactions
        verify(userRepository).findById(1L);
        verify(planningMapper).createEntity(postRequest);
        verify(newPlanning).setUser(user); // ✅ Verify user was assigned
        verify(planningRepository).save(newPlanning);
        verify(planningMapper).toModel(savedPlanning);
    }

    // ✅ NEW TEST - Create planning with non-existent user
    @Test
    void create_shouldThrowResourceNotFoundWhenUserDoesNotExist() {
        // Given
        when(userRepository.findById(1L)).thenReturn(Optional.empty());

        // When & Then
        assertThrows(ResourceNotFound.class, () -> {
            planningService.create(postRequest);
        });

        // Verify that save was never called
        verify(userRepository).findById(1L);
        verify(planningRepository, never()).save(any());
    }

    @Test
    void getForUser_shouldReturnRepositoryResult() {
        // Given
        List<PlanningEntity> expected = List.of(
                mock(PlanningEntity.class),
                mock(PlanningEntity.class)
        );
        when(planningRepository.findByUser(user)).thenReturn(expected);

        // When
        List<PlanningEntity> result = planningService.getForUser(user);

        // Then
        assertSame(expected, result);
        verify(planningRepository).findByUser(user);
        verifyNoMoreInteractions(planningRepository);
    }

    @Test
    void listForUser_shouldMapEntitiesToResponses() {
        // Given
        List<PlanningEntity> entities = List.of(mock(PlanningEntity.class));
        PlanningModels.PlanningResponse[] mapped = new PlanningModels.PlanningResponse[]{
                mock(PlanningModels.PlanningResponse.class)
        };

        when(planningRepository.findByUser(user)).thenReturn(entities);
        when(planningMapper.listEntity(entities)).thenReturn(mapped);

        // When
        PlanningModels.PlanningResponse[] result = planningService.listForUser(user);

        // Then
        assertArrayEquals(mapped, result);
        verify(planningRepository).findByUser(user);
        verify(planningMapper).listEntity(entities);
    }

    @Test
    void isOwner_shouldReturnTrueWhenUserIsOwner() {
        // Given
        Long planningId = 42L;

        when(planningRepository.findById(planningId)).thenReturn(Optional.of(planning));
        when(planning.getUser()).thenReturn(user);

        // When
        boolean result = planningService.isOwner(user, planningId);

        // Then
        assertTrue(result);
        verify(planningRepository).findById(planningId);
        verify(planning).getUser();
    }

    @Test
    void isOwner_shouldReturnFalseWhenUserIsNotOwner() {
        // Given
        Long planningId = 42L;

        when(planningRepository.findById(planningId)).thenReturn(Optional.of(planning));
        when(planning.getUser()).thenReturn(owner);

        // When
        boolean result = planningService.isOwner(user, planningId);

        // Then
        assertFalse(result);
        verify(planningRepository).findById(planningId);
        verify(planning).getUser();
    }

    @Test
    void isManagerOfOwner_shouldDelegateToMembershipServiceWithOwner() {
        // Given
        Long planningId = 42L;

        when(planningRepository.findById(planningId)).thenReturn(Optional.of(planning));
        when(planning.getUser()).thenReturn(owner);
        when(membershipService.isUserManagerOfOther(user, owner)).thenReturn(true);

        // When
        boolean result = planningService.isManagerOfOwner(user, planningId);

        // Then
        assertTrue(result);

        verify(planningRepository).findById(planningId);
        verify(planning).getUser();
        verify(membershipService).isUserManagerOfOther(user, owner);
    }

    @Test
    void isManagerOfOwner_shouldReturnFalseIfMembershipServiceSaysNo() {
        // Given
        Long planningId = 42L;

        when(planningRepository.findById(planningId)).thenReturn(Optional.of(planning));
        when(planning.getUser()).thenReturn(owner);
        when(membershipService.isUserManagerOfOther(user, owner)).thenReturn(false);

        // When
        boolean result = planningService.isManagerOfOwner(user, planningId);

        // Then
        assertFalse(result);
        verify(planningRepository).findById(planningId);
        verify(planning).getUser();
        verify(membershipService).isUserManagerOfOther(user, owner);
    }

    // ✅ ADDITIONAL TEST - Create with null userId
    @Test
    void create_shouldHandleNullUserId() {
        // Given
        PlanningModels.PostPlanningRequest requestWithNullUserId =
                new PlanningModels.PostPlanningRequest(
                        null, // userId is null
                        PlanningEntity.WeekDay.MONDAY,
                        LocalTime.of(9, 0),
                        LocalTime.of(17, 30)
                );

        // When & Then
        assertThrows(NullPointerException.class, () -> {
            planningService.create(requestWithNullUserId);
        });

        verify(userRepository, never()).findById(any());
        verify(planningRepository, never()).save(any());
    }

    // ✅ ADDITIONAL TEST - Verify user is set before save
    @Test
    void create_shouldSetUserBeforeSaving() {
        // Given
        PlanningEntity newPlanning = spy(new PlanningEntity());
        PlanningEntity savedPlanning = new PlanningEntity();
        savedPlanning.setId(1L);

        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(planningMapper.createEntity(postRequest)).thenReturn(newPlanning);
        when(planningRepository.save(newPlanning)).thenReturn(savedPlanning);
        when(planningMapper.toModel(savedPlanning)).thenReturn(planningResponse);

        // When
        planningService.create(postRequest);

        // Then - Verify setUser was called before save
        verify(newPlanning).setUser(user);
        verify(planningRepository).save(newPlanning);

        // Verify order: setUser must be called before save
        var inOrder = inOrder(newPlanning, planningRepository);
        inOrder.verify(newPlanning).setUser(user);
        inOrder.verify(planningRepository).save(newPlanning);
    }
}