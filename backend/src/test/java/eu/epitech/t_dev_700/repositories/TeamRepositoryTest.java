package eu.epitech.t_dev_700.repositories;

import eu.epitech.t_dev_700.entities.TeamEntity;
import jakarta.validation.ConstraintViolationException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@DataJpaTest
@ActiveProfiles("test")
class TeamRepositoryTest {

    @Autowired
    private TeamRepository teamRepository;

    @Autowired
    private TestEntityManager entityManager;

    private TeamEntity testTeam;

    @BeforeEach
    void setUp() {
        testTeam = new TeamEntity();
        testTeam.setName("Development Team");
        testTeam.setDescription("A team of developers");
    }

    @Test
    void testSaveTeam_shouldPersistTeam() {
        TeamEntity saved = teamRepository.save(testTeam);

        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getName()).isEqualTo("Development Team");
        assertThat(saved.getDescription()).isEqualTo("A team of developers");
    }

    @Test
    void testFindById_whenExists_shouldReturnTeam() {
        TeamEntity saved = teamRepository.save(testTeam);
        entityManager.flush();

        Optional<TeamEntity> found = teamRepository.findById(saved.getId());

        assertThat(found).isPresent();
        assertThat(found.get().getName()).isEqualTo("Development Team");
    }

    @Test
    void testFindById_whenNotExists_shouldReturnEmpty() {
        Optional<TeamEntity> found = teamRepository.findById(999L);

        assertThat(found).isEmpty();
    }

    @Test
    void testFindAll_shouldReturnAllActiveTeams() {
        teamRepository.save(testTeam);

        TeamEntity team2 = new TeamEntity();
        team2.setName("QA Team");
        team2.setDescription("Quality assurance team");
        teamRepository.save(team2);

        List<TeamEntity> teams = teamRepository.findAll();

        assertThat(teams).hasSize(2);
    }

    @Test
    void testUpdateTeam_shouldPersistChanges() {
        TeamEntity saved = teamRepository.save(testTeam);
        entityManager.flush();
        entityManager.clear();

        saved.setName("Updated Team Name");
        TeamEntity updated = teamRepository.save(saved);
        entityManager.flush();

        TeamEntity found = teamRepository.findById(updated.getId()).orElseThrow();
        assertThat(found.getName()).isEqualTo("Updated Team Name");
    }

    @Test
    void testDeleteTeam_shouldSoftDelete() {
        TeamEntity saved = teamRepository.save(testTeam);
        Long teamId = saved.getId();
        entityManager.flush();

        teamRepository.delete(saved);
        entityManager.flush();
        entityManager.clear();

        // Due to @SQLRestriction, soft-deleted teams should not be found
        Optional<TeamEntity> found = teamRepository.findById(teamId);
        assertThat(found).isEmpty();
    }

    @Test
    void testSaveTeam_withoutName_shouldThrowException() {
        testTeam.setName(null);

        assertThatThrownBy(() -> {
            teamRepository.save(testTeam);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void testSaveTeam_withBlankName_shouldThrowException() {
        testTeam.setName("   ");

        assertThatThrownBy(() -> {
            teamRepository.save(testTeam);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

    @Test
    void testSaveTeam_withoutDescription_shouldSucceed() {
        testTeam.setDescription(null);

        TeamEntity saved = teamRepository.save(testTeam);

        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getDescription()).isNull();
    }

    @Test
    void testSaveTeam_withLongName_shouldSucceed() {
        testTeam.setName("A".repeat(100));

        TeamEntity saved = teamRepository.save(testTeam);

        assertThat(saved.getName()).hasSize(100);
    }

    @Test
    void testSaveTeam_withNameTooLong_shouldThrowException() {
        testTeam.setName("A".repeat(101));

        assertThatThrownBy(() -> {
            teamRepository.save(testTeam);
            entityManager.flush();
        }).isInstanceOf(ConstraintViolationException.class);
    }

}
