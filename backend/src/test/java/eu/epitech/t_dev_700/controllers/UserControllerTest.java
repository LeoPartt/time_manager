package eu.epitech.t_dev_700.controllers;

import eu.epitech.t_dev_700.config.filters.JwtAuthenticationFilter;
import eu.epitech.t_dev_700.entities.PlanningEntity;
import eu.epitech.t_dev_700.models.PlanningModels;
import eu.epitech.t_dev_700.models.TeamModels;
import eu.epitech.t_dev_700.models.UserModels;
import eu.epitech.t_dev_700.models.UserScheduleQuery;
import eu.epitech.t_dev_700.services.ClockService;
import eu.epitech.t_dev_700.services.TeamService;
import eu.epitech.t_dev_700.services.UserService;
import eu.epitech.t_dev_700.services.exceptions.ResourceNotFound;
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
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(
        controllers = UserController.class,
        excludeFilters = @ComponentScan.Filter(
                type = FilterType.ASSIGNABLE_TYPE,
                classes = JwtAuthenticationFilter.class
        )
)
@ActiveProfiles("test")
@AutoConfigureMockMvc(addFilters = false)
class UserControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private UserService userService;

    @MockitoBean
    private TeamService teamService;

    @MockitoBean
    private ClockService clockService;

    private UserModels.UserResponse userResponse;
    private UserModels.UserResponse[] userResponses;

    @BeforeEach
    void setUp() {
        userResponse = new UserModels.UserResponse(
                1L,
                "johndoe",
                "John",
                "Doe",
                "john.doe@example.com",
                "+1234567890",
                false,
                false
        );

        userResponses = new UserModels.UserResponse[]{userResponse};
    }

    // ---------- Helpers for RFC 9457-style error body assertions ----------

    private void expectProblemBasics(int status, String title, String instance) throws Exception {
        mockMvc.perform(get("/__dummy__")); // not executed; just to show signature expectation
    }

    private static void expectProblemResponse(
            org.springframework.test.web.servlet.ResultActions ra,
            int status,
            String title,
            String instance
    ) throws Exception {
        ra.andExpect(status().is(status))
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.title").value(title))
                .andExpect(jsonPath("$.status").value(status))
                .andExpect(jsonPath("$.detail").isNotEmpty())
                .andExpect(jsonPath("$.instance").value(instance))
                .andExpect(jsonPath("$.details").exists())
                .andExpect(jsonPath("$.at").exists());
    }

    // ---------- CRUD ----------

    @Test
    void testGet_whenUserExists_shouldReturnUser() throws Exception {
        when(userService.get(1L)).thenReturn(userResponse);

        mockMvc.perform(get("/users/1"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.username").value("johndoe"))
                .andExpect(jsonPath("$.firstName").value("John"))
                .andExpect(jsonPath("$.lastName").value("Doe"))
                .andExpect(jsonPath("$.email").value("john.doe@example.com"))
                .andExpect(jsonPath("$.phoneNumber").value("+1234567890"));

        verify(userService).get(1L);
        verifyNoMoreInteractions(userService);
    }

    @Test
    void testGet_whenUserNotExists_shouldReturn404_withProblemDetails() throws Exception {
        when(userService.get(999L)).thenThrow(new ResourceNotFound("User", 999L));

        var ra = mockMvc.perform(get("/users/999"));

        expectProblemResponse(ra, 404, "Not Found", "/users/999");

        ra.andExpect(jsonPath("$.detail").value("Resource 'User' #999 not found"))
                .andExpect(jsonPath("$.details.resource").value("User"))
                .andExpect(jsonPath("$.details.id").value(999));

        verify(userService).get(999L);
        verifyNoMoreInteractions(userService);
    }

    @Test
    void testGetAll_shouldReturnAllUsers() throws Exception {
        when(userService.list()).thenReturn(userResponses);

        mockMvc.perform(get("/users"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].id").value(1))
                .andExpect(jsonPath("$[0].firstName").value("John"));

        verify(userService).list();
        verifyNoMoreInteractions(userService);
    }

    @Test
    void testPost_shouldCreateUser() throws Exception {
        String requestBody = """
                {
                    "username": "johndoe",
                    "password": "password123",
                    "firstName": "John",
                    "lastName": "Doe",
                    "email": "john.doe@example.com",
                    "phoneNumber": "+1234567890"
                }
                """;

        when(userService.create(any())).thenReturn(userResponse);

        mockMvc.perform(post("/users")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isCreated())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.firstName").value("John"));

        verify(userService).create(any(UserModels.PostUserRequest.class));
        verifyNoMoreInteractions(userService);
    }

    @Test
    void testPost_withInvalidData_shouldReturn422_withProblemDetails() throws Exception {
        String requestBody = """
                {
                    "username": "",
                    "password": "password123",
                    "firstName": "",
                    "lastName": "Doe",
                    "email": "invalid-email",
                    "phoneNumber": "+1234567890"
                }
                """;

        var ra = mockMvc.perform(post("/users")
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestBody));

        expectProblemResponse(ra, 422, "Unprocessable Entity", "/users");

        verifyNoInteractions(userService);
    }

    @Test
    void testPost_withMissingRequiredFields_shouldReturn422_withProblemDetails() throws Exception {
        String requestBody = """
                {
                    "username": "johndoe"
                }
                """;

        var ra = mockMvc.perform(post("/users")
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestBody));

        expectProblemResponse(ra, 422, "Unprocessable Entity", "/users");

        verifyNoInteractions(userService);
    }

    @Test
    void testPut_shouldReplaceUser() throws Exception {
        String requestBody = """
                {
                    "username": "johndoe",
                    "firstName": "UpdatedJohn",
                    "lastName": "UpdatedDoe",
                    "email": "updated@example.com",
                    "phoneNumber": "+9999999999"
                }
                """;

        UserModels.UserResponse updatedModel = new UserModels.UserResponse(
                1L,
                "johndoe",
                "UpdatedJohn",
                "UpdatedDoe",
                "updated@example.com",
                "+9999999999",
                false,
                false
        );

        when(userService.replace(eq(1L), any())).thenReturn(updatedModel);

        mockMvc.perform(put("/users/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.firstName").value("UpdatedJohn"))
                .andExpect(jsonPath("$.email").value("updated@example.com"));

        verify(userService).replace(eq(1L), any(UserModels.PutUserRequest.class));
        verifyNoMoreInteractions(userService);
    }

    @Test
    void testPut_whenUserNotExists_shouldReturn404_withProblemDetails() throws Exception {
        String requestBody = """
                {
                    "username": "johndoe",
                    "firstName": "John",
                    "lastName": "Doe",
                    "email": "john@example.com",
                    "phoneNumber": "+123456"
                }
                """;

        when(userService.replace(eq(999L), any()))
                .thenThrow(new ResourceNotFound("User", 999L));

        var ra = mockMvc.perform(put("/users/999")
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestBody));

        expectProblemResponse(ra, 404, "Not Found", "/users/999");

        ra.andExpect(jsonPath("$.detail").value("Resource 'User' #999 not found"))
                .andExpect(jsonPath("$.details.resource").value("User"))
                .andExpect(jsonPath("$.details.id").value(999));

        verify(userService).replace(eq(999L), any(UserModels.PutUserRequest.class));
        verifyNoMoreInteractions(userService);
    }

    @Test
    void testPatch_shouldUpdateUser() throws Exception {
        String requestBody = """
                {
                    "firstName": "Jane"
                }
                """;

        UserModels.UserResponse patchedModel = new UserModels.UserResponse(
                1L,
                "johndoe",
                "Jane",
                "Doe",
                "john.doe@example.com",
                "+1234567890",
                false,
                false
        );

        when(userService.update(eq(1L), any())).thenReturn(patchedModel);

        mockMvc.perform(patch("/users/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.firstName").value("Jane"))
                .andExpect(jsonPath("$.lastName").value("Doe"));

        verify(userService).update(eq(1L), any(UserModels.PatchUserRequest.class));
        verifyNoMoreInteractions(userService);
    }

    @Test
    void testPatch_whenUserNotExists_shouldReturn404_withProblemDetails() throws Exception {
        String requestBody = """
                {
                    "firstName": "Jane"
                }
                """;

        when(userService.update(eq(999L), any()))
                .thenThrow(new ResourceNotFound("User", 999L));

        var ra = mockMvc.perform(patch("/users/999")
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestBody));

        expectProblemResponse(ra, 404, "Not Found", "/users/999");

        ra.andExpect(jsonPath("$.detail").value("Resource 'User' #999 not found"))
                .andExpect(jsonPath("$.details.resource").value("User"))
                .andExpect(jsonPath("$.details.id").value(999));

        verify(userService).update(eq(999L), any(UserModels.PatchUserRequest.class));
        verifyNoMoreInteractions(userService);
    }

    @Test
    void testDelete_shouldDeleteUser() throws Exception {
        mockMvc.perform(delete("/users/1"))
                .andExpect(status().isNoContent());

        verify(userService).delete(1L);
        verifyNoMoreInteractions(userService);
    }

    @Test
    void testDelete_whenUserNotExists_shouldReturn404_withProblemDetails() throws Exception {
        doThrow(new ResourceNotFound("User", 999L))
                .when(userService).delete(999L);

        var ra = mockMvc.perform(delete("/users/999"));

        expectProblemResponse(ra, 404, "Not Found", "/users/999");

        ra.andExpect(jsonPath("$.detail").value("Resource 'User' #999 not found"))
                .andExpect(jsonPath("$.details.resource").value("User"))
                .andExpect(jsonPath("$.details.id").value(999));

        verify(userService).delete(999L);
        verifyNoMoreInteractions(userService);
    }

    // ---------- Extra controller routes that were missing in tests ----------

    @Test
    void testGetMe_shouldReturnCurrentUser() throws Exception {
        when(userService.getCurrentUser()).thenReturn(userResponse);

        mockMvc.perform(get("/users/me"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.username").value("johndoe"));

        verify(userService).getCurrentUser();
        verifyNoMoreInteractions(userService);
    }

    @Test
    void testGetTeams_shouldReturnTeams() throws Exception {
        TeamModels.TeamResponse team = new TeamModels.TeamResponse(10L, "Dev Team", "Main dev team");
        when(userService.getTeams(1L)).thenReturn(new TeamModels.TeamResponse[]{team});

        mockMvc.perform(get("/users/1/teams"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$[0].id").value(10))
                .andExpect(jsonPath("$[0].name").value("Dev Team"));

        verify(userService).getTeams(1L);
        verifyNoMoreInteractions(userService);
    }

    @Test
    void testGetPlannings_shouldReturnPlannings() throws Exception {
        PlanningModels.PlanningResponse planning = new PlanningModels.PlanningResponse(
                50L, 1L, PlanningEntity.WeekDay.MONDAY,
                java.time.LocalTime.of(9, 30),
                java.time.LocalTime.of(17, 30)
        );

        when(userService.getPlannings(1L)).thenReturn(new PlanningModels.PlanningResponse[]{planning});

        mockMvc.perform(get("/users/1/plannings"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$[0].id").value(50))
                .andExpect(jsonPath("$[0].userId").value(1));

        verify(userService).getPlannings(1L);
        verifyNoMoreInteractions(userService);
    }

    // ---------- /users/{id}/clocks query binding + validation ----------

    @Test
    void testClocks_noQuery_shouldDelegateWithNullsAndCurrentFalse() throws Exception {
        when(userService.getClocks(eq(1L), any())).thenReturn(new Long[]{});

        mockMvc.perform(get("/users/1/clocks"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(content().json("[]"));

        ArgumentCaptor<UserScheduleQuery> captor = ArgumentCaptor.forClass(UserScheduleQuery.class);
        verify(userService).getClocks(eq(1L), captor.capture());
        verifyNoMoreInteractions(userService);

        UserScheduleQuery q = captor.getValue();
        assertThat(q.getFrom()).isNull();
        assertThat(q.getTo()).isNull();
        assertThat(q.getCurrent()).isFalse();
    }

    @Test
    void testClocks_fromOnly_shouldBindFromAndDelegate() throws Exception {
        String from = "2026-01-01T10:00:00+01:00";
        when(userService.getClocks(eq(1L), any())).thenReturn(new Long[]{123L});

        mockMvc.perform(get("/users/1/clocks").param("from", from))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(content().json("[123]"));

        ArgumentCaptor<UserScheduleQuery> captor = ArgumentCaptor.forClass(UserScheduleQuery.class);
        verify(userService).getClocks(eq(1L), captor.capture());
        verifyNoMoreInteractions(userService);

        UserScheduleQuery q = captor.getValue();
        assertThat(q.getFrom()).isEqualTo(java.time.OffsetDateTime.parse(from));
        assertThat(q.getTo()).isNull();
        assertThat(q.getCurrent()).isFalse();
    }

    @Test
    void testClocks_toOnly_shouldBindToAndDelegate() throws Exception {
        String to = "2026-01-10T10:00:00+01:00";
        when(userService.getClocks(eq(1L), any())).thenReturn(new Long[]{111L, 222L});

        mockMvc.perform(get("/users/1/clocks").param("to", to))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(content().json("[111,222]"));

        ArgumentCaptor<UserScheduleQuery> captor = ArgumentCaptor.forClass(UserScheduleQuery.class);
        verify(userService).getClocks(eq(1L), captor.capture());
        verifyNoMoreInteractions(userService);

        UserScheduleQuery q = captor.getValue();
        assertThat(q.getFrom()).isNull();
        assertThat(q.getTo()).isEqualTo(java.time.OffsetDateTime.parse(to));
        assertThat(q.getCurrent()).isFalse();
    }

    @Test
    void testClocks_fromAndTo_shouldBindBothAndDelegate() throws Exception {
        String from = "2026-01-01T10:00:00+01:00";
        String to = "2026-01-10T10:00:00+01:00";
        when(userService.getClocks(eq(1L), any())).thenReturn(new Long[]{1L, 2L, 3L});

        mockMvc.perform(get("/users/1/clocks")
                        .param("from", from)
                        .param("to", to))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(content().json("[1,2,3]"));

        ArgumentCaptor<UserScheduleQuery> captor = ArgumentCaptor.forClass(UserScheduleQuery.class);
        verify(userService).getClocks(eq(1L), captor.capture());
        verifyNoMoreInteractions(userService);

        UserScheduleQuery q = captor.getValue();
        assertThat(q.getFrom()).isEqualTo(java.time.OffsetDateTime.parse(from));
        assertThat(q.getTo()).isEqualTo(java.time.OffsetDateTime.parse(to));
        assertThat(q.getCurrent()).isFalse();
    }

    @Test
    void testClocks_currentTrue_shouldBindCurrentAndDelegate() throws Exception {
        when(userService.getClocks(eq(1L), any())).thenReturn(new Long[]{999L});

        mockMvc.perform(get("/users/1/clocks").param("current", "true"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(content().json("[999]"));

        ArgumentCaptor<UserScheduleQuery> captor = ArgumentCaptor.forClass(UserScheduleQuery.class);
        verify(userService).getClocks(eq(1L), captor.capture());
        verifyNoMoreInteractions(userService);

        UserScheduleQuery q = captor.getValue();
        assertThat(q.getCurrent()).isTrue();
        assertThat(q.getFrom()).isNull();
        assertThat(q.getTo()).isNull();
    }

    @Test
    void testClocks_currentEmpty_shouldBindAsFalse_andDelegate() throws Exception {
        when(userService.getClocks(eq(1L), any())).thenReturn(new Long[]{1L, 2L});

        mockMvc.perform(get("/users/1/clocks").param("current", ""))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(content().json("[1,2]"));

        ArgumentCaptor<UserScheduleQuery> captor = ArgumentCaptor.forClass(UserScheduleQuery.class);
        verify(userService).getClocks(eq(1L), captor.capture());
        verifyNoMoreInteractions(userService);

        // depending on your binder, "" may become null -> your query getter defaults false,
        // or be treated as false directly; the important part is "not true".
        UserScheduleQuery q = captor.getValue();
        assertThat(q.isCurrent()).isFalse();
    }

    @Test
    void testClocks_currentTrue_withFrom_shouldReturn422_withProblemDetails_andNotCallService() throws Exception {
        var ra = mockMvc.perform(get("/users/1/clocks")
                .param("current", "true")
                .param("from", "2026-01-01T10:00:00+01:00"));

        expectProblemResponse(ra, 422, "Unprocessable Entity", "/users/1/clocks");

        verifyNoInteractions(userService);
    }

    @Test
    void testClocks_currentTrue_withTo_shouldReturn422_withProblemDetails_andNotCallService() throws Exception {
        var ra = mockMvc.perform(get("/users/1/clocks")
                .param("current", "true")
                .param("to", "2026-01-10T10:00:00+01:00"));

        expectProblemResponse(ra, 422, "Unprocessable Entity", "/users/1/clocks");

        verifyNoInteractions(userService);
    }

    @Test
    void testClocks_currentTrue_withFromAndTo_shouldReturn422_withProblemDetails_andNotCallService() throws Exception {
        var ra = mockMvc.perform(get("/users/1/clocks")
                .param("current", "true")
                .param("from", "2026-01-01T10:00:00+01:00")
                .param("to", "2026-01-10T10:00:00+01:00"));

        expectProblemResponse(ra, 422, "Unprocessable Entity", "/users/1/clocks");

        verifyNoInteractions(userService);
    }

    @Test
    void testClocks_invalidFromFormat_shouldReturn422_withProblemDetails_andNotCallService() throws Exception {
        var ra = mockMvc.perform(get("/users/1/clocks")
                .param("from", "not-a-date"));

        expectProblemResponse(ra, 422, "Unprocessable Entity", "/users/1/clocks");

        verifyNoInteractions(userService);
    }

}
