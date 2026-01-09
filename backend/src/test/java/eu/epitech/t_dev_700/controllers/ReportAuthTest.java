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

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(
        controllers = ReportController.class,
        excludeFilters = @ComponentScan.Filter(
                type = FilterType.ASSIGNABLE_TYPE,
                classes = JwtAuthenticationFilter.class
        )
)
public class ReportAuthTest extends AbstractAuthTest {

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
    void testAuth_getReportGlobal_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                get("/reports/dashboard?mode=M").contentType(MediaType.APPLICATION_JSON),
                status().isOk());
    }

    @Test
    void testAuth_getReportGlobal_member_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/reports/dashboard?mode=M").contentType(MediaType.APPLICATION_JSON),
                status().isForbidden());
    }

    @Test
    void testAuth_getReportGlobal_manager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/reports/dashboard?mode=M").contentType(MediaType.APPLICATION_JSON),
                status().isOk());
    }

    @Test
    void testAuth_getReportTeam_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                get("/reports/teams/1/dashboard?mode=M").contentType(MediaType.APPLICATION_JSON),
                status().isOk());
    }

    @Test
    void testAuth_getReportTeam_MemberOf_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/reports/teams/1/dashboard?mode=M").contentType(MediaType.APPLICATION_JSON),
                status().isForbidden());
    }

    @Test
    void testAuth_getReportTeam_otherMember_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/reports/teams/3/dashboard?mode=M").contentType(MediaType.APPLICATION_JSON),
                status().isForbidden());
    }

    @Test
    void testAuth_getReportTeam_managerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/reports/teams/1/dashboard?mode=M").contentType(MediaType.APPLICATION_JSON),
                status().isOk());
    }

    @Test
    void testAuth_getReportTeam_otherManager_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/reports/teams/2/dashboard?mode=M").contentType(MediaType.APPLICATION_JSON),
                status().isForbidden());
    }

    @Test
    void testAuth_getReportUser_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                get("/reports/users/1/dashboard?mode=M").contentType(MediaType.APPLICATION_JSON),
                status().isOk());
    }

    @Test
    void testAuth_getReportUser_selfMember_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/reports/users/1/dashboard?mode=M").contentType(MediaType.APPLICATION_JSON),
                status().isOk());
    }

    @Test
    void testAuth_getReportUser_otherMember_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/reports/users/2/dashboard?mode=M").contentType(MediaType.APPLICATION_JSON),
                status().isForbidden());
    }

    @Test
    void testAuth_getReportUser_selfManager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/reports/users/2/dashboard?mode=M").contentType(MediaType.APPLICATION_JSON),
                status().isOk());
    }

    @Test
    void testAuth_getReportUser_managerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/reports/users/1/dashboard?mode=M").contentType(MediaType.APPLICATION_JSON),
                status().isOk());
    }

    @Test
    void testAuth_getReportUser_otherManager_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/reports/users/3/dashboard?mode=M").contentType(MediaType.APPLICATION_JSON),
                status().isForbidden());
    }
}
