package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.entities.TemporaryTokenEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.repositories.AccountRepository;
import eu.epitech.t_dev_700.repositories.TemporaryTokensRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class PasswordResetServiceTest {

    @Mock private AccountRepository accountRepository;
    @Mock private TemporaryTokensRepository tempTokenRepository;
    @Mock private PasswordEncoder passwordEncoder;
    @Mock private MailService mailService;

    @InjectMocks private PasswordResetService service;

    private UserEntity user;
    private AccountEntity account;

    @BeforeEach
    void setup() {
        account = new AccountEntity();
        user = new UserEntity();
        user.setEmail("user@example.com");
        user.setAccount(account);
    }

    @Test
    void createResetToken_savesToken_andSendsEmail_with6DigitToken() {
        // capture saved token entity + emailed raw token
        ArgumentCaptor<TemporaryTokenEntity> entityCaptor = ArgumentCaptor.forClass(TemporaryTokenEntity.class);
        ArgumentCaptor<String> emailCaptor = ArgumentCaptor.forClass(String.class);
        ArgumentCaptor<String> tokenCaptor = ArgumentCaptor.forClass(String.class);

        service.createResetToken(user);

        verify(tempTokenRepository).save(entityCaptor.capture());
        verify(mailService).sendPasswordResetEmail(emailCaptor.capture(), tokenCaptor.capture());

        assertEquals("user@example.com", emailCaptor.getValue());

        String rawToken = tokenCaptor.getValue();
        assertNotNull(rawToken);
        assertTrue(Pattern.matches("\\d{6}", rawToken), "Token should be 6 digits");

        TemporaryTokenEntity saved = entityCaptor.getValue();
        assertNotNull(saved);

        // validate hash matches what service uses: String.valueOf(Objects.hash(token))
        String expectedHash = String.valueOf(java.util.Objects.hash(rawToken));
        // Adjust getter name if your entity uses getTokenHash() or getToken()
        // Here we try getTokenHash() - change if needed.
        assertEquals(expectedHash, saved.getTokenHash());

        assertEquals(TemporaryTokenEntity.Action.CHANGE_PASSWORD, saved.getAction());
        assertSame(account, saved.getAccount());

        // should be ~15 minutes in the future
        LocalDateTime expiresAt = saved.getExpiresAt(); // change if your getter differs
        assertNotNull(expiresAt);

        LocalDateTime now = LocalDateTime.now();
        assertTrue(expiresAt.isAfter(now.plusMinutes(14)), "Expiry should be about 15 min in the future");
        assertTrue(expiresAt.isBefore(now.plusMinutes(16)), "Expiry should be about 15 min in the future");
    }

    @Test
    void changePassword_invalidToken_throws() {
        String rawToken = "123456";
        String hash = String.valueOf(java.util.Objects.hash(rawToken));

        when(tempTokenRepository.findByTokenHash(hash)).thenReturn(Optional.empty());

        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> service.changePassword(rawToken, "newPassword")
        );

        assertEquals("Invalid token", ex.getMessage());
        verifyNoInteractions(accountRepository, passwordEncoder);
        verify(tempTokenRepository, never()).save(any());
    }

    @Test
    void changePassword_expiredToken_throws() {
        String rawToken = "123456";
        String hash = String.valueOf(java.util.Objects.hash(rawToken));

        TemporaryTokenEntity tokenEntity = mock(TemporaryTokenEntity.class);
        when(tempTokenRepository.findByTokenHash(hash)).thenReturn(Optional.of(tokenEntity));

        when(tokenEntity.isExpired(any(LocalDateTime.class))).thenReturn(true);

        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> service.changePassword(rawToken, "newPassword")
        );

        assertEquals("Token expired", ex.getMessage());
        verifyNoInteractions(accountRepository, passwordEncoder);
        verify(tokenEntity, never()).consume(any());
    }

    @Test
    void changePassword_validToken_updatesPassword_savesAccount_andConsumesToken() {
        String rawToken = "123456";
        String hash = String.valueOf(java.util.Objects.hash(rawToken));
        String newPassword = "newPassword";
        String encoded = "ENCODED_PASSWORD";

        TemporaryTokenEntity tokenEntity = mock(TemporaryTokenEntity.class);

        when(tempTokenRepository.findByTokenHash(hash)).thenReturn(Optional.of(tokenEntity));
        when(tokenEntity.isExpired(any(LocalDateTime.class))).thenReturn(false);
        when(tokenEntity.getAccount()).thenReturn(account);

        when(passwordEncoder.encode(newPassword)).thenReturn(encoded);

        service.changePassword(rawToken, newPassword);

        assertEquals(encoded, account.getPassword());

        verify(accountRepository).save(account);
        verify(tokenEntity).consume(any(LocalDateTime.class));

        // ensure we didn't send email here
        verifyNoInteractions(mailService);
    }
}
