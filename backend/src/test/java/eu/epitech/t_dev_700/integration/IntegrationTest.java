package eu.epitech.t_dev_700.integration;

import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.repositories.AccountRepository;
import eu.epitech.t_dev_700.repositories.TeamRepository;
import eu.epitech.t_dev_700.repositories.UserRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.hamcrest.Matchers.hasSize;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc(addFilters = false)
@ActiveProfiles("test")
@Transactional
class IntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private TeamRepository teamRepository;

    @PersistenceContext
    private EntityManager entityManager;

    @BeforeEach
    void setUp() {
        // Clean up database before each test
        userRepository.deleteAll();
        accountRepository.deleteAll();
        teamRepository.deleteAll();

        UserEntity user = new UserEntity();
        user.setFirstName("Foo");
        user.setLastName("Bar");
        user.setEmail("foo@bar.com");
        user.setAccount(new AccountEntity());
        user.getAccount().setUser(user);
        user.getAccount().setUsername("foobar");
        user.getAccount().setPassword("1234");
        userRepository.save(user);
        SecurityContext context = SecurityContextHolder.createEmptyContext();
        context.setAuthentication(
                new UsernamePasswordAuthenticationToken(user.getAccount(), null, List.of())
        );
        SecurityContextHolder.setContext(context);
    }

    @Test
    void testUserCRUD_fullFlow() throws Exception {
        // Create a user
        String createRequest = """
                {
                    "username": "johndoe",
                    "password": "password123",
                    "firstName": "John",
                    "lastName": "Doe",
                    "email": "john.doe@example.com",
                    "phoneNumber": "+1234567890"
                }
                """;

        String createResponse = mockMvc.perform(post("/users")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(createRequest))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").exists())
                .andExpect(jsonPath("$.firstName").value("John"))
                .andExpect(jsonPath("$.lastName").value("Doe"))
                .andReturn()
                .getResponse()
                .getContentAsString();

        // Extract ID from response
        Long userId = extractIdFromJson(createResponse);

        // Get the created user
        mockMvc.perform(get("/users/" + userId))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.firstName").value("John"))
                .andExpect(jsonPath("$.email").value("john.doe@example.com"));

        // Update the user (PATCH)
        String patchRequest = """
                {
                    "firstName": "Jane"
                }
                """;

        mockMvc.perform(patch("/users/" + userId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(patchRequest))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.firstName").value("Jane"))
                .andExpect(jsonPath("$.lastName").value("Doe")); // Unchanged

        // Replace the user (PUT)
        String putRequest = """
                {
                    "username": "janedoe",
                    "firstName": "Jane",
                    "lastName": "Smith",
                    "email": "jane.smith@example.com",
                    "phoneNumber": "+0987654321"
                }
                """;

        mockMvc.perform(put("/users/" + userId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(putRequest))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.lastName").value("Smith"))
                .andExpect(jsonPath("$.email").value("jane.smith@example.com"));

        // List all users
        mockMvc.perform(get("/users"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(2)));

        // Delete the user
        mockMvc.perform(delete("/users/" + userId))
                .andExpect(status().isNoContent());

        // Verify user is deleted (soft delete - should not appear in list)
        mockMvc.perform(get("/users/" + userId))
                .andExpect(status().isNotFound());

        mockMvc.perform(get("/users"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)));
    }

    @Test
    void testTeamCRUD_fullFlow() throws Exception {
        // Create a team
        String createRequest = """
                {
                    "name": "Development Team",
                    "description": "A team of developers"
                }
                """;

        String createResponse = mockMvc.perform(post("/teams")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(createRequest))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").exists())
                .andExpect(jsonPath("$.name").value("Development Team"))
                .andReturn()
                .getResponse()
                .getContentAsString();

        Long teamId = extractIdFromJson(createResponse);
        entityManager.flush();
        entityManager.clear();

        // Get the created team
        mockMvc.perform(get("/teams/" + teamId))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("Development Team"))
                .andExpect(jsonPath("$.description").value("A team of developers"));

        // Update the team (PATCH)
        String patchRequest = """
                {
                    "description": "Updated description"
                }
                """;

        mockMvc.perform(patch("/teams/" + teamId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(patchRequest))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("Development Team")) // Unchanged
                .andExpect(jsonPath("$.description").value("Updated description"));
        entityManager.flush();
        entityManager.clear();

        // Replace the team (PUT)
        String putRequest = """
                {
                    "name": "QA Team",
                    "description": "Quality assurance team"
                }
                """;

        mockMvc.perform(put("/teams/" + teamId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(putRequest))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("QA Team"))
                .andExpect(jsonPath("$.description").value("Quality assurance team"));
        entityManager.flush();
        entityManager.clear();

        // List all teams
        mockMvc.perform(get("/teams"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)));

        // Delete the team
        mockMvc.perform(delete("/teams/" + teamId))
                .andExpect(status().isNoContent());
        entityManager.flush();
        entityManager.clear();

        // Verify team is deleted
        mockMvc.perform(get("/teams/" + teamId))
                .andExpect(status().isNotFound());

        mockMvc.perform(get("/teams"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(0)));
    }

    @Test
    void testMultipleUsers_shouldBeListedCorrectly() throws Exception {
        // Create multiple users
        for (int i = 1; i <= 3; i++) {
            String request = String.format("""
                    {
                        "username": "user%d",
                        "password": "password",
                        "firstName": "User",
                        "lastName": "Number%d",
                        "email": "user%d@example.com",
                        "phoneNumber": "+%d"
                    }
                    """, i, i, i, i);

            mockMvc.perform(post("/users")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(request))
                    .andExpect(status().isCreated());
        }

        // Verify all users are listed
        mockMvc.perform(get("/users"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(4)))
                .andExpect(jsonPath("$[1].firstName").value("User"))
                .andExpect(jsonPath("$[2].firstName").value("User"))
                .andExpect(jsonPath("$[3].firstName").value("User"));
    }

    @Test
    void testUserPasswordEncoding_shouldBeEncrypted() throws Exception {
        String createRequest = """
                {
                    "username": "testuser",
                    "password": "plainPassword",
                    "firstName": "Test",
                    "lastName": "User",
                    "email": "test@example.com",
                    "phoneNumber": "+123456"
                }
                """;

        mockMvc.perform(post("/users")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(createRequest))
                .andExpect(status().isCreated());

        // Verify password is encrypted in database
        UserEntity user = userRepository.findAll().get(1);
        assertThat(user.getAccount()).isNotNull();
        assertThat(user.getAccount().getPassword()).isNotEqualTo("plainPassword");
        assertThat(user.getAccount().getPassword()).startsWith("{bcrypt}");
    }

    @Test
    void testSoftDelete_usersShouldNotAppearAfterDeletion() throws Exception {
        // Create two users
        String user1 = """
                {
                    "username": "user1",
                    "password": "password",
                    "firstName": "User",
                    "lastName": "One",
                    "email": "user1@example.com",
                    "phoneNumber": "+1"
                }
                """;

        String user2 = """
                {
                    "username": "user2",
                    "password": "password",
                    "firstName": "User",
                    "lastName": "Two",
                    "email": "user2@example.com",
                    "phoneNumber": "+2"
                }
                """;

        String response1 = mockMvc.perform(post("/users")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(user1))
                .andExpect(status().isCreated())
                .andReturn()
                .getResponse()
                .getContentAsString();

        mockMvc.perform(post("/users")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(user2))
                .andExpect(status().isCreated());

        Long userId1 = extractIdFromJson(response1);

        // Verify both users exist
        mockMvc.perform(get("/users"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(3)));

        // Delete first user
        mockMvc.perform(delete("/users/" + userId1))
                .andExpect(status().isNoContent());

        // Verify only one user remains
        mockMvc.perform(get("/users"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(2)))
                .andExpect(jsonPath("$[1].lastName").value("Two"));
    }

    @Test
    void testValidation_shouldRejectInvalidData() throws Exception {
        // Missing required fields
        String invalidRequest = """
                {
                    "username": "test"
                }
                """;

        mockMvc.perform(post("/users")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(invalidRequest))
                .andExpect(status().isUnprocessableEntity());

        // Invalid email
        String invalidEmail = """
                {
                    "username": "testuser",
                    "password": "password",
                    "firstName": "Test",
                    "lastName": "User",
                    "email": "not-an-email",
                    "phoneNumber": "+123"
                }
                """;

        mockMvc.perform(post("/users")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(invalidEmail))
                .andExpect(status().isUnprocessableEntity());

        // Blank required fields
        String blankFields = """
                {
                    "username": "  ",
                    "password": "password",
                    "firstName": "  ",
                    "lastName": "User",
                    "email": "test@example.com",
                    "phoneNumber": "+123"
                }
                """;

        mockMvc.perform(post("/users")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(blankFields))
                .andExpect(status().isUnprocessableEntity());
    }

    private Long extractIdFromJson(String json) {
        // Simple extraction of id from JSON toResponse
        String idString = json.split("\"id\":")[1].split(",")[0].trim();
        return Long.parseLong(idString);
    }
}
