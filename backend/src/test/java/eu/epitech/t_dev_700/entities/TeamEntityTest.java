package eu.epitech.t_dev_700.entities;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.OffsetDateTime;

import static org.assertj.core.api.Assertions.assertThat;

class TeamEntityTest {

    private TeamEntity team;

    @BeforeEach
    void setUp() {
        team = new TeamEntity();
        team.setId(1L);
        team.setName("Development Team");
        team.setDescription("A team of developers");
    }

    @Test
    void testGettersAndSetters() {
        assertThat(team.getId()).isEqualTo(1L);
        assertThat(team.getName()).isEqualTo("Development Team");
        assertThat(team.getDescription()).isEqualTo("A team of developers");
        assertThat(team.getMemberships()).isNotNull().isEmpty();
    }

    @Test
    void testAddMembership() {
        MembershipEntity membership = new MembershipEntity();
        membership.setId(1L);
        membership.setRole(MembershipEntity.TeamRole.MEMBER);

        team.addMembership(membership);

        assertThat(team.getMemberships()).hasSize(1).contains(membership);
        assertThat(membership.getTeam()).isEqualTo(team);
    }

    @Test
    void testRemoveMembership() {
        MembershipEntity membership = new MembershipEntity();
        membership.setId(1L);
        membership.setRole(MembershipEntity.TeamRole.MEMBER);

        team.addMembership(membership);
        assertThat(team.getMemberships()).hasSize(1);

        team.removeMembership(membership);
        assertThat(team.getMemberships()).isEmpty();
        assertThat(membership.getTeam()).isNull();
    }

    @Test
    void testAddMultipleMemberships() {
        MembershipEntity membership1 = new MembershipEntity();
        membership1.setId(1L);
        membership1.setRole(MembershipEntity.TeamRole.MEMBER);

        MembershipEntity membership2 = new MembershipEntity();
        membership2.setId(2L);
        membership2.setRole(MembershipEntity.TeamRole.MANAGER);

        team.addMembership(membership1);
        team.addMembership(membership2);

        assertThat(team.getMemberships()).hasSize(2).containsExactlyInAnyOrder(membership1, membership2);
        assertThat(membership1.getTeam()).isEqualTo(team);
        assertThat(membership2.getTeam()).isEqualTo(team);
    }

    @Test
    void testEquals_sameId_shouldBeEqual() {
        TeamEntity team2 = new TeamEntity();
        team2.setId(1L);
        team2.setName("Different Team");

        assertThat(team).isEqualTo(team2);
    }

    @Test
    void testEquals_differentId_shouldNotBeEqual() {
        TeamEntity team2 = new TeamEntity();
        team2.setId(2L);
        team2.setName("Development Team");

        assertThat(team).isNotEqualTo(team2);
    }

    @Test
    void testEquals_nullId_shouldNotBeEqual() {
        TeamEntity team2 = new TeamEntity();
        team2.setName("Team A");

        TeamEntity team3 = new TeamEntity();
        team3.setName("Team B");

        assertThat(team2).isNotEqualTo(team3);
    }

    @Test
    void testEquals_sameInstance_shouldBeEqual() {
        assertThat(team).isEqualTo(team);
    }

    @Test
    void testEquals_null_shouldNotBeEqual() {
        assertThat(team).isNotEqualTo(null);
    }

    @Test
    void testEquals_differentClass_shouldNotBeEqual() {
        assertThat(team).isNotEqualTo("Some String");
    }

    @Test
    void testHashCode_sameId_shouldHaveSameHashCode() {
        TeamEntity team2 = new TeamEntity();
        team2.setId(1L);

        assertThat(team.hashCode()).isEqualTo(team2.hashCode());
    }

    @Test
    void testHashCode_differentId_shouldHaveDifferentHashCode() {
        TeamEntity team2 = new TeamEntity();
        team2.setId(2L);

        assertThat(team.hashCode()).isNotEqualTo(team2.hashCode());
    }

    @Test
    void testToString_shouldContainKeyInformation() {
        String toString = team.toString();
        assertThat(toString).contains("Team");
        assertThat(toString).contains("id=1");
        assertThat(toString).contains("name='Development Team'");
    }

}
