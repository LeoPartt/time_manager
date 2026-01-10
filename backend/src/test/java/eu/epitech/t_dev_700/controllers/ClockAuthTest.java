package eu.epitech.t_dev_700.controllers;

import eu.epitech.t_dev_700.config.filters.JwtAuthenticationFilter;
import eu.epitech.t_dev_700.services.MembershipService;
import eu.epitech.t_dev_700.services.PlanningService;
import eu.epitech.t_dev_700.services.components.UserAuthorization;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.FilterType;
import org.springframework.http.MediaType;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.web.SecurityFilterChain;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(
        controllers = ClockController.class,
        excludeFilters = @ComponentScan.Filter(
                type = FilterType.ASSIGNABLE_TYPE,
                classes = JwtAuthenticationFilter.class
        )
)
public class ClockAuthTest extends AbstractAuthTest {

    static String POST_REQUEST_BODY = """
            {
                "io": "IN",
                "timestamp": "2024-01-15T10:30:00Z"
            }
            """;

    @TestConfiguration
    @EnableMethodSecurity(proxyTargetClass = true)
    public static class MethodSecurityTestConfig {
        @Bean
        UserAuthorization userAuth(MembershipService membershipService, PlanningService planningService) {
            return new UserAuthorization(membershipService, planningService);
        }

        @Bean
        SecurityFilterChain testSecurity(HttpSecurity http) throws Exception {
            http
                    .csrf(AbstractHttpConfigurer::disable)
                    .authorizeHttpRequests(auth -> auth.anyRequest().permitAll());
            return http.build();
        }
    }

    @Test
    void testAuth_postClock_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                post("/clocks").contentType(MediaType.APPLICATION_JSON).content(POST_REQUEST_BODY),
                status().isNoContent());
    }

    @Test
    void testAuth_postClock_selfMember_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                post("/clocks").contentType(MediaType.APPLICATION_JSON).content(POST_REQUEST_BODY),
                status().isNoContent());
    }

    @Test
    void testAuth_postClock_selfManager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                post("/clocks").contentType(MediaType.APPLICATION_JSON).content(POST_REQUEST_BODY),
                status().isNoContent());
    }

    @Test
    void testAuth_postClockFor_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                post("/clocks/1").contentType(MediaType.APPLICATION_JSON).content(POST_REQUEST_BODY),
                status().isNoContent());
    }

    @Test
    void testAuth_postClockFor_selfMember_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                post("/clocks/1").contentType(MediaType.APPLICATION_JSON).content(POST_REQUEST_BODY),
                status().isNoContent());
    }

    @Test
    void testAuth_postClockFor_otherUser_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                post("/clocks/3").contentType(MediaType.APPLICATION_JSON).content(POST_REQUEST_BODY),
                status().isForbidden());
    }

    @Test
    void testAuth_postClockFor_selfManager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                post("/clocks/2").contentType(MediaType.APPLICATION_JSON).content(POST_REQUEST_BODY),
                status().isNoContent());
    }

    @Test
    void testAuth_postClockFor_managerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                post("/clocks/2").contentType(MediaType.APPLICATION_JSON).content(POST_REQUEST_BODY),
                status().isNoContent());
    }

    @Test
    void testAuth_postClockFor_otherManager_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                post("/clocks/3").contentType(MediaType.APPLICATION_JSON).content(POST_REQUEST_BODY),
                status().isForbidden());
    }

}
