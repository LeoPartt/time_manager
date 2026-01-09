package eu.epitech.t_dev_700.controllers;

import eu.epitech.t_dev_700.models.AuthModels;
import eu.epitech.t_dev_700.services.AuthService;
import eu.epitech.t_dev_700.services.JwtService;
import eu.epitech.t_dev_700.services.exceptions.InvalidCredentials;
import eu.epitech.t_dev_700.services.exceptions.UnknownUser;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.Matchers.matchesPattern;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(AuthController.class)
@ActiveProfiles("test")
@AutoConfigureMockMvc(addFilters = false)
class AuthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private AuthService authService;

    @MockitoBean
    private JwtService jwtService;

    @Test
    void testPostLogin_whenValidCredentials_shouldReturnToken() throws Exception {
        String requestBody = """
                {
                  "username": "john.doe",
                  "password": "SecurePass123!"
                }
                """;

        when(authService.authenticate(any(AuthModels.LoginRequest.class)))
                .thenReturn("jwt.token.value");
        when(jwtService.getExpirationTime()).thenReturn(3600000L);

        mockMvc.perform(post("/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.token").value("jwt.token.value"))
                .andExpect(jsonPath("$.expiresIn").value(3600000));

        verify(authService, times(1)).authenticate(any(AuthModels.LoginRequest.class));
        verify(jwtService, times(1)).getExpirationTime();
    }

    @Test
    void testPostLogin_whenInvalidCredentials_shouldReturn401_withDetails() throws Exception {
        String requestBody = """
                {
                  "username": "john.doe",
                  "password": "wrong"
                }
                """;

        when(authService.authenticate(any(AuthModels.LoginRequest.class)))
                .thenThrow(new InvalidCredentials("Invalid credentials", "john.doe", null));

        mockMvc.perform(post("/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isUnauthorized())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))

                // ErrorModels.ErrorResponse shape
                .andExpect(jsonPath("$.title").value("Unauthorized"))
                .andExpect(jsonPath("$.status").value(401))
                .andExpect(jsonPath("$.detail").value("Invalid credentials"))
                .andExpect(jsonPath("$.instance").value("/auth/login"))
                .andExpect(jsonPath("$.details").isMap())
                .andExpect(jsonPath("$.at").isString())
                // ISO-8601-ish timestamp (Instant)
                .andExpect(jsonPath("$.at", matchesPattern("^\\d{4}-\\d{2}-\\d{2}T.*Z$")))

                // typed details for this exception
                .andExpect(jsonPath("$.details.username").value("john.doe"));
    }

    @Test
    void testPostLogin_whenUnknownUser_shouldReturn401_withDetails() throws Exception {
        String requestBody = """
                {
                  "username": "ghost",
                  "password": "whatever"
                }
                """;

        when(authService.authenticate(any(AuthModels.LoginRequest.class)))
                .thenThrow(new UnknownUser("ghost"));

        mockMvc.perform(post("/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isUnauthorized())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))

                // ErrorModels.ErrorResponse shape
                .andExpect(jsonPath("$.title").value("Unauthorized"))
                .andExpect(jsonPath("$.status").value(401))
                .andExpect(jsonPath("$.detail").value("Unknown user"))
                .andExpect(jsonPath("$.instance").value("/auth/login"))
                .andExpect(jsonPath("$.details").isMap())
                .andExpect(jsonPath("$.at").isString())
                .andExpect(jsonPath("$.at", matchesPattern("^\\d{4}-\\d{2}-\\d{2}T.*Z$")))

                // typed details for this exception
                .andExpect(jsonPath("$.details.username").value("ghost"));
    }

    @Test
    void testPostLogin_withMissingRequiredFields_shouldReturn422_withErrorBody() throws Exception {
        String requestBody = """
                {
                  "username": "john.doe"
                }
                """;

        mockMvc.perform(post("/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isUnprocessableEntity())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))

                // Keep these assertions “structure-based” because the exact validation payload can vary
                .andExpect(jsonPath("$.title").value("Unprocessable Entity"))
                .andExpect(jsonPath("$.status").value(422))
                .andExpect(jsonPath("$.instance").value("/auth/login"))
                .andExpect(jsonPath("$.details").exists())
                .andExpect(jsonPath("$.at").isString());
    }

    @Test
    void testPostLogin_withMalformedJson_shouldReturn400_withErrorBody() throws Exception {
        // missing closing quote and brace
        String requestBody = """
                {
                  "username": "john.doe,
                  "password": "SecurePass123!"
                }
                """;

        mockMvc.perform(post("/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isBadRequest())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))

                // Based on your previous output:
                .andExpect(jsonPath("$.title").value("Bad Request"))
                .andExpect(jsonPath("$.status").value(400))
                .andExpect(jsonPath("$.detail").value("Malformed JSON body"))
                .andExpect(jsonPath("$.instance").value("/auth/login"))
                .andExpect(jsonPath("$.details").exists())
                .andExpect(jsonPath("$.at").isString());
    }

    @Test
    void testResetPassword_shouldReturn204() throws Exception {
        doNothing().when(authService).resetPassword();

        mockMvc.perform(post("/auth/reset"))
                .andExpect(status().isNoContent());

        verify(authService, times(1)).resetPassword();
    }

    @Test
    void testChangePassword_shouldReturn204() throws Exception {
        String requestBody = """
                {
                  "code": "A0x1Q3",
                  "password": "NewSecurePass123!"
                }
                """;

        doNothing().when(authService).changePassword(any(AuthModels.ChangeRequest.class));

        mockMvc.perform(post("/auth/change")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isNoContent());

        verify(authService, times(1)).changePassword(any(AuthModels.ChangeRequest.class));
    }

    @Test
    void testChangePassword_withMissingRequiredFields_shouldReturn422_withErrorBody() throws Exception {
        String requestBody = """
                {
                  "code": "A0x1Q3"
                }
                """;

        mockMvc.perform(post("/auth/change")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isUnprocessableEntity())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.title").value("Unprocessable Entity"))
                .andExpect(jsonPath("$.status").value(422))
                .andExpect(jsonPath("$.instance").value("/auth/change"))
                .andExpect(jsonPath("$.details").exists())
                .andExpect(jsonPath("$.at").isString());
    }
}
