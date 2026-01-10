package eu.epitech.t_dev_700.services;

import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.test.util.ReflectionTestUtils;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;

import static org.junit.jupiter.api.Assertions.*;

class JwtServiceTest {

    private JwtService jwtService;
    private UserDetails userDetails;

    // Base64-encoded secret (must be at least 256 bits for HS256)
    private static final String SECRET_KEY =
            "dGVzdC1zZWNyZXQta2V5LXZlcnktc2VjdXJlLTEyMzQ1Njc4OTA=";

    private static final long EXPIRATION_TIME = 1000 * 60 * 60; // 1 hour

    @BeforeEach
    void setUp() {
        jwtService = new JwtService();

        // Inject private fields
        ReflectionTestUtils.setField(jwtService, "secretKey", SECRET_KEY);
        ReflectionTestUtils.setField(jwtService, "jwtExpiration", EXPIRATION_TIME);

        userDetails = User.builder()
                .username("testuser")
                .password("password")
                .roles("USER")
                .build();
    }

    @Test
    void shouldGenerateToken() {
        String token = jwtService.generateToken(userDetails);

        assertNotNull(token);
        assertFalse(token.isEmpty());
    }

    @Test
    void shouldExtractUsernameFromToken() {
        String token = jwtService.generateToken(userDetails);

        String username = jwtService.extractUsername(token);

        assertEquals("testuser", username);
    }

    @Test
    void shouldValidateTokenForCorrectUser() {
        String token = jwtService.generateToken(userDetails);

        boolean isValid = jwtService.isTokenValid(token, userDetails);

        assertTrue(isValid);
    }

    @Test
    void shouldInvalidateTokenForWrongUser() {
        String token = jwtService.generateToken(userDetails);

        UserDetails otherUser = User.builder()
                .username("otheruser")
                .password("password")
                .roles("USER")
                .build();

        assertFalse(jwtService.isTokenValid(token, otherUser));
    }

    @Test
    void shouldThrowExpiredJwtExceptionWhenTokenIsExpired() {
        byte[] keyBytes = Decoders.BASE64.decode(SECRET_KEY);
        Key key = Keys.hmacShaKeyFor(keyBytes);

        String expiredToken = Jwts.builder()
                .setSubject(userDetails.getUsername())
                .setIssuedAt(new Date(System.currentTimeMillis() - 10_000))
                .setExpiration(new Date(System.currentTimeMillis() - 5_000))
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();

        assertThrows(ExpiredJwtException.class,
                () -> jwtService.isTokenValid(expiredToken, userDetails));
    }

    @Test
    void shouldIncludeExtraClaims() {
        HashMap<String, Object> claims = new HashMap<>();
        claims.put("role", "ADMIN");

        String token = jwtService.generateToken(claims, userDetails);

        String role = jwtService.extractClaim(token, c -> c.get("role", String.class));

        assertEquals("ADMIN", role);
    }
}
