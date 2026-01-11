package eu.epitech.t_dev_700.entities;

import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;

import static org.assertj.core.api.Assertions.*;

class TemporaryTokenEntityTest {

    @Test
    void constructor_shouldSetFields_andLeaveConsumedAtNull() {
        AccountEntity account = new AccountEntity();
        account.setUsername("johndoe");
        account.setPassword("password");

        LocalDateTime expiresAt = LocalDateTime.of(2026, 1, 10, 12, 0);

        TemporaryTokenEntity token = new TemporaryTokenEntity(
                "hash_123",
                TemporaryTokenEntity.Action.CHANGE_PASSWORD,
                account,
                expiresAt
        );

        assertThat(token.getTokenHash()).isEqualTo("hash_123");
        assertThat(token.getAction()).isEqualTo(TemporaryTokenEntity.Action.CHANGE_PASSWORD);
        assertThat(token.getAccount()).isSameAs(account);
        assertThat(token.getExpiresAt()).isEqualTo(expiresAt);

        assertThat(token.getConsumedAt()).isNull();
        assertThat(token.isConsumed()).isFalse();
    }

    @Test
    void constructor_shouldThrow_whenAnyArgIsNull() {
        AccountEntity account = new AccountEntity();
        account.setUsername("johndoe");
        account.setPassword("password");

        LocalDateTime expiresAt = LocalDateTime.now().plusHours(1);

        assertThatThrownBy(() -> new TemporaryTokenEntity(null,
                TemporaryTokenEntity.Action.CHANGE_PASSWORD, account, expiresAt))
                .isInstanceOf(NullPointerException.class)
                .hasMessageContaining("tokenHash");

        assertThatThrownBy(() -> new TemporaryTokenEntity("hash",
                null, account, expiresAt))
                .isInstanceOf(NullPointerException.class)
                .hasMessageContaining("action");

        assertThatThrownBy(() -> new TemporaryTokenEntity("hash",
                TemporaryTokenEntity.Action.CHANGE_PASSWORD, null, expiresAt))
                .isInstanceOf(NullPointerException.class)
                .hasMessageContaining("account");

        assertThatThrownBy(() -> new TemporaryTokenEntity("hash",
                TemporaryTokenEntity.Action.CHANGE_PASSWORD, account, null))
                .isInstanceOf(NullPointerException.class)
                .hasMessageContaining("expiresAt");
    }

    @Test
    void isExpired_shouldReturnFalse_whenNowBeforeExpiresAt() {
        TemporaryTokenEntity token = minimalToken(LocalDateTime.of(2026, 1, 10, 12, 0));

        assertThat(token.isExpired(LocalDateTime.of(2026, 1, 10, 11, 59))).isFalse();
    }

    @Test
    void isExpired_shouldReturnTrue_whenNowAfterExpiresAt() {
        TemporaryTokenEntity token = minimalToken(LocalDateTime.of(2026, 1, 10, 12, 0));

        assertThat(token.isExpired(LocalDateTime.of(2026, 1, 10, 12, 1))).isTrue();
    }

    @Test
    void isValid_shouldReturnTrue_whenNotConsumed_andNotExpired() {
        LocalDateTime now = LocalDateTime.of(2026, 1, 10, 11, 0);
        TemporaryTokenEntity token = minimalToken(now.plusHours(1));

        assertThat(token.isValid(now)).isTrue();
    }

    @Test
    void isValid_shouldReturnFalse_whenExpired() {
        LocalDateTime now = LocalDateTime.of(2026, 1, 10, 13, 0);
        TemporaryTokenEntity token = minimalToken(now.minusMinutes(1));

        assertThat(token.isValid(now)).isFalse();
    }

    @Test
    void consume_shouldSetConsumedAt_once_andBeIdempotent() {
        TemporaryTokenEntity token = minimalToken(LocalDateTime.of(2026, 1, 10, 12, 0));

        LocalDateTime t1 = LocalDateTime.of(2026, 1, 10, 10, 0);
        LocalDateTime t2 = LocalDateTime.of(2026, 1, 10, 10, 5);

        token.consume(t1);
        assertThat(token.getConsumedAt()).isEqualTo(t1);
        assertThat(token.isConsumed()).isTrue();

        token.consume(t2);
        assertThat(token.getConsumedAt()).isEqualTo(t1); // unchanged
    }

    private static TemporaryTokenEntity minimalToken(LocalDateTime expiresAt) {
        AccountEntity account = new AccountEntity();
        account.setUsername("johndoe");
        account.setPassword("password");

        return new TemporaryTokenEntity(
                "hash_123",
                TemporaryTokenEntity.Action.CHANGE_PASSWORD,
                account,
                expiresAt
        );
    }
}
