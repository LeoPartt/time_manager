package eu.epitech.t_dev_700.controllers;

import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.services.*;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultMatcher;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.RequestPostProcessor;

import java.util.ArrayList;
import java.util.List;

import static org.mockito.Mockito.when;

@ActiveProfiles("test")
abstract class AbstractAuthTest {

    @Autowired
    MockMvc mvc;

    @MockitoBean
    MembershipService membershipService;

    @MockitoBean
    PlanningService planningService;

    @MockitoBean
    UserService userService;

    @MockitoBean
    ClockService ClockService;

    @MockitoBean
    TeamService teamService;

    @MockitoBean
    ReportsService reportsService;

    protected UserEntity memberUser;
    protected UserEntity managerUser;
    protected UserEntity otherUser;


    @BeforeEach
    void setUp() {
        memberUser = new UserEntity();
        memberUser.setId(1L);
        memberUser.setAccount(new AccountEntity());

        managerUser = new UserEntity();
        managerUser.setId(2L);
        managerUser.setAccount(new AccountEntity());

        otherUser = new UserEntity();
        otherUser.setId(3L);
        otherUser.setAccount(new AccountEntity());

        when(membershipService.isUserManager(memberUser)).thenReturn(false);
        when(membershipService.isUserMemberOfTeam(memberUser, 1L)).thenReturn(true);
        when(membershipService.isUserMemberOfTeam(memberUser, 2L)).thenReturn(false);
        when(membershipService.isUserManagerOfTeam(memberUser, 1L)).thenReturn(false);
        when(membershipService.isUserManagerOfTeam(memberUser, 2L)).thenReturn(false);
        when(membershipService.isUserManagerOfOther(memberUser, 1L)).thenReturn(false);
        when(membershipService.isUserManagerOfOther(memberUser, 2L)).thenReturn(false);
        when(membershipService.isUserManagerOfOther(memberUser, 3L)).thenReturn(false);

        when(membershipService.isUserManager(managerUser)).thenReturn(true);
        when(membershipService.isUserMemberOfTeam(managerUser, 1L)).thenReturn(true);
        when(membershipService.isUserMemberOfTeam(managerUser, 2L)).thenReturn(false);
        when(membershipService.isUserManagerOfTeam(managerUser, 1L)).thenReturn(true);
        when(membershipService.isUserManagerOfTeam(managerUser, 2L)).thenReturn(false);
        when(membershipService.isUserManagerOfOther(managerUser, 1L)).thenReturn(true);
        when(membershipService.isUserManagerOfOther(managerUser, 2L)).thenReturn(true);
        when(membershipService.isUserManagerOfOther(managerUser, 3L)).thenReturn(false);

        when(planningService.isOwner(memberUser, 1L)).thenReturn(true);
        when(planningService.isOwner(memberUser, 2L)).thenReturn(false);
        when(planningService.isManagerOfOwner(memberUser, 1L)).thenReturn(false);
        when(planningService.isManagerOfOwner(memberUser, 2L)).thenReturn(false);

        when(planningService.isOwner(managerUser, 1L)).thenReturn(false);
        when(planningService.isOwner(managerUser, 2L)).thenReturn(false);
        when(planningService.isManagerOfOwner(managerUser, 1L)).thenReturn(true);
        when(planningService.isManagerOfOwner(managerUser, 2L)).thenReturn(false);

        when(planningService.isOwner(otherUser, 1L)).thenReturn(false);
        when(planningService.isOwner(otherUser, 2L)).thenReturn(true);
        when(planningService.isManagerOfOwner(otherUser, 1L)).thenReturn(false);
        when(planningService.isManagerOfOwner(otherUser, 2L)).thenReturn(false);
    }

    // -------- helpers to build Authentication like at runtime --------

    protected void doTestRequestForAuthExpectCode(
            Authentication auth,
            MockHttpServletRequestBuilder request,
            ResultMatcher expected
    ) throws Exception {
        mvc.perform(request.with(authentication(auth)))
                .andExpect(expected);
    }

    protected RequestPostProcessor authentication(Authentication a) {
        return SecurityMockMvcRequestPostProcessors.authentication(a);
    }

    protected Authentication authForAdmin() {
        return token(principal(true), new ArrayList<>());
    }

    protected Authentication authForUser() {
        return token(principal(memberUser), new ArrayList<>());
    }

    protected Authentication authForManager() {
        return token(principal(managerUser), new ArrayList<>());
    }

    protected UsernamePasswordAuthenticationToken token(Object principal, List<GrantedAuthority> auths) {
        return new UsernamePasswordAuthenticationToken(principal, "N/A", auths);
    }

    protected AccountEntity principal(boolean admin) {
        AccountEntity account = new AccountEntity();
        if (admin) account.setFlags((byte) 0xFF);
        return account;
    }

    protected AccountEntity principal(UserEntity user) {
        AccountEntity account = new AccountEntity();
        account.setUser(user);
        return account;
    }

}
