package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.models.AuthModels;
import eu.epitech.t_dev_700.services.components.UserAuthorization;
import eu.epitech.t_dev_700.services.exceptions.DeletedUser;
import eu.epitech.t_dev_700.services.exceptions.InvalidCredentials;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.hibernate.Session;
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
    private final EntityManager entityManager;
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
        verifyIfDeletedUser(account);
        return jwtService.generateToken(account);
    }

    private void verifyIfDeletedUser(AccountEntity account) {
        Session session = entityManager.unwrap(Session.class);
        try {
            session.disableFilter("deletedUserFilter");
            UserEntity user = account.getUser();
            if (user == null) return;
            if (user.getDeletedAt() != null) throw new DeletedUser(account.getUsername());
        } finally {
            session.enableFilter("deletedUserFilter");
        }
    }

    public void resetPassword() {
        passwordResetService.createResetToken(UserAuthorization.getCurrentUser());
    }

    public void changePassword(AuthModels.ChangeRequest body) {
        passwordResetService.changePassword(body.code(), body.password());
    }
}
