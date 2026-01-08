package eu.epitech.t_dev_700.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.SQLRestriction;

import java.time.OffsetDateTime;
import java.util.LinkedHashSet;
import java.util.Objects;
import java.util.Set;

@Entity
@Getter
@Setter
@Table(
        name = "team",
        indexes = {
                @Index(name = "idx_team_name", columnList = "name")
        }
)
@SQLDelete(sql = "UPDATE team SET deleted_at = now() WHERE id = ?")
@SQLRestriction("deleted_at IS NULL")
public class TeamEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Size(max = 100)
    @Column(name = "name", nullable = false, unique=true, length = 100)
    private String name;

    @Column(name = "description")
    private String description;

    @Column(name = "deleted_at")
    private OffsetDateTime deletedAt;

    @OneToMany(mappedBy = "team", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<MembershipEntity> memberships = new LinkedHashSet<>();

    public void addMembership(MembershipEntity m) {
        memberships.add(m);
        m.setTeam(this);
    }
    public void removeMembership(MembershipEntity m) {
        memberships.remove(m);
        m.setTeam(null);
    }

    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof TeamEntity that)) return false;
        return id != null && id.equals(that.id);
    }
    @Override public int hashCode() { return Objects.hashCode(id); }

    @Override public String toString() { return "Team{id=%d, name='%s'}".formatted(id, name); }
}
