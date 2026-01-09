package eu.epitech.t_dev_700.controllers;

import eu.epitech.t_dev_700.config.filters.JwtAuthenticationFilter;
import eu.epitech.t_dev_700.models.ReportModels;
import eu.epitech.t_dev_700.services.ReportsService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.FilterType;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;

import java.time.OffsetDateTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(
        controllers = ReportController.class,
        excludeFilters = @ComponentScan.Filter(
                type = FilterType.ASSIGNABLE_TYPE,
                classes = JwtAuthenticationFilter.class
        )
)
@ActiveProfiles("test")
@AutoConfigureMockMvc(addFilters = false)
public class ReportControllerTest {

    @Autowired
    private org.springframework.test.web.servlet.MockMvc mockMvc;

    @org.springframework.test.context.bean.override.mockito.MockitoBean
    private ReportsService reportsService;

    private ReportModels.DashboardResponse dashboardW;
    private ReportModels.UserDashboardResponse userDashboardW;
    private ReportModels.TeamDashboardResponse teamDashboardW;

    // IMPORTANT: match exactly what Jackson outputs in your logs
    private String fromJson;
    private String toJson;
    private String pointStartJson;

    @BeforeEach
    void setUp() {
        OffsetDateTime from = OffsetDateTime.parse("2026-01-05T00:00:00Z");
        OffsetDateTime to = OffsetDateTime.parse("2026-01-12T00:00:00Z");
        OffsetDateTime pointStart = OffsetDateTime.parse("2026-01-05T00:00:00Z");

        // Use the same string representation as the response body you showed
        fromJson = "2026-01-05T00:00:00Z";
        toJson = "2026-01-12T00:00:00Z";
        pointStartJson = "2026-01-05T00:00:00Z";

        ReportModels.DateRange range = new ReportModels.DateRange(from, to);

        ReportModels.WorkPoint p1 = new ReportModels.WorkPoint(
                "Mon",
                pointStart,
                7.5f
        );

        ReportModels.WorkSeries work = new ReportModels.WorkSeries(
                "hours",
                ReportModels.WorkBucket.DAY,
                List.of(p1),
                7.5f
        );

        dashboardW = new ReportModels.DashboardResponse(
                ReportModels.Mode.W,
                range,
                new ReportModels.PercentKpi(92.3f),
                new ReportModels.PercentKpi(88.0f),
                work
        );

        userDashboardW = new ReportModels.UserDashboardResponse(1L, dashboardW);
        teamDashboardW = new ReportModels.TeamDashboardResponse(2L, dashboardW);
    }

    @Test
    void testGetGlobalDashboard_whenOk_shouldReturnDashboard() throws Exception {
        when(reportsService.getGlobalDashboard(eq(ReportModels.Mode.W), isNull()))
                .thenReturn(dashboardW);

        mockMvc.perform(get("/reports/dashboard")
                        .param("mode", "w"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))

                .andExpect(jsonPath("$.mode").value("W"))
                .andExpect(jsonPath("$.range.from").value(fromJson))
                .andExpect(jsonPath("$.range.to").value(toJson))

                .andExpect(jsonPath("$.punctuality.percent").value(92.3))
                .andExpect(jsonPath("$.attendance.percent").value(88.0))

                .andExpect(jsonPath("$.work.unit").value("hours"))
                .andExpect(jsonPath("$.work.bucket").value("DAY"))
                .andExpect(jsonPath("$.work.average").value(7.5))

                .andExpect(jsonPath("$.work.series").isArray())
                .andExpect(jsonPath("$.work.series[0].label").value("Mon"))
                .andExpect(jsonPath("$.work.series[0].start").value(pointStartJson))
                .andExpect(jsonPath("$.work.series[0].value").value(7.5));

        verify(reportsService).getGlobalDashboard(ReportModels.Mode.W, null);
    }

    @Test
    void testGetGlobalDashboard_withAt_shouldForwardAtToService() throws Exception {
        OffsetDateTime at = OffsetDateTime.parse("2026-01-09T10:30:00Z");

        when(reportsService.getGlobalDashboard(eq(ReportModels.Mode.W), eq(at)))
                .thenReturn(dashboardW);

        mockMvc.perform(get("/reports/dashboard")
                        .param("mode", "w")
                        .param("at", at.toString()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.mode").value("W"));

        ArgumentCaptor<OffsetDateTime> atCaptor = ArgumentCaptor.forClass(OffsetDateTime.class);
        verify(reportsService).getGlobalDashboard(eq(ReportModels.Mode.W), atCaptor.capture());
        assertThat(atCaptor.getValue()).isEqualTo(at);
    }

    @Test
    void testGetUserDashboard_whenOk_shouldReturnUserDashboard() throws Exception {
        when(reportsService.getUserDashboard(eq(1L), eq(ReportModels.Mode.W), isNull()))
                .thenReturn(userDashboardW);

        mockMvc.perform(get("/reports/users/1/dashboard")
                        .param("mode", "w"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))

                .andExpect(jsonPath("$.userId").value(1))
                .andExpect(jsonPath("$.dashboard.mode").value("W"))
                .andExpect(jsonPath("$.dashboard.range.from").value(fromJson))
                .andExpect(jsonPath("$.dashboard.range.to").value(toJson))
                .andExpect(jsonPath("$.dashboard.work.bucket").value("DAY"))
                .andExpect(jsonPath("$.dashboard.work.series[0].label").value("Mon"));

        verify(reportsService).getUserDashboard(1L, ReportModels.Mode.W, null);
    }

    @Test
    void testGetTeamDashboard_whenOk_shouldReturnTeamDashboard() throws Exception {
        when(reportsService.getTeamDashboard(eq(2L), eq(ReportModels.Mode.W), isNull()))
                .thenReturn(teamDashboardW);

        mockMvc.perform(get("/reports/teams/2/dashboard")
                        .param("mode", "w"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))

                .andExpect(jsonPath("$.teamId").value(2))
                .andExpect(jsonPath("$.dashboard.mode").value("W"))
                .andExpect(jsonPath("$.dashboard.punctuality.percent").value(92.3))
                .andExpect(jsonPath("$.dashboard.attendance.percent").value(88.0));

        verify(reportsService).getTeamDashboard(2L, ReportModels.Mode.W, null);
    }

    @Test
    void testGetGlobalDashboard_whenModeMissing_shouldReturn4xx() throws Exception {
        // Missing required query param -> Spring returns 400 by default
        mockMvc.perform(get("/reports/dashboard"))
                .andExpect(status().isBadRequest());
    }

    @Test
    void testGetGlobalDashboard_whenModeInvalid_shouldReturn500_withErrorResponse() throws Exception {
        // Your app currently turns IllegalArgumentException into 500 with ErrorModels.ErrorResponse
        mockMvc.perform(get("/reports/dashboard")
                        .param("mode", "nope"))
                .andExpect(status().isInternalServerError())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.status").value(500))
                .andExpect(jsonPath("$.title").value("Internal Server Error"))
                .andExpect(jsonPath("$.instance").value("/reports/dashboard"))
                .andExpect(jsonPath("$.details.type").value("java.lang.IllegalArgumentException"));
    }
}