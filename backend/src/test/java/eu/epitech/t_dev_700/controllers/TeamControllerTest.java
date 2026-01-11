package eu.epitech.t_dev_700.controllers;

import eu.epitech.t_dev_700.config.filters.JwtAuthenticationFilter;
import eu.epitech.t_dev_700.models.TeamModels;
import eu.epitech.t_dev_700.models.UserModels;
import eu.epitech.t_dev_700.services.TeamService;
import eu.epitech.t_dev_700.services.exceptions.AlreadyMember;
import eu.epitech.t_dev_700.services.exceptions.NotAMember;
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
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(
        controllers = TeamController.class,
        excludeFilters = @ComponentScan.Filter(
                type = FilterType.ASSIGNABLE_TYPE,
                classes = JwtAuthenticationFilter.class
        )
)
@ActiveProfiles("test")
@AutoConfigureMockMvc(addFilters = false)
class TeamControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private TeamService teamService;

    private TeamModels.TeamResponse teamResponse;
    private TeamModels.TeamResponse[] teamResponses;

    private UserModels.UserResponse userResponse;
    private UserModels.UserResponse[] userResponses;

    @BeforeEach
    void setUp() {
        teamResponse = new TeamModels.TeamResponse(
                1L,
                "Development Team",
                "A team of developers"
        );
        teamResponses = new TeamModels.TeamResponse[]{teamResponse};

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

    // ---- Helpers (RFC9457 assertions) ----

    private void assertRfc9457Base(ResultActions ra, int status, String title, String instance) throws Exception {
        ra.andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.title").value(title))
                .andExpect(jsonPath("$.status").value(status))
                .andExpect(jsonPath("$.detail").isNotEmpty())
                .andExpect(jsonPath("$.instance").value(instance))
                .andExpect(jsonPath("$.details").exists())
                // "at" is an Instant serialized to ISO-8601 string (we only assert it's present/non-empty)
                .andExpect(jsonPath("$.at").isNotEmpty());
    }

    private void assertResourceNotFound(ResultActions ra, String instance, String resource, long id) throws Exception {
        assertRfc9457Base(ra, 404, "Not Found", instance);
        ra.andExpect(jsonPath("$.detail").value("Resource '%s' #%d not found".formatted(resource, id)))
                .andExpect(jsonPath("$.details.resource").value(resource))
                .andExpect(jsonPath("$.details.id").value((int) id)); // json numbers often come back as Integer
    }

    // ---- CRUD: GET /teams/{id} ----

    @Test
    void testGet_whenTeamExists_shouldReturnTeam() throws Exception {
        when(teamService.get(1L)).thenReturn(teamResponse);

        mockMvc.perform(get("/teams/1"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.name").value("Development Team"))
                .andExpect(jsonPath("$.description").value("A team of developers"));

        verify(teamService).get(1L);
    }

    @Test
    void testGet_whenTeamNotExists_shouldReturn404_withErrorDetails() throws Exception {
        when(teamService.get(999L)).thenThrow(new ResourceNotFound("Team", 999L));

        ResultActions ra = mockMvc.perform(get("/teams/999"))
                .andExpect(status().isNotFound());

        assertResourceNotFound(ra, "/teams/999", "Team", 999L);
        verify(teamService).get(999L);
    }

    // ---- CRUD: GET /teams ----

    @Test
    void testGetAll_shouldReturnAllTeams() throws Exception {
        when(teamService.list()).thenReturn(teamResponses);

        mockMvc.perform(get("/teams"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].id").value(1))
                .andExpect(jsonPath("$[0].name").value("Development Team"));

        verify(teamService).list();
    }

    // ---- CRUD: POST /teams ----

    @Test
    void testPost_shouldCreateTeam() throws Exception {
        String requestBody = """
                {
                    "name": "Development Team",
                    "description": "A team of developers"
                }
                """;

        when(teamService.create(any())).thenReturn(teamResponse);

        mockMvc.perform(post("/teams")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isCreated())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.name").value("Development Team"))
                .andExpect(jsonPath("$.description").value("A team of developers"));

        verify(teamService).create(any());
    }

    @Test
    void testPost_withInvalidData_shouldReturn422_withRfc9457Envelope() throws Exception {
        // name is @NotBlank => invalid
        String requestBody = """
                {
                    "name": "",
                    "description": "Description"
                }
                """;

        ResultActions ra = mockMvc.perform(post("/teams")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isUnprocessableEntity());

        // We assert RFC9457 envelope without assuming exact validation "details" structure
        assertRfc9457Base(ra, 422, "Unprocessable Entity", "/teams");

        // If your validation handler puts field errors in a map, this is a safe-ish extra check:
        ra.andExpect(jsonPath("$.details").isNotEmpty());
    }

    @Test
    void testPost_withMissingRequiredFields_shouldReturn422_withRfc9457Envelope() throws Exception {
        // name missing => @NotBlank violation
        String requestBody = """
                {
                    "description": "Only description"
                }
                """;

        ResultActions ra = mockMvc.perform(post("/teams")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isUnprocessableEntity());

        assertRfc9457Base(ra, 422, "Unprocessable Entity", "/teams");
    }

    // ---- CRUD: PUT /teams/{id} ----

    @Test
    void testPut_shouldReplaceTeam() throws Exception {
        String requestBody = """
                {
                    "name": "Updated Team",
                    "description": "Updated description"
                }
                """;

        TeamModels.TeamResponse updatedModel = new TeamModels.TeamResponse(
                1L,
                "Updated Team",
                "Updated description"
        );

        when(teamService.replace(eq(1L), any())).thenReturn(updatedModel);

        mockMvc.perform(put("/teams/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.name").value("Updated Team"))
                .andExpect(jsonPath("$.description").value("Updated description"));

        verify(teamService).replace(eq(1L), any());
    }

    @Test
    void testPut_whenTeamNotExists_shouldReturn404_withErrorDetails() throws Exception {
        String requestBody = """
                {
                    "name": "Team",
                    "description": "Description"
                }
                """;

        when(teamService.replace(eq(999L), any()))
                .thenThrow(new ResourceNotFound("Team", 999L));

        ResultActions ra = mockMvc.perform(put("/teams/999")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isNotFound());

        assertResourceNotFound(ra, "/teams/999", "Team", 999L);
        verify(teamService).replace(eq(999L), any());
    }

    // ---- CRUD: PATCH /teams/{id} ----

    @Test
    void testPatch_shouldUpdateTeam() throws Exception {
        String requestBody = """
                {
                    "description": "New description only"
                }
                """;

        TeamModels.TeamResponse patchedModel = new TeamModels.TeamResponse(
                1L,
                "Development Team",
                "New description only"
        );

        when(teamService.update(eq(1L), any())).thenReturn(patchedModel);

        mockMvc.perform(patch("/teams/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.name").value("Development Team"))
                .andExpect(jsonPath("$.description").value("New description only"));

        verify(teamService).update(eq(1L), any());
    }

    @Test
    void testPatch_withNameOnly_shouldUpdateName() throws Exception {
        String requestBody = """
                {
                    "name": "New Team Name"
                }
                """;

        TeamModels.TeamResponse patchedModel = new TeamModels.TeamResponse(
                1L,
                "New Team Name",
                "A team of developers"
        );

        when(teamService.update(eq(1L), any())).thenReturn(patchedModel);

        mockMvc.perform(patch("/teams/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.name").value("New Team Name"))
                .andExpect(jsonPath("$.description").value("A team of developers"));

        verify(teamService).update(eq(1L), any());
    }

    @Test
    void testPatch_whenTeamNotExists_shouldReturn404_withErrorDetails() throws Exception {
        String requestBody = """
                {
                    "name": "New Name"
                }
                """;

        when(teamService.update(eq(999L), any()))
                .thenThrow(new ResourceNotFound("Team", 999L));

        ResultActions ra = mockMvc.perform(patch("/teams/999")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isNotFound());

        assertResourceNotFound(ra, "/teams/999", "Team", 999L);
        verify(teamService).update(eq(999L), any());
    }

    // ---- CRUD: DELETE /teams/{id} ----

    @Test
    void testDelete_shouldDeleteTeam() throws Exception {
        mockMvc.perform(delete("/teams/1"))
                .andExpect(status().isNoContent())
                .andExpect(content().string(""));

        verify(teamService).delete(1L);
    }

    @Test
    void testDelete_whenTeamNotExists_shouldReturn404_withErrorDetails() throws Exception {
        doThrow(new ResourceNotFound("Team", 999L))
                .when(teamService).delete(999L);

        ResultActions ra = mockMvc.perform(delete("/teams/999"))
                .andExpect(status().isNotFound());

        assertResourceNotFound(ra, "/teams/999", "Team", 999L);
        verify(teamService).delete(999L);
    }

    // =========================================================
    // Additional endpoints present in TeamController (missing before)
    // =========================================================

    // ---- GET /teams/{id}/members ----

    @Test
    void testGetMembers_shouldReturnMembers() throws Exception {
        when(teamService.getByTeam(1L)).thenReturn(userResponses);

        mockMvc.perform(get("/teams/1/members"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].id").value(1))
                .andExpect(jsonPath("$[0].username").value("johndoe"));

        verify(teamService).getByTeam(1L);
    }

    @Test
    void testGetMembers_whenTeamNotExists_shouldReturn404_withErrorDetails() throws Exception {
        when(teamService.getByTeam(999L)).thenThrow(new ResourceNotFound("Team", 999L));

        ResultActions ra = mockMvc.perform(get("/teams/999/members"))
                .andExpect(status().isNotFound());

        assertResourceNotFound(ra, "/teams/999/members", "Team", 999L);
        verify(teamService).getByTeam(999L);
    }

    // ---- POST /teams/{id}/members/{userId} ----

    @Test
    void testPostMembership_shouldReturn204() throws Exception {
        mockMvc.perform(post("/teams/1/members/42"))
                .andExpect(status().isNoContent())
                .andExpect(content().string(""));

        verify(teamService).postMembership(1L, 42L);
    }

    @Test
    void testPostMembership_whenAlreadyMember_shouldReturn409_withDetails() throws Exception {
        doThrow(new AlreadyMember(42L, 1L)).when(teamService).postMembership(1L, 42L);

        ResultActions ra = mockMvc.perform(post("/teams/1/members/42"))
                .andExpect(status().isConflict());

        assertRfc9457Base(ra, 409, "Conflict", "/teams/1/members/42");
        ra.andExpect(jsonPath("$.details.userId").value(42))
                .andExpect(jsonPath("$.details.teamId").value(1));

        verify(teamService).postMembership(1L, 42L);
    }

    @Test
    void testPostMembership_whenTeamNotExists_shouldReturn404_withErrorDetails() throws Exception {
        doThrow(new ResourceNotFound("Team", 999L)).when(teamService).postMembership(999L, 42L);

        ResultActions ra = mockMvc.perform(post("/teams/999/members/42"))
                .andExpect(status().isNotFound());

        assertResourceNotFound(ra, "/teams/999/members/42", "Team", 999L);
        verify(teamService).postMembership(999L, 42L);
    }

    // ---- DELETE /teams/{id}/members/{userId} ----

    @Test
    void testDeleteMembership_shouldReturn204() throws Exception {
        mockMvc.perform(delete("/teams/1/members/42"))
                .andExpect(status().isNoContent())
                .andExpect(content().string(""));

        verify(teamService).deleteMembership(1L, 42L);
    }

    @Test
    void testDeleteMembership_whenNotAMember_shouldReturn409_withDetails() throws Exception {
        doThrow(new NotAMember(42L, 1L)).when(teamService).deleteMembership(1L, 42L);

        ResultActions ra = mockMvc.perform(delete("/teams/1/members/42"))
                .andExpect(status().isConflict());

        assertRfc9457Base(ra, 409, "Conflict", "/teams/1/members/42");
        ra.andExpect(jsonPath("$.details.userId").value(42))
                .andExpect(jsonPath("$.details.teamId").value(1));

        verify(teamService).deleteMembership(1L, 42L);
    }

    // ---- GET /teams/{id}/manager ----

    @Test
    void testGetManager_shouldReturnManager() throws Exception {
        when(teamService.getManager(1L)).thenReturn(userResponse);

        mockMvc.perform(get("/teams/1/manager"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.username").value("johndoe"));

        verify(teamService).getManager(1L);
    }

    @Test
    void testGetManager_whenTeamNotExists_shouldReturn404_withErrorDetails() throws Exception {
        when(teamService.getManager(999L)).thenThrow(new ResourceNotFound("Team", 999L));

        ResultActions ra = mockMvc.perform(get("/teams/999/manager"))
                .andExpect(status().isNotFound());

        assertResourceNotFound(ra, "/teams/999/manager", "Team", 999L);
        verify(teamService).getManager(999L);
    }

    // ---- PATCH /teams/{id}/manager/{userId} ----

    @Test
    void testPatchManager_shouldReturnUpdatedManager() throws Exception {
        UserModels.UserResponse newManager = new UserModels.UserResponse(
                42L, "janedoe", "Jane", "Doe", "jane@example.com", "+33123456789", true, false
        );

        when(teamService.updateManager(1L, 42L)).thenReturn(newManager);

        mockMvc.perform(patch("/teams/1/manager/42"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(42))
                .andExpect(jsonPath("$.username").value("janedoe"));

        verify(teamService).updateManager(1L, 42L);
    }

    // ---- DELETE /teams/{id}/manager ----

    @Test
    void testDeleteManager_shouldReturn204() throws Exception {
        mockMvc.perform(delete("/teams/1/manager"))
                .andExpect(status().isNoContent())
                .andExpect(content().string(""));

        verify(teamService).deleteManager(1L);
    }
}
