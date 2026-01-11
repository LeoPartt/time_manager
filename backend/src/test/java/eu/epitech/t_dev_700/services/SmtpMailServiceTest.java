package eu.epitech.t_dev_700.services;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
class SmtpMailServiceTest {

    @Mock
    private JavaMailSender mailSender;

    @InjectMocks
    private SmtpMailService smtpMailService;

    @Test
    void sendPasswordResetEmail_shouldSendEmailWithToken() {
        // Arrange
        String to = "user@test.com";
        String token = "RESET_TOKEN_123";

        ArgumentCaptor<SimpleMailMessage> mailCaptor =
                ArgumentCaptor.forClass(SimpleMailMessage.class);

        // Act
        smtpMailService.sendPasswordResetEmail(to, token);

        // Assert
        verify(mailSender).send(mailCaptor.capture());

        SimpleMailMessage mail = mailCaptor.getValue();

        assertThat(mail.getTo()).containsExactly(to);
        assertThat(mail.getSubject()).isEqualTo("Password Reset Request");
        assertThat(mail.getText()).contains(token);
        assertThat(mail.getText()).contains("password reset");
    }
}
