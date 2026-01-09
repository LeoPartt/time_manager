package eu.epitech.t_dev_700.repositories;

import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.entities.TemporaryTokenEntity;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
@ActiveProfiles("test")
class TemporaryTokensRepositoryTest {

    @Autowired
    private TemporaryTokensRepository repository;

    @Autowired
    private TestEntityManager em;

    private AccountEntity account;

    @BeforeEach
    void setUp() {
        account = new AccountEntity();
        account.setUsername("johndoe");
        account.setPassword("password");
        em.persistAndFlush(account);
    }

    @Test
    void findByTokenHash_shouldReturnEntity_whenTokenExists() {
        TemporaryTokenEntity token = new TemporaryTokenEntity(
                "hash_abc123",
                TemporaryTokenEntity.Action.CHANGE_PASSWORD,
                account,
                LocalDateTime.now().plusHours(1)
        );

        em.persistAndFlush(token);

        Optional<TemporaryTokenEntity> result = repository.findByTokenHash("hash_abc123");

        assertThat(result).isPresent();
        assertThat(result.get().getTokenHash()).isEqualTo("hash_abc123");
        assertThat(result.get().getAction()).isEqualTo(TemporaryTokenEntity.Action.CHANGE_PASSWORD);

        // Don't rely on equals() for entities unless you implemented it
        assertThat(result.get().getAccount().getId()).isEqualTo(account.getId());
    }

    @Test
    void findByTokenHash_shouldReturnEmpty_whenTokenDoesNotExist() {
        Optional<TemporaryTokenEntity> result = repository.findByTokenHash("missing_hash");
        assertThat(result).isEmpty();
    }

    @Test
    void persistedToken_shouldHaveNullConsumedAt_byDefault() {
        TemporaryTokenEntity token = new TemporaryTokenEntity(
                "hash_unused",
                TemporaryTokenEntity.Action.CHANGE_PASSWORD,
                account,
                LocalDateTime.now().plusMinutes(30)
        );

        em.persistAndFlush(token);

        TemporaryTokenEntity reloaded = repository.findByTokenHash("hash_unused").orElseThrow();
        assertThat(reloaded.getConsumedAt()).isNull();
        assertThat(reloaded.isConsumed()).isFalse();
    }

    @Test
    void consumedToken_shouldBePersistedWithConsumedAt() {
        LocalDateTime now = LocalDateTime.now();

        TemporaryTokenEntity token = new TemporaryTokenEntity(
                "hash_to_consume",
                TemporaryTokenEntity.Action.CHANGE_PASSWORD,
                account,
                now.plusMinutes(30)
        );
        token.consume(now);

        em.persistAndFlush(token);

        TemporaryTokenEntity reloaded = repository.findByTokenHash("hash_to_consume").orElseThrow();
        assertThat(reloaded.getConsumedAt()).isEqualTo(now);
        assertThat(reloaded.isConsumed()).isTrue();
        assertThat(reloaded.isValid(now)).isFalse(); // consumed => invalid
    }
}
