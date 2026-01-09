package eu.epitech.t_dev_700.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

import java.util.LinkedHashSet;
import java.util.Objects;
import java.util.Set;

@Entity
@Getter
@Setter
@Table(
        name = "team",
        uniqueConstraints = @UniqueConstraint(name = "ux_team_name", columnNames = {"name"}),
        indexes = {
                @Index(name = "idx_team_name", columnList = "name")
        }
)
public class TeamEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Size(max = 100)
    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Size(max = 255)
    @Column(name = "description", columnDefinition="TEXT")
    private String description;

    @OneToMany(mappedBy = "team", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<MembershipEntity> memberships = new LinkedHashSet<>();

    public void addMembership(MembershipEntity m) {
        if (m == null) return;
        if (m.getTeam() != this) m.setTeam(this);
        memberships.add(m);
    }

    public void removeMembership(MembershipEntity m) {
        if (m == null) return;
        memberships.remove(m);
        if (m.getTeam() == this) m.setTeam(null);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null) return false;
        if (org.hibernate.Hibernate.getClass(this) != org.hibernate.Hibernate.getClass(o)) return false;
        TeamEntity that = (TeamEntity) o;
        return id != null && id.equals(that.id);
    }

    @Override
    public int hashCode() { return Objects.hashCode(id); }

    @Override
    public String toString() { return "Team{id=%d, name='%s'}".formatted(id, name); }
}
