package eu.epitech.t_dev_700.controllers;

import eu.epitech.t_dev_700.entities.PlanningEntity;
import eu.epitech.t_dev_700.models.PlanningModels;
import eu.epitech.t_dev_700.services.MembershipService;
import eu.epitech.t_dev_700.services.PlanningService;
import eu.epitech.t_dev_700.services.exceptions.ResourceNotFound;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalTime;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(PlanningController.class)
@ActiveProfiles("test")
@AutoConfigureMockMvc(addFilters = false)
class PlanningControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private PlanningService planningService;

    @MockitoBean
    private MembershipService membershipService;

    private PlanningModels.PlanningResponse planningResponse;
    private PlanningModels.PlanningResponse[] planningResponses;

    @BeforeEach
    void setUp() {
        planningResponse = new PlanningModels.PlanningResponse(
                1L,
                1L,
                PlanningEntity.WeekDay.MONDAY,
                LocalTime.of(8, 0),
                LocalTime.of(12, 0)
        );

        planningResponses = new PlanningModels.PlanningResponse[]{planningResponse};
    }

    @Test
    void testGet_whenPlanningExists_shouldReturnPlanning() throws Exception {
        when(planningService.get(1L)).thenReturn(planningResponse);

        mockMvc.perform(get("/plannings/1"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.userId").value(1))
                .andExpect(jsonPath("$.weekDay").value(0))
                .andExpect(jsonPath("$.startTime").value("08:00"))
                .andExpect(jsonPath("$.endTime").value("12:00"));
    }

    @Test
    void testGet_whenPlanningNotExists_shouldReturn404() throws Exception {
        when(planningService.get(999L)).thenThrow(new ResourceNotFound("Planning", 999L));

        mockMvc.perform(get("/plannings/999"))
                .andExpect(status().isNotFound());
    }

    @Test
    void testGetAll_shouldReturnAllPlannings() throws Exception {
        when(planningService.list()).thenReturn(planningResponses);

        mockMvc.perform(get("/plannings"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].id").value(1))
                .andExpect(jsonPath("$[0].userId").value(1))
                .andExpect(jsonPath("$[0].weekDay").value(0))
                .andExpect(jsonPath("$[0].startTime").value("08:00"))
                .andExpect(jsonPath("$[0].endTime").value("12:00"));
    }

    @Test
    void testPost_shouldCreatePlanning() throws Exception {
        String requestBody = """
                {
                    "userId": 1,
                    "weekDay": 1,
                    "startTime": "08:00",
                    "endTime": "12:00"
                }
                """;

        when(planningService.create(any())).thenReturn(planningResponse);

        mockMvc.perform(post("/plannings")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.userId").value(1))
                .andExpect(jsonPath("$.weekDay").value(0))
                .andExpect(jsonPath("$.startTime").value("08:00"))
                .andExpect(jsonPath("$.endTime").value("12:00"));
    }

    @Test
    void testPost_withInvalidData_shouldReturn422() throws Exception {
        String requestBody = """
                {
                    "userId": 1,
                    "weekDay": 0,
                    "startTime": "12:00",
                    "endTime": "08:00"
                }
                """;

        mockMvc.perform(post("/plannings")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isUnprocessableEntity());
    }

    @Test
    void testPost_withMissingRequiredFields_shouldReturn422() throws Exception {
        String requestBody = """
                {
                    "userId": 1
                }
                """;

        mockMvc.perform(post("/plannings")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isUnprocessableEntity());
    }

    @Test
    void testPut_shouldReplacePlanning() throws Exception {
        String requestBody = """
                {
                    "userId": 1,
                    "weekDay": 0,
                    "startTime": "08:00",
                    "endTime": "12:00"
                }
                """;

        PlanningModels.PlanningResponse updatedModel = new PlanningModels.PlanningResponse(
                1L,
                1L,
                PlanningEntity.WeekDay.MONDAY,
                LocalTime.of(9, 0),
                LocalTime.of(12, 0)
        );

        when(planningService.replace(eq(1L), any())).thenReturn(updatedModel);

        mockMvc.perform(put("/plannings/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.startTime").value("09:00"));
    }

    @Test
    void testPut_whenPlanningNotExists_shouldReturn404() throws Exception {
        String requestBody = """
                {
                    "userId": 1,
                    "weekDay": 0,
                    "startTime": "08:00",
                    "endTime": "12:00"
                }
                """;

        when(planningService.replace(eq(999L), any()))
                .thenThrow(new ResourceNotFound("Planning", 999L));

        mockMvc.perform(put("/plannings/999")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isNotFound());
    }

    @Test
    void testPatch_shouldUpdatePlanning() throws Exception {
        String requestBody = """
                {
                    "startTime": "09:00"
                }
                """;

        PlanningModels.PlanningResponse patchedModel = new PlanningModels.PlanningResponse(
                1L,
                1L,
                PlanningEntity.WeekDay.MONDAY,
                LocalTime.of(9, 0),
                LocalTime.of(12, 0)
        );

        when(planningService.update(eq(1L), any())).thenReturn(patchedModel);

        mockMvc.perform(patch("/plannings/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.startTime").value("09:00"))
                .andExpect(jsonPath("$.endTime").value("12:00")); // Should remain unchanged
    }

    @Test
    void testPatch_whenPlanningNotExists_shouldReturn404() throws Exception {
        String requestBody = """
                {
                    "startTime": "09:00"
                }
                """;

        when(planningService.update(eq(999L), any()))
                .thenThrow(new ResourceNotFound("Planning", 999L));

        mockMvc.perform(patch("/plannings/999")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isNotFound());
    }

    @Test
    void testDelete_shouldDeletePlanning() throws Exception {
        mockMvc.perform(delete("/plannings/1"))
                .andExpect(status().isNoContent());
    }

    @Test
    void testDelete_whenPlanningNotExists_shouldReturn404() throws Exception {
        doThrow(new ResourceNotFound("Planning", 999L))
                .when(planningService).delete(999L);

        mockMvc.perform(delete("/plannings/999"))
                .andExpect(status().isNotFound());
    }
}
