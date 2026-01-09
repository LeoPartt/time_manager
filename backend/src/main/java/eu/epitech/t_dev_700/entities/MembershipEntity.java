package eu.epitech.t_dev_700.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.OffsetDateTime;

@Entity
@Getter
@Setter
@Table(
        name = "membership",
        uniqueConstraints = @UniqueConstraint(name = "ux_membership_user_team", columnNames = {"user_id", "team_id"}),
        indexes = @Index(name = "idx_membership_team_role", columnList = "team_id, role")
)
public class MembershipEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id")
    private UserEntity user;

    @ManyToOne(optional = false)
    @JoinColumn(name = "team_id")
    private TeamEntity team;

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

}
