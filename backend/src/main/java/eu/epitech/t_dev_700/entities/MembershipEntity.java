package eu.epitech.t_dev_700.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.SQLRestriction;

import java.time.OffsetDateTime;

@Entity
@Getter
@Setter
@Table(name = "membership",
        uniqueConstraints = @UniqueConstraint(name = "ux_membership_user_team",
                columnNames = {"user_id", "team_id"}),
        indexes = @Index(name = "idx_membership_team_role", columnList = "team_id, role")
)
@SQLDelete(sql = "UPDATE membership SET deleted_at = now() WHERE id = ?")
@SQLRestriction("deleted_at IS NULL")
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

    @Column(name = "deleted_at")
    private OffsetDateTime deletedAt;

    @Enumerated(EnumType.STRING)
    @Column(name = "role", nullable = false)
    private TeamRole role;

    public enum TeamRole {
        MEMBER,
        MANAGER
    }

}
