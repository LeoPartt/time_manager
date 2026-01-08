package eu.epitech.t_dev_700.services;

public interface MailService {
    void sendPasswordResetEmail(String to, String token);
}
