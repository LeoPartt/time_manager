package eu.epitech.t_dev_700.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.Objects;

@Getter
@Setter
@Entity
@Table(
        name = "temp_tokens",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "ux_temp_tokens_token_hash",
                        columnNames = "token_hash"
                )
        },
        indexes = {
                @Index(name = "idx_temp_tokens_account", columnList = "account_id"),
                @Index(name = "idx_temp_tokens_expires_at", columnList = "expires_at"),
                @Index(name = "idx_temp_tokens_consumed_at", columnList = "consumed_at")
        }
)
public class TemporaryTokenEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** SHA-256 hex (64 chars) or similar */
    @Column(name = "token_hash", nullable = false, length = 64)
    private String tokenHash;

    @Enumerated(EnumType.STRING)
    @Column(name = "action", nullable = false, length = 64)
    private Action action;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(
            name = "account_id",
            nullable = false,
            foreignKey = @ForeignKey(name = "fk_temp_token_account")
    )
    private AccountEntity account;

    @Column(name = "expires_at", nullable = false)
    private LocalDateTime expiresAt;

    /** Null until token is consumed */
    @Column(name = "consumed_at")
    private LocalDateTime consumedAt;

    protected TemporaryTokenEntity() {
        // JPA only
    }

    public TemporaryTokenEntity(
            String tokenHash,
            Action action,
            AccountEntity account,
            LocalDateTime expiresAt
    ) {
        this.tokenHash = Objects.requireNonNull(tokenHash, "tokenHash");
        this.action = Objects.requireNonNull(action, "action");
        this.account = Objects.requireNonNull(account, "account");
        this.expiresAt = Objects.requireNonNull(expiresAt, "expiresAt");
    }

    /* ---------------- Business logic ---------------- */

    public boolean isExpired(LocalDateTime dateTime) {
        return dateTime.isAfter(expiresAt);
    }

    public boolean isConsumed() {
        return consumedAt != null;
    }

    public boolean isValid(LocalDateTime dateTime) {
        return !isConsumed() && !isExpired(dateTime);
    }

    /** Idempotent consume */
    public void consume(LocalDateTime dateTime) {
        if (consumedAt == null) {
            consumedAt = dateTime;
        }
    }

    public enum Action {
        CHANGE_PASSWORD
    }
}
