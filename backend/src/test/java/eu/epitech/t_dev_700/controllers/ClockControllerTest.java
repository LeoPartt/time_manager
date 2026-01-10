package eu.epitech.t_dev_700.controllers;

import eu.epitech.t_dev_700.config.filters.JwtAuthenticationFilter;
import eu.epitech.t_dev_700.models.ClockModels;
import eu.epitech.t_dev_700.services.ClockService;
import eu.epitech.t_dev_700.services.exceptions.ForbiddenFutureClocking;
import eu.epitech.t_dev_700.services.exceptions.InvalidClockingAction;
import eu.epitech.t_dev_700.services.exceptions.ResourceNotFound;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.FilterType;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.time.OffsetDateTime;

import static org.hamcrest.Matchers.anEmptyMap;
import static org.hamcrest.Matchers.matchesPattern;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.verify;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(
        controllers = ClockController.class,
        excludeFilters = @ComponentScan.Filter(
                type = FilterType.ASSIGNABLE_TYPE,
                classes = JwtAuthenticationFilter.class
        )
)
@ActiveProfiles("test")
@AutoConfigureMockMvc(addFilters = false)
class ClockControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private ClockService clockService;

    private static final String RFC9457_AT_REGEX =
            "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(\\.\\d+)?Z$";

    private static void assertCommonErrorFields(org.springframework.test.web.servlet.ResultActions ra,
                                                int status,
                                                String title,
                                                String instance) throws Exception {
        ra.andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.status").value(status))
                .andExpect(jsonPath("$.title").value(title))
                .andExpect(jsonPath("$.instance").value(instance))
                .andExpect(jsonPath("$.detail").isNotEmpty())
                .andExpect(jsonPath("$.details").exists())
                .andExpect(jsonPath("$.at").value(matchesPattern(RFC9457_AT_REGEX)));
    }

    @Test
    void testPostClock_shouldReturn204_andCallService() throws Exception {
        String requestBody = """
                {
                  "io": "IN",
                  "timestamp": "2026-01-09T08:00:00Z"
                }
                """;

        mockMvc.perform(post("/clocks")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isNoContent());

        verify(clockService).postClock(any(ClockModels.PostClockRequest.class));
    }

    @Test
    void testPostClockForUser_shouldReturn204_andCallService() throws Exception {
        String requestBody = """
                {
                  "io": "OUT",
                  "timestamp": "2026-01-09T12:00:00Z"
                }
                """;

        mockMvc.perform(post("/clocks/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isNoContent());

        verify(clockService).postClock(any(ClockModels.PostClockRequest.class), eq(1L));
    }

    @Test
    void testPostClock_withMissingRequiredFields_shouldReturn422_withErrorBody() throws Exception {
        String requestBody = "{}";

        var ra = mockMvc.perform(post("/clocks")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isUnprocessableEntity());

        assertCommonErrorFields(ra, 422, "Unprocessable Entity", "/clocks");

        // your validation handler likely fills details with field errors; at least ensure not empty
        ra.andExpect(jsonPath("$.details").isMap())
                .andExpect(jsonPath("$.details").isNotEmpty());
    }

    @Test
    void testPostClockForUser_withMissingRequiredFields_shouldReturn422_withErrorBody() throws Exception {
        String requestBody = "{}";

        var ra = mockMvc.perform(post("/clocks/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isUnprocessableEntity());

        assertCommonErrorFields(ra, 422, "Unprocessable Entity", "/clocks/1");
        ra.andExpect(jsonPath("$.details").isMap())
                .andExpect(jsonPath("$.details").isNotEmpty());
    }

    @Test
    void testPostClock_whenServiceThrowsInvalidClockingAction_shouldReturn409_withDetailsExpected() throws Exception {
        String requestBody = """
                {
                  "io": "IN",
                  "timestamp": "2026-01-09T08:00:00Z"
                }
                """;

        doThrow(new InvalidClockingAction(ClockModels.ClockAction.OUT))
                .when(clockService).postClock(any(ClockModels.PostClockRequest.class));

        var ra = mockMvc.perform(post("/clocks")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isConflict());

        assertCommonErrorFields(ra, 409, "Conflict", "/clocks");

        ra.andExpect(jsonPath("$.detail").value("Invalid clocking action"))
                .andExpect(jsonPath("$.details.expected").value("OUT"));
    }

    @Test
    void testPostClock_whenServiceThrowsForbiddenFutureClocking_shouldReturn409_withDetailsDatetime() throws Exception {
        String requestBody = """
                {
                  "io": "IN",
                  "timestamp": "2030-01-15T10:30:00Z"
                }
                """;

        // Keep exact string with Z to match how Jackson serializes OffsetDateTime (usually with Z for UTC offset)
        OffsetDateTime dt = OffsetDateTime.parse("2030-01-15T10:30:00Z");

        doThrow(new ForbiddenFutureClocking(dt))
                .when(clockService).postClock(any(ClockModels.PostClockRequest.class));

        var ra = mockMvc.perform(post("/clocks")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isConflict());

        assertCommonErrorFields(ra, 409, "Conflict", "/clocks");

        ra.andExpect(jsonPath("$.detail").value("Forbidden future clocking"))
                .andExpect(jsonPath("$.details.datetime").value("2030-01-15T10:30:00Z"));
    }

    @Test
    void testPostClockForUser_whenUserNotFound_shouldReturn404_withDetailsResourceAndId() throws Exception {
        String requestBody = """
                {
                  "io": "IN",
                  "timestamp": "2026-01-09T08:00:00Z"
                }
                """;

        doThrow(new ResourceNotFound("user", 999L))
                .when(clockService).postClock(any(ClockModels.PostClockRequest.class), eq(999L));

        var ra = mockMvc.perform(post("/clocks/999")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isNotFound());

        assertCommonErrorFields(ra, 404, "Not Found", "/clocks/999");

        ra.andExpect(jsonPath("$.detail").value("Resource 'user' #999 not found"))
                .andExpect(jsonPath("$.details.resource").value("user"))
                .andExpect(jsonPath("$.details.id").value(999));
    }

    @Test
    void testPostClockForUser_whenServiceThrowsInvalidClockingAction_shouldReturn409_withDetailsExpected() throws Exception {
        String requestBody = """
                {
                  "io": "OUT",
                  "timestamp": "2026-01-09T12:00:00Z"
                }
                """;

        doThrow(new InvalidClockingAction(ClockModels.ClockAction.IN))
                .when(clockService).postClock(any(ClockModels.PostClockRequest.class), eq(1L));

        var ra = mockMvc.perform(post("/clocks/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isConflict());

        assertCommonErrorFields(ra, 409, "Conflict", "/clocks/1");

        ra.andExpect(jsonPath("$.detail").value("Invalid clocking action"))
                .andExpect(jsonPath("$.details.expected").value("IN"));
    }

    @Test
    void testPostClockForUser_whenServiceThrowsForbiddenFutureClocking_shouldReturn409_withDetailsDatetime() throws Exception {
        String requestBody = """
                {
                  "io": "IN",
                  "timestamp": "2030-01-15T10:30:00Z"
                }
                """;

        OffsetDateTime dt = OffsetDateTime.parse("2030-01-15T10:30:00Z");

        doThrow(new ForbiddenFutureClocking(dt))
                .when(clockService).postClock(any(ClockModels.PostClockRequest.class), eq(1L));

        var ra = mockMvc.perform(post("/clocks/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isConflict());

        assertCommonErrorFields(ra, 409, "Conflict", "/clocks/1");

        ra.andExpect(jsonPath("$.detail").value("Forbidden future clocking"))
                .andExpect(jsonPath("$.details.datetime").value("2030-01-15T10:30:00Z"));
    }

    @Test
    void testPostClock_withInvalidTimestampFormat_shouldReturn400_withErrorBody() throws Exception {
        String requestBody = """
                {
                  "io": "IN",
                  "timestamp": "not-a-date"
                }
                """;

        var ra = mockMvc.perform(post("/clocks")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isBadRequest());

        assertCommonErrorFields(ra, 400, "Bad Request", "/clocks");

        ra.andExpect(jsonPath("$.detail").value("Malformed JSON body"))
                .andExpect(jsonPath("$.details").value(anEmptyMap()));
    }
}
