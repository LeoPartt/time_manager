package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.entities.TemporaryTokenEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.repositories.AccountRepository;
import eu.epitech.t_dev_700.repositories.TemporaryTokensRepository;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Objects;

@Service
@RequiredArgsConstructor
public class PasswordResetService {
    private final AccountRepository accountRepository;
    private final TemporaryTokensRepository tempTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final MailService mailService;

    public void createResetToken(UserEntity user) {
        String token = RandomStringUtils.secure().nextNumeric(6);
        TemporaryTokenEntity tempToken = new TemporaryTokenEntity(
                String.valueOf(Objects.hash(token)),
                TemporaryTokenEntity.Action.CHANGE_PASSWORD,
                user.getAccount(),
                LocalDateTime.now().plusMinutes(15)

        );

        tempTokenRepository.save(tempToken);
        mailService.sendPasswordResetEmail(user.getEmail(), token);
    }

    public void changePassword(String token, String newPassword) {
        TemporaryTokenEntity resetToken = tempTokenRepository.findByTokenHash(String.valueOf(Objects.hash(token)))
                .orElseThrow(() -> new IllegalArgumentException("Invalid token"));

        if (resetToken.isExpired(LocalDateTime.now())) {
            throw new IllegalArgumentException("Token expired");
        }

        AccountEntity account = resetToken.getAccount();
        account.setPassword(passwordEncoder.encode(newPassword));
        accountRepository.save(account);

        resetToken.consume(LocalDateTime.now());
    }
}

