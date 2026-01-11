package eu.epitech.t_dev_700.config.filters;

import eu.epitech.t_dev_700.services.JwtService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.web.servlet.HandlerExceptionResolver;

import java.io.IOException;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class JwtAuthenticationFilterTest {

    @Mock private HandlerExceptionResolver handlerExceptionResolver;
    @Mock private JwtService jwtService;
    @Mock private UserDetailsService userDetailsService;
    @Mock private FilterChain filterChain;

    private JwtAuthenticationFilter filter;

    @BeforeEach
    void setUp() {
        filter = new JwtAuthenticationFilter(handlerExceptionResolver, jwtService, userDetailsService);
        SecurityContextHolder.clearContext();
    }

    @AfterEach
    void tearDown() {
        SecurityContextHolder.clearContext();
    }

    private MockHttpServletRequest requestWithAuth(String value) {
        MockHttpServletRequest req = new MockHttpServletRequest();
        req.setMethod("GET");
        req.setRequestURI("/any");
        if (value != null) req.addHeader("Authorization", value);
        // optional: set remote addr so WebAuthenticationDetails has something
        req.setRemoteAddr("127.0.0.1");
        return req;
    }

    @Test
    void noAuthorizationHeader_shouldJustContinueChain() throws ServletException, IOException {
        MockHttpServletRequest req = requestWithAuth(null);
        MockHttpServletResponse res = new MockHttpServletResponse();

        filter.doFilter(req, res, filterChain);

        verify(filterChain).doFilter(req, res);
        verifyNoInteractions(jwtService, userDetailsService, handlerExceptionResolver);
        assertThat(SecurityContextHolder.getContext().getAuthentication()).isNull();
    }

    @Test
    void authorizationNotBearer_shouldJustContinueChain() throws ServletException, IOException {
        MockHttpServletRequest req = requestWithAuth("Basic abcdef");
        MockHttpServletResponse res = new MockHttpServletResponse();

        filter.doFilter(req, res, filterChain);

        verify(filterChain).doFilter(req, res);
        verifyNoInteractions(jwtService, userDetailsService, handlerExceptionResolver);
        assertThat(SecurityContextHolder.getContext().getAuthentication()).isNull();
    }

    @Test
    void bearerButExtractedUsernameNull_shouldContinueChain_withoutLoadingUser() throws ServletException, IOException {
        MockHttpServletRequest req = requestWithAuth("Bearer token123");
        MockHttpServletResponse res = new MockHttpServletResponse();

        when(jwtService.extractUsername("token123")).thenReturn(null);

        filter.doFilter(req, res, filterChain);

        verify(jwtService).extractUsername("token123");
        verify(filterChain).doFilter(req, res);
        verifyNoMoreInteractions(jwtService);
        verifyNoInteractions(userDetailsService, handlerExceptionResolver);
        assertThat(SecurityContextHolder.getContext().getAuthentication()).isNull();
    }

    @Test
    void bearerWithUsernameButAlreadyAuthenticated_shouldNotReauthenticate() throws ServletException, IOException {
        MockHttpServletRequest req = requestWithAuth("Bearer token123");
        MockHttpServletResponse res = new MockHttpServletResponse();

        Authentication existing = new UsernamePasswordAuthenticationToken("already", null, List.of());
        SecurityContextHolder.getContext().setAuthentication(existing);

        when(jwtService.extractUsername("token123")).thenReturn("sam");

        filter.doFilter(req, res, filterChain);

        verify(jwtService).extractUsername("token123");
        verify(filterChain).doFilter(req, res);

        // No user load / no validation because authentication != null
        verifyNoMoreInteractions(jwtService);
        verifyNoInteractions(userDetailsService, handlerExceptionResolver);

        assertThat(SecurityContextHolder.getContext().getAuthentication()).isSameAs(existing);
    }

    @Test
    void bearerWithUsername_tokenInvalid_shouldNotSetAuthentication_butContinueChain() throws ServletException, IOException {
        MockHttpServletRequest req = requestWithAuth("Bearer token123");
        MockHttpServletResponse res = new MockHttpServletResponse();

        when(jwtService.extractUsername("token123")).thenReturn("sam");

        UserDetails userDetails = User.withUsername("sam").password("x").authorities("ROLE_USER").build();
        when(userDetailsService.loadUserByUsername("sam")).thenReturn(userDetails);

        when(jwtService.isTokenValid("token123", userDetails)).thenReturn(false);

        filter.doFilter(req, res, filterChain);

        verify(jwtService).extractUsername("token123");
        verify(userDetailsService).loadUserByUsername("sam");
        verify(jwtService).isTokenValid("token123", userDetails);
        verify(filterChain).doFilter(req, res);
        verifyNoInteractions(handlerExceptionResolver);

        assertThat(SecurityContextHolder.getContext().getAuthentication()).isNull();
    }

    @Test
    void bearerWithUsername_tokenValid_shouldSetAuthentication_andContinueChain() throws ServletException, IOException {
        MockHttpServletRequest req = requestWithAuth("Bearer token123");
        MockHttpServletResponse res = new MockHttpServletResponse();

        when(jwtService.extractUsername("token123")).thenReturn("sam");

        UserDetails userDetails = User.withUsername("sam")
                .password("x")
                .authorities("ROLE_USER", "ROLE_MANAGER")
                .build();
        when(userDetailsService.loadUserByUsername("sam")).thenReturn(userDetails);

        when(jwtService.isTokenValid("token123", userDetails)).thenReturn(true);

        filter.doFilter(req, res, filterChain);

        verify(jwtService).extractUsername("token123");
        verify(userDetailsService).loadUserByUsername("sam");
        verify(jwtService).isTokenValid("token123", userDetails);
        verify(filterChain).doFilter(req, res);
        verifyNoInteractions(handlerExceptionResolver);

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        assertThat(auth).isInstanceOf(UsernamePasswordAuthenticationToken.class);

        UsernamePasswordAuthenticationToken token = (UsernamePasswordAuthenticationToken) auth;
        assertThat(token.getPrincipal()).isSameAs(userDetails);
        assertThat(token.getCredentials()).isNull();

        // Authorities preserved
        assertThat(token.getAuthorities())
                .extracting(GrantedAuthority::getAuthority)
                .containsExactlyInAnyOrder("ROLE_USER", "ROLE_MANAGER");

        // Details are set from WebAuthenticationDetailsSource
        assertThat(token.getDetails()).isNotNull();
    }

    @Test
    void bearerWithUsername_tokenValid_shouldNotOverrideExistingAuthentication() throws ServletException, IOException {
        MockHttpServletRequest req = requestWithAuth("Bearer token123");
        MockHttpServletResponse res = new MockHttpServletResponse();

        Authentication existing = new UsernamePasswordAuthenticationToken("existing", null, List.of());
        SecurityContextHolder.getContext().setAuthentication(existing);

        when(jwtService.extractUsername("token123")).thenReturn("sam");

        filter.doFilter(req, res, filterChain);

        verify(jwtService).extractUsername("token123");
        verify(filterChain).doFilter(req, res);
        verifyNoInteractions(userDetailsService, handlerExceptionResolver);
        verifyNoMoreInteractions(jwtService);

        assertThat(SecurityContextHolder.getContext().getAuthentication()).isSameAs(existing);
    }

    @Test
    void extractUsernameThrows_shouldDelegateToExceptionResolver_andNotContinueChain() throws ServletException, IOException {
        MockHttpServletRequest req = requestWithAuth("Bearer token123");
        MockHttpServletResponse res = new MockHttpServletResponse();

        RuntimeException boom = new RuntimeException("boom");
        when(jwtService.extractUsername("token123")).thenThrow(boom);

        filter.doFilter(req, res, filterChain);

        verify(jwtService).extractUsername("token123");
        verify(handlerExceptionResolver).resolveException(req, res, null, boom);
        verifyNoInteractions(userDetailsService);
        verifyNoMoreInteractions(jwtService);

        // Because exception happens inside try, chain should NOT be called
        verifyNoInteractions(filterChain);

        assertThat(SecurityContextHolder.getContext().getAuthentication()).isNull();
    }

    @Test
    void loadUserByUsernameThrows_shouldDelegateToExceptionResolver_andNotContinueChain() throws ServletException, IOException {
        MockHttpServletRequest req = requestWithAuth("Bearer token123");
        MockHttpServletResponse res = new MockHttpServletResponse();

        when(jwtService.extractUsername("token123")).thenReturn("sam");

        RuntimeException boom = new RuntimeException("user service down");
        when(userDetailsService.loadUserByUsername("sam")).thenThrow(boom);

        filter.doFilter(req, res, filterChain);

        verify(jwtService).extractUsername("token123");
        verify(userDetailsService).loadUserByUsername("sam");
        verify(handlerExceptionResolver).resolveException(req, res, null, boom);

        verifyNoInteractions(filterChain);
        assertThat(SecurityContextHolder.getContext().getAuthentication()).isNull();
    }

    @Test
    void isTokenValidThrows_shouldDelegateToExceptionResolver_andNotContinueChain() throws ServletException, IOException {
        MockHttpServletRequest req = requestWithAuth("Bearer token123");
        MockHttpServletResponse res = new MockHttpServletResponse();

        when(jwtService.extractUsername("token123")).thenReturn("sam");

        UserDetails userDetails = User.withUsername("sam").password("x").authorities("ROLE_USER").build();
        when(userDetailsService.loadUserByUsername("sam")).thenReturn(userDetails);

        RuntimeException boom = new RuntimeException("jwt library error");
        when(jwtService.isTokenValid("token123", userDetails)).thenThrow(boom);

        filter.doFilter(req, res, filterChain);

        verify(jwtService).extractUsername("token123");
        verify(userDetailsService).loadUserByUsername("sam");
        verify(jwtService).isTokenValid("token123", userDetails);
        verify(handlerExceptionResolver).resolveException(req, res, null, boom);

        verifyNoInteractions(filterChain);
        assertThat(SecurityContextHolder.getContext().getAuthentication()).isNull();
    }
}
