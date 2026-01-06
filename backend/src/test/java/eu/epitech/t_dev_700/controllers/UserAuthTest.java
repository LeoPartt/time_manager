package eu.epitech.t_dev_700.controllers;

import eu.epitech.t_dev_700.services.MembershipService;
import eu.epitech.t_dev_700.services.PlanningService;
import eu.epitech.t_dev_700.services.components.UserAuthorization;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.http.MediaType;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.web.SecurityFilterChain;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(UserController.class)
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
    void testAuth_getUsers_admin() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                get("/users"),
                status().isOk());
    }

    @Test
    void testAuth_getUsers_member() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users"),
                status().isForbidden());
    }

    @Test
    void testAuth_getUsers_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users"),
                status().isOk());
    }

    @Test
    void testAuth_getUser_admin() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                get("/users/1"),
                status().isOk());
    }

    @Test
    void testAuth_getUser_self_member() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users/1"),
                status().isOk());
    }

    @Test
    void testAuth_getUser_other_member() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users/3"),
                status().isForbidden());
    }

    @Test
    void testAuth_getUser_self_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/2"),
                status().isOk());
    }

    @Test
    void testAuth_getUser_managed_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/1"),
                status().isOk());
    }

    @Test
    void testAuth_getUser_other_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/3"),
                status().isOk());
    }

    @Test
    void testAuth_getMe_admin() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                get("/users/me"),
                status().isOk());
    }

    @Test
    void testAuth_getMe_member() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users/me"),
                status().isOk());
    }

    @Test
    void testAuth_getMe_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/me"),
                status().isOk());
    }

    @Test
    void testAuth_postUser_admin() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                post("/users").contentType(MediaType.APPLICATION_JSON).content(POST_REQUEST_BODY),
                status().isCreated());
    }

    @Test
    void testAuth_postUser_member() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                post("/users").contentType(MediaType.APPLICATION_JSON).content(POST_REQUEST_BODY),
                status().isForbidden());
    }

    @Test
    void testAuth_postUser_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                post("/users").contentType(MediaType.APPLICATION_JSON).content(POST_REQUEST_BODY),
                status().isCreated());
    }

    @Test
    void testAuth_putUser_admin() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                put("/users/1").contentType(MediaType.APPLICATION_JSON).content(PUT_REQUEST_BODY),
                status().isOk());
    }

    @Test
    void testAuth_putUser_self_member() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                put("/users/1").contentType(MediaType.APPLICATION_JSON).content(PUT_REQUEST_BODY),
                status().isOk());
    }

    @Test
    void testAuth_putUser_other_member() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                put("/users/3").contentType(MediaType.APPLICATION_JSON).content(PUT_REQUEST_BODY),
                status().isForbidden());
    }

    @Test
    void testAuth_putUser_self_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                put("/users/2").contentType(MediaType.APPLICATION_JSON).content(PUT_REQUEST_BODY),
                status().isOk());
    }

    @Test
    void testAuth_putUser_managed_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                put("/users/1").contentType(MediaType.APPLICATION_JSON).content(PUT_REQUEST_BODY),
                status().isOk());
    }

    @Test
    void testAuth_putUser_other_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                put("/users/3").contentType(MediaType.APPLICATION_JSON).content(PUT_REQUEST_BODY),
                status().isForbidden());
    }

    @Test
    void testAuth_patchUser_admin() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                patch("/users/1").contentType(MediaType.APPLICATION_JSON).content("{\"firstName\": \"John\"}"),
                status().isOk());
    }

    @Test
    void testAuth_patchUser_self_member() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                patch("/users/1").contentType(MediaType.APPLICATION_JSON).content("{\"firstName\": \"John\"}"),
                status().isOk());
    }

    @Test
    void testAuth_patchUser_other_member() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                patch("/users/3").contentType(MediaType.APPLICATION_JSON).content("{\"firstName\": \"John\"}"),
                status().isForbidden());
    }

    @Test
    void testAuth_patchUser_self_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                patch("/users/2").contentType(MediaType.APPLICATION_JSON).content("{\"firstName\": \"John\"}"),
                status().isOk());
    }

    @Test
    void testAuth_patchUser_managed_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                patch("/users/1").contentType(MediaType.APPLICATION_JSON).content("{\"firstName\": \"John\"}"),
                status().isOk());
    }

    @Test
    void testAuth_patchUser_other_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                patch("/users/3").contentType(MediaType.APPLICATION_JSON).content("{\"firstName\": \"John\"}"),
                status().isForbidden());
    }

    @Test
    void testAuth_deleteUser_admin() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                delete("/users/1"),
                status().isNoContent());
    }

    @Test
    void testAuth_deleteUser_self_member() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                delete("/users/1"),
                status().isNoContent());
    }

    @Test
    void testAuth_deleteUser_other_member() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                delete("/users/3"),
                status().isForbidden());
    }

    @Test
    void testAuth_deleteUser_self_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                delete("/users/2"),
                status().isNoContent());
    }

    @Test
    void testAuth_deleteUser_managed_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                delete("/users/1"),
                status().isNoContent());
    }

    @Test
    void testAuth_deleteUser_other_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                delete("/users/3"),
                status().isForbidden());
    }

    @Test
    void testAuth_getClocks_admin() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                get("/users/1/clocks"),
                status().isOk());
    }

    @Test
    void testAuth_getClocks_self_member() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users/1/clocks"),
                status().isOk());
    }

    @Test
    void testAuth_getClocks_other_member() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users/3/clocks"),
                status().isForbidden());
    }

    @Test
    void testAuth_getClocks_self_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/2/clocks"),
                status().isOk());
    }

    @Test
    void testAuth_getClocks_managed_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/1/clocks"),
                status().isOk());
    }

    @Test
    void testAuth_getClocks_other_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/3/clocks"),
                status().isForbidden());
    }

    @Test
    void testAuth_getTeams_admin() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                get("/users/1/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getTeams_self_member() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users/1/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getTeams_other_member() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users/3/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getTeams_self_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/2/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getTeams_managed_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/1/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getTeams_other_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/3/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getPlannings_admin() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                get("/users/1/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getPlannings_self_member() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users/1/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getPlannings_other_member() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/users/3/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getPlannings_self_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/2/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getPlannings_managed_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/1/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getPlannings_other_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/users/3/teams"),
                status().isOk());
    }

    @Test
    void testAuth_postPlannings_admin() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                post("/users/1/plannings").contentType(MediaType.APPLICATION_JSON).content(POST_PLANNING_REQUEST_BODY),
                status().isCreated());
    }

    @Test
    void testAuth_postPlannings_self_member() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                post("/users/1/plannings").contentType(MediaType.APPLICATION_JSON).content(POST_PLANNING_REQUEST_BODY),
                status().isForbidden());
    }

    @Test
    void testAuth_postPlannings_other_member() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                post("/users/3/plannings").contentType(MediaType.APPLICATION_JSON).content(POST_PLANNING_REQUEST_BODY),
                status().isForbidden());
    }

    @Test
    void testAuth_postPlannings_self_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                post("/users/2/plannings").contentType(MediaType.APPLICATION_JSON).content(POST_PLANNING_REQUEST_BODY),
                status().isCreated());
    }

    @Test
    void testAuth_postPlannings_managed_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                post("/users/1/plannings").contentType(MediaType.APPLICATION_JSON).content(POST_PLANNING_REQUEST_BODY),
                status().isCreated());
    }

    @Test
    void testAuth_postPlannings_other_manager() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                post("/users/3/plannings").contentType(MediaType.APPLICATION_JSON).content(POST_PLANNING_REQUEST_BODY),
                status().isForbidden());
    }

}
