package eu.epitech.t_dev_700.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import eu.epitech.t_dev_700.config.filters.JwtAuthenticationFilter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.FilterType;
import org.springframework.context.annotation.Import;
import org.springframework.http.HttpHeaders;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import static org.hamcrest.Matchers.anyOf;
import static org.hamcrest.Matchers.is;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.options;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(
        controllers = SecurityConfigTest.TestEndpoints.class,
        excludeFilters = @ComponentScan.Filter(
                type = FilterType.ASSIGNABLE_TYPE,
                classes = GlobalExceptionHandler.class
        )
)
@Import({SecurityConfiguration.class, SecurityConfigTest.TestEndpoints.class})
@TestPropertySource(properties = {
        "cors.allowed-origins=http://localhost:3000,http://127.0.0.1:5173"
})
class SecurityConfigTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockitoBean
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    @MockitoBean
    private AuthenticationProvider authenticationProvider;

    @RestController
    static class TestEndpoints {
        @GetMapping("/auth/ping")
        public String ping() { return "pong"; }

        @GetMapping("/test/secure")
        public String secure() { return "secure"; }

        @GetMapping("/test/admin")
        @org.springframework.security.access.prepost.PreAuthorize("hasRole('ADMIN')")
        public String admin() { return "admin"; }
    }

    @BeforeEach
    void passThroughJwtFilter() throws Exception {
        doAnswer(invocation -> {
            ServletRequest req = invocation.getArgument(0);
            ServletResponse res = invocation.getArgument(1);
            FilterChain chain = invocation.getArgument(2);
            chain.doFilter(req, res);
            return null;
        }).when(jwtAuthenticationFilter).doFilter(any(), any(), any());
    }

    @Test
    void authEndpoints_shouldBePermitAll() throws Exception {
        mockMvc.perform(get("/auth/ping"))
                .andExpect(status().isOk())
                .andExpect(content().string("pong"));
    }

    @Test
    void secureEndpoint_withoutAuthentication_shouldReturn401_withRfc9457Body() throws Exception {
        mockMvc.perform(get("/test/secure"))
                .andExpect(status().isUnauthorized())
                .andExpect(content().contentTypeCompatibleWith("application/json"))
                .andExpect(jsonPath("$.title").value("Unauthorized"))
                .andExpect(jsonPath("$.status").value(401))
                .andExpect(jsonPath("$.detail").exists())
                .andExpect(jsonPath("$.instance").value("/test/secure"))
                .andExpect(jsonPath("$.details").isMap())
                .andExpect(jsonPath("$.at").exists());
    }

    @Test
    @WithMockUser(username = "user", roles = "EMPLOYEE")
    void adminEndpoint_withNonAdmin_shouldReturn403_withRfc9457Body() throws Exception {
        mockMvc.perform(get("/test/admin"))
                .andExpect(status().isForbidden())
                .andExpect(content().contentTypeCompatibleWith("application/json"))
                .andExpect(jsonPath("$.title").value("Forbidden"))
                .andExpect(jsonPath("$.status").value(403))
                .andExpect(jsonPath("$.detail").exists())
                .andExpect(jsonPath("$.instance").value("/test/admin"))
                .andExpect(jsonPath("$.details").isMap())
                .andExpect(jsonPath("$.at").exists());
    }

    @Test
    @WithMockUser(username = "admin", roles = "ADMIN")
    void adminEndpoint_withAdmin_shouldReturn200() throws Exception {
        mockMvc.perform(get("/test/admin"))
                .andExpect(status().isOk())
                .andExpect(content().string("admin"));
    }

    @Test
    void responses_shouldContainCspHeader() throws Exception {
        mockMvc.perform(get("/auth/ping"))
                .andExpect(status().isOk())
                .andExpect(header().string("Content-Security-Policy",
                        "default-src 'self'; script-src 'self'; object-src 'none'; base-uri 'self'"));
    }

    @Test
    void corsPreflight_shouldReturnCorsHeaders_forAllowedOrigin() throws Exception {
        mockMvc.perform(options("/test/secure")
                        .header(HttpHeaders.ORIGIN, "http://localhost:3000")
                        .header(HttpHeaders.ACCESS_CONTROL_REQUEST_METHOD, "GET")
                        .header(HttpHeaders.ACCESS_CONTROL_REQUEST_HEADERS, "Authorization,Content-Type"))
                .andExpect(status().is(anyOf(is(200), is(204))))
                .andExpect(header().string(HttpHeaders.ACCESS_CONTROL_ALLOW_ORIGIN, "http://localhost:3000"))
                .andExpect(header().string(HttpHeaders.ACCESS_CONTROL_ALLOW_CREDENTIALS, "true"));
    }

    @Test
    void corsRequest_disallowedOrigin_shouldBeRejectedByCorsProcessor() throws Exception {
        mockMvc.perform(get("/auth/ping")
                        .header(HttpHeaders.ORIGIN, "http://evil.com"))
                .andExpect(status().isForbidden())
                .andExpect(content().string("Invalid CORS request"));
    }

    @Test
    void jwtFilter_shouldBeInvoked() throws Exception {
        mockMvc.perform(get("/test/secure"))
                .andExpect(status().isUnauthorized());

        verify(jwtAuthenticationFilter, atLeastOnce()).doFilter(any(), any(), any());
    }

    @Test
    void secureEndpoint_withoutAuthentication_shouldReturn401_andJsonContentType() throws Exception {
        mockMvc.perform(get("/test/secure"))
                .andExpect(status().isUnauthorized())
                .andExpect(header().string(HttpHeaders.CONTENT_TYPE, org.hamcrest.Matchers.containsString("application/json")));
    }

    @Test
    @WithMockUser(username = "user", roles = "EMPLOYEE")
    void adminEndpoint_withNonAdmin_shouldReturn403_andJsonContentType() throws Exception {
        mockMvc.perform(get("/test/admin"))
                .andExpect(status().isForbidden())
                .andExpect(header().string(HttpHeaders.CONTENT_TYPE, org.hamcrest.Matchers.containsString("application/json")));
    }

    @Test
    void secureEndpoint_withoutAuthentication_shouldReturn401_andCustomJson() throws Exception {
        mockMvc.perform(get("/test/secure"))
                .andExpect(status().isUnauthorized())
                .andExpect(content().contentTypeCompatibleWith("application/json"))
                .andExpect(jsonPath("$.status").value(401))
                .andExpect(jsonPath("$.detail").value("Authentication is required to access this resource"))
                .andExpect(jsonPath("$.instance").value("/test/secure"));
    }

    @Test
    @WithMockUser(username = "user", roles = "EMPLOYEE")
    void adminEndpoint_withNonAdmin_shouldReturn403_andCustomJson() throws Exception {
        mockMvc.perform(get("/test/admin"))
                .andExpect(status().isForbidden())
                .andExpect(content().contentTypeCompatibleWith("application/json"))
                .andExpect(jsonPath("$.status").value(403))
                .andExpect(jsonPath("$.detail").value("You are not allowed to access this resource"))
                .andExpect(jsonPath("$.instance").value("/test/admin"));
    }
}
