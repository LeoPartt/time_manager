package eu.epitech.t_dev_700.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(
        name = "membership",
        uniqueConstraints = @UniqueConstraint(name = "ux_membership_user_team", columnNames = {"user_id", "team_id"}),
        indexes = {
                @Index(name = "idx_membership_team_role", columnList = "team_id, role"),
                @Index(name = "idx_membership_user", columnList = "user_id")
        }
)
public class MembershipEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false, foreignKey = @ForeignKey(name = "fk_membership_user"))
    private UserEntity user;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "team_id", nullable = false, foreignKey = @ForeignKey(name = "fk_membership_team"))
    private TeamEntity team;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(name = "role", nullable = false)
    private TeamRole role;

    public enum TeamRole {
        MEMBER,
        MANAGER
    }

    public MembershipEntity() {
    }

    public MembershipEntity(UserEntity user, TeamEntity team, TeamRole role) {
        this.user = user;
        this.team = team;
        this.role = role;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof MembershipEntity other)) return false;

        if (id != null && other.id != null) return id.equals(other.id);

        return user != null && team != null
               && other.user != null && other.team != null
               && user.getId() != null && team.getId() != null
               && user.getId().equals(other.user.getId())
               && team.getId().equals(other.team.getId());
    }

    @Override
    public int hashCode() {
        if (id != null) return id.hashCode();
        // avoid loading proxies; use IDs if available
        Long userId = user != null ? user.getId() : null;
        Long teamId = team != null ? team.getId() : null;
        return java.util.Objects.hash(userId, teamId);
    }

}
