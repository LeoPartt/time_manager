package eu.epitech.t_dev_700.entities;

import org.junit.jupiter.api.Test;

import static eu.epitech.t_dev_700.entities.MembershipEntity.TeamRole.MEMBER;
import static org.assertj.core.api.Assertions.assertThat;

class MembershipEntityTest {

    // ---- small helpers ----

    private static UserEntity user(long id) {
        UserEntity u = new UserEntity();
        u.setId(id);
        return u;
    }

    private static TeamEntity team(long id) {
        TeamEntity t = new TeamEntity();
        t.setId(id);
        return t;
    }

    private static MembershipEntity m(UserEntity u, TeamEntity t) {
        return new MembershipEntity(u, t, MEMBER);
    }

    /* -------------------------
     * equals() branch coverage
     * ------------------------- */

    @Test
    void equals_reflexive_and_typeCheck() {
        MembershipEntity a = m(user(1), team(1));

        // this == o
        assertThat(a).isEqualTo(a);

        // !(o instanceof MembershipEntity)
        assertThat(a.equals("nope")).isFalse();
    }

    @Test
    void equals_whenBothIdsNonNull_comparesOnlyIds_true_and_false() {
        MembershipEntity a = m(user(1), team(1));
        a.setId(10L);

        MembershipEntity sameIdDifferentLinks = m(user(999), team(999));
        sameIdDifferentLinks.setId(10L);

        MembershipEntity differentIdSameLinks = m(user(1), team(1));
        differentIdSameLinks.setId(11L);

        // id branch -> true
        assertThat(a).isEqualTo(sameIdDifferentLinks);

        // id branch -> false
        assertThat(a).isNotEqualTo(differentIdSameLinks);
    }

    @Test
    void equals_whenThisIdNonNull_andOtherIdNull_hitsOtherIdNullBranch_and_returnsFalse() {
        MembershipEntity a = m(user(1), team(1));
        a.setId(10L); // this.id != null

        MembershipEntity b = m(user(2), team(2));
        b.setId(null); // other.id == null -> (id != null && other.id != null) is false because other.id != null is false

        // falls back to userId/teamId -> different => false
        assertThat(a).isNotEqualTo(b);
    }

    @Test
    void equals_fallback_otherUserNull_falseBranch() {
        MembershipEntity a = m(user(1), team(1)); // ids null
        MembershipEntity b = m(null, team(1));    // other.user == null

        assertThat(a).isNotEqualTo(b);
    }

    @Test
    void equals_fallback_otherTeamNull_falseBranch() {
        MembershipEntity a = m(user(1), team(1)); // ids null
        MembershipEntity b = m(user(1), null);    // other.team == null

        assertThat(a).isNotEqualTo(b);
    }

    @Test
    void equals_fallback_sameUserIdAndTeamId_withDifferentInstances_true_then_userIdMismatch_false() {
        // true: different objects but same IDs
        MembershipEntity a = m(user(1), team(10));
        MembershipEntity b = m(user(1), team(10));

        assertThat(a.getId()).isNull();
        assertThat(b.getId()).isNull();
        assertThat(a).isEqualTo(b);

        // false: userId mismatch (still passes all null checks)
        MembershipEntity c = m(user(2), team(10));
        assertThat(a).isNotEqualTo(c);
    }

    /* -------------------------
     * hashCode() branch coverage
     * ------------------------- */

    @Test
    void hashCode_whenIdNonNull_usesIdHash() {
        MembershipEntity a = m(user(1), team(1));
        a.setId(123L);

        assertThat(a.hashCode()).isEqualTo(Long.valueOf(123L).hashCode());
    }

    @Test
    void hashCode_whenIdNull_usesUserIdAndTeamId_consistently() {
        MembershipEntity a = m(user(1), team(10));
        MembershipEntity b = m(user(1), team(10));

        // same (userId, teamId) => same hash
        assertThat(a.hashCode()).isEqualTo(b.hashCode());
    }
}