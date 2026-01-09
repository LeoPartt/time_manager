package eu.epitech.t_dev_700.config;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class SecurityConfigTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Test
    void testPasswordEncoder_shouldBeAvailable() {
        assertThat(passwordEncoder).isNotNull();
    }

    @Test
    void testPasswordEncoder_shouldEncodePassword() {
        String rawPassword = "mySecretPassword";
        String encoded = passwordEncoder.encode(rawPassword);

        assertThat(encoded).isNotNull();
        assertThat(encoded).isNotEqualTo(rawPassword);
        assertThat(passwordEncoder.matches(rawPassword, encoded)).isTrue();
    }

    @Test
    void testPasswordEncoder_shouldProduceDifferentHashesForSamePassword() {
        String rawPassword = "password123";
        String encoded1 = passwordEncoder.encode(rawPassword);
        String encoded2 = passwordEncoder.encode(rawPassword);

        assertThat(encoded1).isNotEqualTo(encoded2);
        assertThat(passwordEncoder.matches(rawPassword, encoded1)).isTrue();
        assertThat(passwordEncoder.matches(rawPassword, encoded2)).isTrue();
    }

    /*
    @Test
    void testPublicEndpoints_shouldBeAccessibleWithoutAuthentication() throws Exception {
        // Given the current security config allows all requests
        // This test verifies that endpoints are accessible
        mockMvc.perform(get("/users"))
                .andExpect(status().isOk());
    }
    */

    @Test
    void testPasswordEncoder_shouldRejectWrongPassword() {
        String rawPassword = "correctPassword";
        String wrongPassword = "wrongPassword";
        String encoded = passwordEncoder.encode(rawPassword);

        assertThat(passwordEncoder.matches(wrongPassword, encoded)).isFalse();
    }

    @Test
    void testPasswordEncoder_shouldHandleEmptyPassword() {
        String emptyPassword = "";
        String encoded = passwordEncoder.encode(emptyPassword);

        assertThat(passwordEncoder.matches(emptyPassword, encoded)).isTrue();
    }

    @Test
    void testPasswordEncoder_shouldHandleSpecialCharacters() {
        String complexPassword = "P@ssw0rd!#$%^&*()";
        String encoded = passwordEncoder.encode(complexPassword);

        assertThat(passwordEncoder.matches(complexPassword, encoded)).isTrue();
    }
}
