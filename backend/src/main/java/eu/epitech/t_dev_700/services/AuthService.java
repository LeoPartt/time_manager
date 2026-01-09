package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.models.AuthModels;
import eu.epitech.t_dev_700.services.components.UserAuthorization;
import eu.epitech.t_dev_700.services.exceptions.UnknownUser;
import eu.epitech.t_dev_700.services.exceptions.InvalidCredentials;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@org.springframework.context.annotation.Profile("!test")
public class AuthService {
    private final AuthenticationManager authenticationManager;
    private final JwtService jwtService;
    private final UserService userService;
    private final PasswordResetService passwordResetService;

    public String authenticate(AuthModels.LoginRequest input) {
        Authentication authentication;
        try {
            authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            input.username(),
                            input.password()
                    )
            );
        } catch (BadCredentialsException ex) {
            throw new InvalidCredentials("Invalid password", input.username(), ex);
        } catch (UsernameNotFoundException ex) {
            throw new InvalidCredentials("Invalid username", input.username(), ex);
        }
        AccountEntity account = (AccountEntity) authentication.getPrincipal();
        if (account.getUser() == null && !account.isAdmin()) throw new UnknownUser(account.getUsername());;
        return jwtService.generateToken(account);
    }

    public void resetPassword() {
        passwordResetService.createResetToken(UserAuthorization.getCurrentUser());
    }

    public void changePassword(AuthModels.ChangeRequest body) {
        passwordResetService.changePassword(body.code(), body.password());
    }
}
