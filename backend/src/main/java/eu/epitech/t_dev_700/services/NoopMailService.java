package eu.epitech.t_dev_700.services;

import lombok.RequiredArgsConstructor;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;

@ConditionalOnProperty(name = "app.mail.enabled", havingValue = "false", matchIfMissing = true)
@Service
@RequiredArgsConstructor
public class NoopMailService implements MailService {
    @Override
    public void sendPasswordResetEmail(String to, String token) {
        // do nothing (or log)
    }
}
