package eu.epitech.t_dev_700.entities;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static eu.epitech.t_dev_700.entities.MembershipEntity.TeamRole.MEMBER;
import static org.assertj.core.api.Assertions.assertThat;

class MembershipEntityTest {

    private MembershipEntity membership;
    private UserEntity user;
    private TeamEntity team;

    @BeforeEach
    void setUp() {
        membership = new MembershipEntity();
        membership.setId(1L);
        membership.setRole(MEMBER);

        user = new UserEntity();
        user.setId(1L);
        user.setFirstName("John");
        user.setLastName("Doe");

        team = new TeamEntity();
        team.setId(1L);
        team.setName("Development Team");

        membership.setUser(user);
        membership.setTeam(team);
    }

    @Test
    void testGettersAndSetters() {
        assertThat(membership.getId()).isEqualTo(1L);
        assertThat(membership.getUser()).isEqualTo(user);
        assertThat(membership.getTeam()).isEqualTo(team);
        assertThat(membership.getRole()).isEqualTo(MEMBER);
    }

    @Test
    void testNoArgsConstructor_initialState() {
        MembershipEntity m = new MembershipEntity();

        // Entity defines no defaults, so everything should be null initially.
        assertThat(m.getId()).isNull();
        assertThat(m.getUser()).isNull();
        assertThat(m.getTeam()).isNull();
        assertThat(m.getRole()).isNull();
    }

    @Test
    void testAllArgsConstructor_setsFields() {
        MembershipEntity m = new MembershipEntity(
                user,
                team,
                MembershipEntity.TeamRole.MANAGER
        );

        assertThat(m.getUser()).isEqualTo(user);
        assertThat(m.getTeam()).isEqualTo(team);
        assertThat(m.getRole()).isEqualTo(MembershipEntity.TeamRole.MANAGER);
    }

    @Test
    void testSetRole_MEMBER() {
        membership.setRole(MEMBER);
        assertThat(membership.getRole()).isEqualTo(MEMBER);
    }

    @Test
    void testSetRole_MANAGER() {
        membership.setRole(MembershipEntity.TeamRole.MANAGER);
        assertThat(membership.getRole()).isEqualTo(MembershipEntity.TeamRole.MANAGER);
    }

    @Test
    void testTeamRoleEnum_hasCorrectValues() {
        MembershipEntity.TeamRole[] roles = MembershipEntity.TeamRole.values();
        assertThat(roles).hasSize(2);
        assertThat(roles).containsExactlyInAnyOrder(
                MEMBER,
                MembershipEntity.TeamRole.MANAGER
        );
    }

    @Test
    void testTeamRoleEnum_valueOf() {
        assertThat(MembershipEntity.TeamRole.valueOf("MEMBER"))
                .isEqualTo(MEMBER);
        assertThat(MembershipEntity.TeamRole.valueOf("MANAGER"))
                .isEqualTo(MembershipEntity.TeamRole.MANAGER);
    }

    @Test
    void testRelationshipWithUser() {
        UserEntity newUser = new UserEntity();
        newUser.setId(2L);
        newUser.setFirstName("Jane");

        membership.setUser(newUser);

        assertThat(membership.getUser()).isEqualTo(newUser);
        assertThat(membership.getUser().getFirstName()).isEqualTo("Jane");
    }

    @Test
    void testRelationshipWithTeam() {
        TeamEntity newTeam = new TeamEntity();
        newTeam.setId(2L);
        newTeam.setName("QA Team");

        membership.setTeam(newTeam);

        assertThat(membership.getTeam()).isEqualTo(newTeam);
        assertThat(membership.getTeam().getName()).isEqualTo("QA Team");
    }

    @Test
    void equals_shouldMatchSameUserAndTeam() {
        MembershipEntity m1 = new MembershipEntity(user, team, MEMBER);
        MembershipEntity m2 = new MembershipEntity(user, team, MEMBER);

        assertThat(m1).isEqualTo(m2);
    }
}
