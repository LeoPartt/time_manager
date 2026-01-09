package eu.epitech.t_dev_700.controllers;

import eu.epitech.t_dev_700.config.filters.JwtAuthenticationFilter;
import eu.epitech.t_dev_700.entities.PlanningEntity;
import eu.epitech.t_dev_700.models.PlanningModels;
import eu.epitech.t_dev_700.services.PlanningService;
import eu.epitech.t_dev_700.services.exceptions.ResourceNotFound;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.FilterType;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalTime;

import static org.hamcrest.Matchers.anEmptyMap;
import static org.hamcrest.Matchers.matchesPattern;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(
        controllers = PlanningController.class,
        excludeFilters = @ComponentScan.Filter(
                type = FilterType.ASSIGNABLE_TYPE,
                classes = JwtAuthenticationFilter.class
        )
)
@ActiveProfiles("test")
@AutoConfigureMockMvc(addFilters = false)
class PlanningControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @org.springframework.test.context.bean.override.mockito.MockitoBean
    private PlanningService planningService;

    private PlanningModels.PlanningResponse planningResponse;
    private PlanningModels.PlanningResponse[] planningResponses;

    /**
     * Instant.toString() format: 2026-01-09T09:52:10.088503300Z
     */
    private static final String ISO_INSTANT_REGEX =
            "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(?:\\.\\d+)?Z$";

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
    void testGet_whenPlanningNotExists_shouldReturn404_withErrorDetails() throws Exception {
        when(planningService.get(999L)).thenThrow(new ResourceNotFound("Planning", 999L));

        mockMvc.perform(get("/plannings/999"))
                .andExpect(status().isNotFound())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.title").value("Not Found"))
                .andExpect(jsonPath("$.status").value(404))
                .andExpect(jsonPath("$.detail").value("Resource 'Planning' #999 not found"))
                .andExpect(jsonPath("$.instance").value("/plannings/999"))
                .andExpect(jsonPath("$.details.resource").value("Planning"))
                .andExpect(jsonPath("$.details.id").value(999))
                .andExpect(jsonPath("$.at").exists())
                .andExpect(jsonPath("$.at").value(matchesPattern(ISO_INSTANT_REGEX)));
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
        // Keep consistent with mocked response (MONDAY -> 0)
        String requestBody = """
                {
                    "userId": 1,
                    "weekDay": 0,
                    "startTime": "08:00",
                    "endTime": "12:00"
                }
                """;

        when(planningService.create(any())).thenReturn(planningResponse);

        mockMvc.perform(post("/plannings")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isCreated())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.userId").value(1))
                .andExpect(jsonPath("$.weekDay").value(0))
                .andExpect(jsonPath("$.startTime").value("08:00"))
                .andExpect(jsonPath("$.endTime").value("12:00"));
    }

    @Test
    void testPost_withInvalidData_shouldReturn422_withErrorDetails() throws Exception {
        // Your exception handler ONLY collects FieldErrors.
        // If @ValidTimeRange produces a global error, details will be {} (as in your logs).
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
                .andExpect(status().isUnprocessableEntity())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.title").value("Unprocessable Entity"))
                .andExpect(jsonPath("$.status").value(422))
                .andExpect(jsonPath("$.detail").value("Validation failed"))
                .andExpect(jsonPath("$.instance").value("/plannings"))
                .andExpect(jsonPath("$.details").value(anEmptyMap()))
                .andExpect(jsonPath("$.at").exists())
                .andExpect(jsonPath("$.at").value(matchesPattern(ISO_INSTANT_REGEX)));
    }

    @Test
    void testPost_withMissingRequiredFields_shouldReturn422_withErrorDetails() throws Exception {
        String requestBody = """
                {
                    "userId": 1
                }
                """;

        mockMvc.perform(post("/plannings")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isUnprocessableEntity())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.title").value("Unprocessable Entity"))
                .andExpect(jsonPath("$.status").value(422))
                .andExpect(jsonPath("$.detail").value("Validation failed"))
                .andExpect(jsonPath("$.instance").value("/plannings"))
                // Now that we know your handler maps field -> message, assert exact messages
                .andExpect(jsonPath("$.details.weekDay").value("must not be null"))
                .andExpect(jsonPath("$.details.startTime").value("must not be null"))
                .andExpect(jsonPath("$.details.endTime").value("must not be null"))
                .andExpect(jsonPath("$.at").exists())
                .andExpect(jsonPath("$.at").value(matchesPattern(ISO_INSTANT_REGEX)));
    }

    @Test
    void testPut_shouldReplacePlanning() throws Exception {
        String requestBody = """
                {
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
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.startTime").value("09:00"));
    }

    @Test
    void testPut_whenPlanningNotExists_shouldReturn404_withErrorDetails() throws Exception {
        String requestBody = """
                {
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
                .andExpect(status().isNotFound())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.title").value("Not Found"))
                .andExpect(jsonPath("$.status").value(404))
                .andExpect(jsonPath("$.detail").value("Resource 'Planning' #999 not found"))
                .andExpect(jsonPath("$.instance").value("/plannings/999"))
                .andExpect(jsonPath("$.details.resource").value("Planning"))
                .andExpect(jsonPath("$.details.id").value(999))
                .andExpect(jsonPath("$.at").exists())
                .andExpect(jsonPath("$.at").value(matchesPattern(ISO_INSTANT_REGEX)));
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
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.startTime").value("09:00"))
                .andExpect(jsonPath("$.endTime").value("12:00"));
    }

    @Test
    void testPatch_whenPlanningNotExists_shouldReturn404_withErrorDetails() throws Exception {
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
                .andExpect(status().isNotFound())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.title").value("Not Found"))
                .andExpect(jsonPath("$.status").value(404))
                .andExpect(jsonPath("$.detail").value("Resource 'Planning' #999 not found"))
                .andExpect(jsonPath("$.instance").value("/plannings/999"))
                .andExpect(jsonPath("$.details.resource").value("Planning"))
                .andExpect(jsonPath("$.details.id").value(999))
                .andExpect(jsonPath("$.at").exists())
                .andExpect(jsonPath("$.at").value(matchesPattern(ISO_INSTANT_REGEX)));
    }

    @Test
    void testDelete_shouldDeletePlanning() throws Exception {
        mockMvc.perform(delete("/plannings/1"))
                .andExpect(status().isNoContent());

        verify(planningService).delete(1L);
    }

    @Test
    void testDelete_whenPlanningNotExists_shouldReturn404_withErrorDetails() throws Exception {
        doThrow(new ResourceNotFound("Planning", 999L))
                .when(planningService).delete(999L);

        mockMvc.perform(delete("/plannings/999"))
                .andExpect(status().isNotFound())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.title").value("Not Found"))
                .andExpect(jsonPath("$.status").value(404))
                .andExpect(jsonPath("$.detail").value("Resource 'Planning' #999 not found"))
                .andExpect(jsonPath("$.instance").value("/plannings/999"))
                .andExpect(jsonPath("$.details.resource").value("Planning"))
                .andExpect(jsonPath("$.details.id").value(999))
                .andExpect(jsonPath("$.at").exists())
                .andExpect(jsonPath("$.at").value(matchesPattern(ISO_INSTANT_REGEX)));
    }
}