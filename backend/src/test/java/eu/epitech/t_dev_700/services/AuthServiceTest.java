package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.models.AuthModels;
import eu.epitech.t_dev_700.services.components.UserAuthorization;
import eu.epitech.t_dev_700.services.exceptions.InvalidCredentials;
import eu.epitech.t_dev_700.services.exceptions.UnknownUser;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock private AuthenticationManager authenticationManager;
    @Mock private JwtService jwtService;
    @Mock private PasswordResetService passwordResetService;
    @Mock private UserAuthorization userAuthorization;

    @Test
    void authenticate_success_returnsJwtToken() {
        AuthService authService = new AuthService(authenticationManager, jwtService, passwordResetService, userAuthorization);
        AuthModels.LoginRequest input = new AuthModels.LoginRequest("sam", "secret");

        Authentication authentication = mock(Authentication.class);
        AccountEntity account = mock(AccountEntity.class);

        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class)))
                .thenReturn(authentication);
        when(authentication.getPrincipal()).thenReturn(account);

        when(account.getUser()).thenReturn(mock(UserEntity.class)); // non-null => ok
        when(jwtService.generateToken(account)).thenReturn("jwt-token");

        String token = authService.authenticate(input);

        assertEquals("jwt-token", token);
        verify(jwtService).generateToken(account);
    }

    @Test
    void authenticate_badCredentials_throwsInvalidCredentials_invalidPassword() {
        // Arrange
        AuthService authService = new AuthService(authenticationManager, jwtService, passwordResetService, userAuthorization);
        AuthModels.LoginRequest input = new AuthModels.LoginRequest("sam", "wrong");

        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class)))
                .thenThrow(new BadCredentialsException("bad creds"));

        // Act + Assert
        InvalidCredentials ex = assertThrows(InvalidCredentials.class, () -> authService.authenticate(input));
        assertEquals("Invalid password", ex.getMessage());

        verify(authenticationManager).authenticate(any(UsernamePasswordAuthenticationToken.class));
        verifyNoInteractions(jwtService, passwordResetService);
    }

    @Test
    void authenticate_usernameNotFound_throwsInvalidCredentials_invalidUsername() {
        // Arrange
        AuthService authService = new AuthService(authenticationManager, jwtService, passwordResetService, userAuthorization);
        AuthModels.LoginRequest input = new AuthModels.LoginRequest("unknown", "secret");

        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class)))
                .thenThrow(new UsernameNotFoundException("not found"));

        // Act + Assert
        InvalidCredentials ex = assertThrows(InvalidCredentials.class, () -> authService.authenticate(input));
        assertEquals("Invalid username", ex.getMessage());

        verify(authenticationManager).authenticate(any(UsernamePasswordAuthenticationToken.class));
        verifyNoInteractions(jwtService, passwordResetService);
    }

    @Test
    void authenticate_accountHasNoUserAndNotAdmin_throwsUnknownUser() {
        // Arrange
        AuthService authService = new AuthService(authenticationManager, jwtService, passwordResetService, userAuthorization);
        AuthModels.LoginRequest input = new AuthModels.LoginRequest("sam", "secret");

        Authentication authentication = mock(Authentication.class);
        AccountEntity account = mock(AccountEntity.class);

        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class)))
                .thenReturn(authentication);
        when(authentication.getPrincipal()).thenReturn(account);

        when(account.getUser()).thenReturn(null);
        when(account.isAdmin()).thenReturn(false);
        when(account.getUsername()).thenReturn("sam");

        // Act + Assert
        assertThrows(UnknownUser.class, () -> authService.authenticate(input));

        verify(authenticationManager).authenticate(any(UsernamePasswordAuthenticationToken.class));
        verifyNoInteractions(jwtService, passwordResetService);
    }

    @Test
    void resetPassword_delegatesToPasswordResetServiceWithCurrentUser() {
        AuthService authService = new AuthService(authenticationManager, jwtService, passwordResetService, userAuthorization);

        UserEntity currentUser = mock(UserEntity.class);
        when(userAuthorization.getCurrentUser()).thenReturn(currentUser);

        authService.resetPassword();

        verify(userAuthorization).getCurrentUser();
        verify(passwordResetService).createResetToken(currentUser);
        verifyNoInteractions(authenticationManager, jwtService);
    }

    @Test
    void authenticate_adminWithoutUser_doesNotThrow_andReturnsJwtToken() {
        AuthService authService = new AuthService(authenticationManager, jwtService, passwordResetService, userAuthorization);
        AuthModels.LoginRequest input = new AuthModels.LoginRequest("admin", "secret");

        Authentication authentication = mock(Authentication.class);
        AccountEntity account = mock(AccountEntity.class);

        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class)))
                .thenReturn(authentication);
        when(authentication.getPrincipal()).thenReturn(account);

        when(account.getUser()).thenReturn(null);     // user missing
        when(account.isAdmin()).thenReturn(true);     // admin => condition becomes false
        when(jwtService.generateToken(account)).thenReturn("jwt-admin");

        String token = authService.authenticate(input);

        assertEquals("jwt-admin", token);
        verify(jwtService).generateToken(account);
        verifyNoInteractions(passwordResetService, userAuthorization);
    }

    @Test
    void changePassword_delegatesToPasswordResetService() {
        // Arrange
        AuthService authService = new AuthService(authenticationManager, jwtService, passwordResetService, userAuthorization);
        AuthModels.ChangeRequest body = new AuthModels.ChangeRequest("CODE123", "newPassword!");

        // Act
        authService.changePassword(body);

        // Assert
        verify(passwordResetService).changePassword("CODE123", "newPassword!");
        verifyNoInteractions(authenticationManager, jwtService);
    }
}
