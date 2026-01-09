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

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(
        controllers = UserController.class,
        excludeFilters = @ComponentScan.Filter(
                type = FilterType.ASSIGNABLE_TYPE,
                classes = JwtAuthenticationFilter.class
        )
)
public class UserAuthTest extends AbstractAuthTest {

    static String POST_REQUEST_BODY = """
            {
                "username": "johndoe",
                "password": "password123",
                "firstName": "John",
                "lastName": "Doe",
                "email": "john.doe@example.com",
                "phoneNumber": "+1234567890"
            }
            """;

    static String PUT_REQUEST_BODY = """
            {
                "username": "johndoe",
                "firstName": "John",
                "lastName": "Doe",
                "email": "john.doe@example.com",
                "phoneNumber": "+1234567890"
            }
            """;

    static String POST_PLANNING_REQUEST_BODY = """
            {
                "weekDay": 1,
                "startTime": "08:00",
                "endTime": "09:00"
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
    void testAuth_getUsers_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                get("/users"),
                status().isOk());
    }

    @Test
    void testAuth_getUsers_member_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users"),
                status().isForbidden());
    }

    @Test
    void testAuth_getUsers_manager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users"),
                status().isOk());
    }

    @Test
    void testAuth_getUser_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                get("/users/1"),
                status().isOk());
    }

    @Test
    void testAuth_getUser_selfMember_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users/1"),
                status().isOk());
    }

    @Test
    void testAuth_getUser_otherMember_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users/3"),
                status().isForbidden());
    }

    @Test
    void testAuth_getUser_selfManager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/2"),
                status().isOk());
    }

    @Test
    void testAuth_getUser_managerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/1"),
                status().isOk());
    }

    @Test
    void testAuth_getUser_otherManager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/3"),
                status().isOk());
    }

    @Test
    void testAuth_getMe_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                get("/users/me"),
                status().isOk());
    }

    @Test
    void testAuth_getMe_member_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users/me"),
                status().isOk());
    }

    @Test
    void testAuth_getMe_manager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/me"),
                status().isOk());
    }

    @Test
    void testAuth_postUser_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                post("/users").contentType(MediaType.APPLICATION_JSON).content(POST_REQUEST_BODY),
                status().isCreated());
    }

    @Test
    void testAuth_postUser_member_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                post("/users").contentType(MediaType.APPLICATION_JSON).content(POST_REQUEST_BODY),
                status().isForbidden());
    }

    @Test
    void testAuth_postUser_manager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                post("/users").contentType(MediaType.APPLICATION_JSON).content(POST_REQUEST_BODY),
                status().isCreated());
    }

    @Test
    void testAuth_putUser_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                put("/users/1").contentType(MediaType.APPLICATION_JSON).content(PUT_REQUEST_BODY),
                status().isOk());
    }

    @Test
    void testAuth_putUser_selfMember_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                put("/users/1").contentType(MediaType.APPLICATION_JSON).content(PUT_REQUEST_BODY),
                status().isOk());
    }

    @Test
    void testAuth_putUser_otherMember_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                put("/users/3").contentType(MediaType.APPLICATION_JSON).content(PUT_REQUEST_BODY),
                status().isForbidden());
    }

    @Test
    void testAuth_putUser_selfManager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                put("/users/2").contentType(MediaType.APPLICATION_JSON).content(PUT_REQUEST_BODY),
                status().isOk());
    }

    @Test
    void testAuth_putUser_managerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                put("/users/1").contentType(MediaType.APPLICATION_JSON).content(PUT_REQUEST_BODY),
                status().isOk());
    }

    @Test
    void testAuth_putUser_otherManager_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                put("/users/3").contentType(MediaType.APPLICATION_JSON).content(PUT_REQUEST_BODY),
                status().isForbidden());
    }

    @Test
    void testAuth_patchUser_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                patch("/users/1").contentType(MediaType.APPLICATION_JSON).content("{\"firstName\": \"John\"}"),
                status().isOk());
    }

    @Test
    void testAuth_patchUser_selfMember_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                patch("/users/1").contentType(MediaType.APPLICATION_JSON).content("{\"firstName\": \"John\"}"),
                status().isOk());
    }

    @Test
    void testAuth_patchUser_otherMember_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                patch("/users/3").contentType(MediaType.APPLICATION_JSON).content("{\"firstName\": \"John\"}"),
                status().isForbidden());
    }

    @Test
    void testAuth_patchUser_selfManager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                patch("/users/2").contentType(MediaType.APPLICATION_JSON).content("{\"firstName\": \"John\"}"),
                status().isOk());
    }

    @Test
    void testAuth_patchUser_managerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                patch("/users/1").contentType(MediaType.APPLICATION_JSON).content("{\"firstName\": \"John\"}"),
                status().isOk());
    }

    @Test
    void testAuth_patchUser_otherManager_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                patch("/users/3").contentType(MediaType.APPLICATION_JSON).content("{\"firstName\": \"John\"}"),
                status().isForbidden());
    }

    @Test
    void testAuth_deleteUser_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                delete("/users/1"),
                status().isNoContent());
    }

    @Test
    void testAuth_deleteUser_selfMember_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                delete("/users/1"),
                status().isNoContent());
    }

    @Test
    void testAuth_deleteUser_otherMember_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                delete("/users/3"),
                status().isForbidden());
    }

    @Test
    void testAuth_deleteUser_selfManager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                delete("/users/2"),
                status().isNoContent());
    }

    @Test
    void testAuth_deleteUser_managerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                delete("/users/1"),
                status().isNoContent());
    }

    @Test
    void testAuth_deleteUser_otherManager_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                delete("/users/3"),
                status().isForbidden());
    }

    @Test
    void testAuth_getClocks_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                get("/users/1/clocks"),
                status().isOk());
    }

    @Test
    void testAuth_getClocks_selfMember_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users/1/clocks"),
                status().isOk());
    }

    @Test
    void testAuth_getClocks_otherMember_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users/3/clocks"),
                status().isForbidden());
    }

    @Test
    void testAuth_getClocks_selfManager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/2/clocks"),
                status().isOk());
    }

    @Test
    void testAuth_getClocks_managerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/1/clocks"),
                status().isOk());
    }

    @Test
    void testAuth_getClocks_otherManager_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/3/clocks"),
                status().isForbidden());
    }

    @Test
    void testAuth_getTeams_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                get("/users/1/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getTeams_selfMember_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users/1/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getTeams_otherMember_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users/3/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getTeams_selfManager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/2/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getTeams_managerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/1/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getTeams_otherManager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/3/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getPlannings_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                get("/users/1/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getPlannings_selfMember_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users/1/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getPlannings_otherMember_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users/3/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getPlannings_selfManager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/2/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getPlannings_managerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/1/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getPlannings_otherManager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/3/teams"),
                status().isOk());
    }

    @Test
    void testAuth_postPlannings_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                post("/users/1/plannings").contentType(MediaType.APPLICATION_JSON).content(POST_PLANNING_REQUEST_BODY),
                status().isCreated());
    }

    @Test
    void testAuth_postPlannings_selfMember_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                post("/users/1/plannings").contentType(MediaType.APPLICATION_JSON).content(POST_PLANNING_REQUEST_BODY),
                status().isForbidden());
    }

    @Test
    void testAuth_postPlannings_otherMember_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                post("/users/3/plannings").contentType(MediaType.APPLICATION_JSON).content(POST_PLANNING_REQUEST_BODY),
                status().isForbidden());
    }

    @Test
    void testAuth_postPlannings_selfManager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                post("/users/2/plannings").contentType(MediaType.APPLICATION_JSON).content(POST_PLANNING_REQUEST_BODY),
                status().isCreated());
    }

    @Test
    void testAuth_postPlannings_managerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                post("/users/1/plannings").contentType(MediaType.APPLICATION_JSON).content(POST_PLANNING_REQUEST_BODY),
                status().isCreated());
    }

    @Test
    void testAuth_postPlannings_otherManager_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                post("/users/3/plannings").contentType(MediaType.APPLICATION_JSON).content(POST_PLANNING_REQUEST_BODY),
                status().isForbidden());
    }

}
