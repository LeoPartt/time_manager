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
        controllers = TeamController.class,
        excludeFilters = @ComponentScan.Filter(
                type = FilterType.ASSIGNABLE_TYPE,
                classes = JwtAuthenticationFilter.class
        )
)
public class TeamAuthTest extends AbstractAuthTest {

    static String POST_REQUEST_BODY = """
            {
                "name": "Frontend",
                "description": "Web front development team"
            }
            """;

    static String PUT_REQUEST_BODY = """
            {
                "name": "Frontend",
                "description": "Web front development team"
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
    void testAuth_getTeams_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                get("/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getTeams_member_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getTeams_manager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/teams"),
                status().isOk());
    }

    @Test
    void testAuth_getTeam_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                get("/teams/1"),
                status().isOk());
    }

    @Test
    void testAuth_getTeam_MemberOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/teams/1"),
                status().isOk());
    }

    @Test
    void testAuth_getTeam_otherMember_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/teams/2"),
                status().isOk());
    }

    @Test
    void testAuth_getTeam_managerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/teams/1"),
                status().isOk());
    }

    @Test
    void testAuth_getTeam_otherManager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/teams/2"),
                status().isOk());
    }

    @Test
    void testAuth_postTeam_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                post("/teams").contentType(MediaType.APPLICATION_JSON).content(POST_REQUEST_BODY),
                status().isCreated());
    }

    @Test
    void testAuth_postTeam_member_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                post("/teams").contentType(MediaType.APPLICATION_JSON).content(POST_REQUEST_BODY),
                status().isForbidden());
    }

    @Test
    void testAuth_postTeam_manager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                post("/teams").contentType(MediaType.APPLICATION_JSON).content(POST_REQUEST_BODY),
                status().isCreated());
    }

    @Test
    void testAuth_putTeam_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                put("/teams/1").contentType(MediaType.APPLICATION_JSON).content(PUT_REQUEST_BODY),
                status().isOk());
    }

    @Test
    void testAuth_putTeam_MemberOf_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                put("/teams/1").contentType(MediaType.APPLICATION_JSON).content(PUT_REQUEST_BODY),
                status().isForbidden());
    }

    @Test
    void testAuth_putTeam_otherMember_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                put("/teams/2").contentType(MediaType.APPLICATION_JSON).content(PUT_REQUEST_BODY),
                status().isForbidden());
    }

    @Test
    void testAuth_putTeam_managerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                put("/teams/1").contentType(MediaType.APPLICATION_JSON).content(PUT_REQUEST_BODY),
                status().isOk());
    }

    @Test
    void testAuth_putTeam_otherManager_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                put("/teams/2").contentType(MediaType.APPLICATION_JSON).content(PUT_REQUEST_BODY),
                status().isForbidden());
    }

    @Test
    void testAuth_patchTeam_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                patch("/teams/1").contentType(MediaType.APPLICATION_JSON).content("{\"firstName\": \"John\"}"),
                status().isOk());
    }

    @Test
    void testAuth_patchTeam_MemberOf_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                patch("/teams/1").contentType(MediaType.APPLICATION_JSON).content("{\"firstName\": \"John\"}"),
                status().isForbidden());
    }

    @Test
    void testAuth_patchTeam_otherMember_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                patch("/teams/2").contentType(MediaType.APPLICATION_JSON).content("{\"firstName\": \"John\"}"),
                status().isForbidden());
    }

    @Test
    void testAuth_patchTeam_managerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                patch("/teams/1").contentType(MediaType.APPLICATION_JSON).content("{\"firstName\": \"John\"}"),
                status().isOk());
    }

    @Test
    void testAuth_patchTeam_otherManager_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                patch("/teams/2").contentType(MediaType.APPLICATION_JSON).content("{\"firstName\": \"John\"}"),
                status().isForbidden());
    }

    @Test
    void testAuth_deleteTeam_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                delete("/teams/1"),
                status().isNoContent());
    }

    @Test
    void testAuth_deleteTeam_MemberOf_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                delete("/teams/1"),
                status().isForbidden());
    }

    @Test
    void testAuth_deleteTeam_otherMember_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                delete("/teams/2"),
                status().isForbidden());
    }

    @Test
    void testAuth_deleteTeam_managerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                delete("/teams/1"),
                status().isNoContent());
    }

    @Test
    void testAuth_deleteTeam_otherManager_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                delete("/teams/2"),
                status().isForbidden());
    }

    @Test
    void testAuth_getMembers_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                get("/teams/1/members"),
                status().isOk());
    }

    @Test
    void testAuth_getMembers_memberOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/teams/1/members"),
                status().isOk());
    }

    @Test
    void testAuth_getMembers_otherMember_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/teams/2/members"),
                status().isOk());
    }

    @Test
    void testAuth_getMembers_ManagerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/teams/1/members"),
                status().isOk());
    }

    @Test
    void testAuth_getMembers_otherManager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/teams/2/members"),
                status().isOk());
    }

    @Test
    void testAuth_postMember_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                post("/teams/1/members/3"),
                status().isNoContent());
    }

    @Test
    void testAuth_postMember_MemberOf_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                post("/teams/1/members/3"),
                status().isForbidden());
    }

    @Test
    void testAuth_postMember_otherMember_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                post("/teams/2/members/3"),
                status().isForbidden());
    }

    @Test
    void testAuth_postMember_ManagerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                post("/teams/1/members/3"),
                status().isNoContent());
    }

    @Test
    void testAuth_postMember_otherManager_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                post("/teams/2/members/3"),
                status().isForbidden());
    }

    @Test
    void testAuth_deleteMember_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                delete("/teams/1/members/3"),
                status().isNoContent());
    }

    @Test
    void testAuth_deleteMember_MemberOf_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                delete("/teams/1/members/3"),
                status().isForbidden());
    }

    @Test
    void testAuth_deleteMember_otherMember_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                delete("/teams/2/members/3"),
                status().isForbidden());
    }

    @Test
    void testAuth_deleteMember_ManagerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                delete("/teams/1/members/3"),
                status().isNoContent());
    }

    @Test
    void testAuth_deleteMember_otherManager_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                delete("/teams/2/members/3"),
                status().isForbidden());
    }


    @Test
    void testAuth_getManager_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                get("/teams/1/manager"),
                status().isOk());
    }

    @Test
    void testAuth_getManager_memberOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/teams/1/manager"),
                status().isOk());
    }

    @Test
    void testAuth_getManager_otherMember_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                get("/teams/2/manager"),
                status().isOk());
    }

    @Test
    void testAuth_getManager_managerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/teams/1/manager"),
                status().isOk());
    }

    @Test
    void testAuth_getManager_otherManager_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                get("/teams/2/manager"),
                status().isOk());
    }

    @Test
    void testAuth_patchManager_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                patch("/teams/1/manager/3"),
                status().isOk());
    }

    @Test
    void testAuth_patchManager_memberOf_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                patch("/teams/1/manager/3"),
                status().isForbidden());
    }

    @Test
    void testAuth_patchManager_otherMember_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                patch("/teams/2/manager/3"),
                status().isForbidden());
    }

    @Test
    void testAuth_patchManager_managerOf_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                patch("/teams/1/manager/3"),
                status().isOk());
    }

    @Test
    void testAuth_patchManager_otherManager_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                patch("/teams/2/manager/3"),
                status().isForbidden());
    }

    @Test
    void testAuth_deleteManager_admin_shouldReturnOk() throws Exception {
        doTestRequestForAuthExpectCode(
                authForAdmin(),
                delete("/teams/1/manager"),
                status().isNoContent());
    }

    @Test
    void testAuth_deleteManager_memberOf_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                delete("/teams/1/manager"),
                status().isForbidden());
    }

    @Test
    void testAuth_deleteManager_otherMember_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForUser(),
                delete("/teams/2/manager"),
                status().isForbidden());
    }

    @Test
    void testAuth_deleteManager_managerOf_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                delete("/teams/1/manager"),
                status().isForbidden());
    }

    @Test
    void testAuth_deleteManager_otherManager_shouldReturnForbidden() throws Exception {
        doTestRequestForAuthExpectCode(
                authForManager(),
                delete("/teams/2/manager"),
                status().isForbidden());
    }
}
