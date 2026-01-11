package eu.epitech.t_dev_700.mappers;

import eu.epitech.t_dev_700.entities.TeamEntity;
import eu.epitech.t_dev_700.models.TeamModels;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class TeamMapperTest {

    private final TeamMapper teamMapper = Mappers.getMapper(TeamMapper.class);

    private TeamEntity teamEntity;

    @BeforeEach
    void setUp() {
        teamEntity = new TeamEntity();
        teamEntity.setId(1L);
        teamEntity.setName("Development Team");
        teamEntity.setDescription("A team of developers");
    }

    @Test
    void testToModel_shouldMapEntityToModel() {
        TeamModels.TeamResponse model = teamMapper.toModel(teamEntity);

        assertThat(model).isNotNull();
        assertThat(model.id()).isEqualTo(1L);
        assertThat(model.name()).isEqualTo("Development Team");
        assertThat(model.description()).isEqualTo("A team of developers");
    }

    @Test
    void testToModel_withNullDescription_shouldMapCorrectly() {
        teamEntity.setDescription(null);

        TeamModels.TeamResponse model = teamMapper.toModel(teamEntity);

        assertThat(model).isNotNull();
        assertThat(model.description()).isNull();
    }

    @Test
    void testListEntity_shouldMapEntitiesToModels() {
        TeamEntity team2 = new TeamEntity();
        team2.setId(2L);
        team2.setName("QA Team");
        team2.setDescription("Quality assurance team");

        List<TeamEntity> entities = Arrays.asList(teamEntity, team2);

        TeamModels.TeamResponse[] models = teamMapper.listEntity(entities);

        assertThat(models).hasSize(2);
        assertThat(models[0].id()).isEqualTo(1L);
        assertThat(models[0].name()).isEqualTo("Development Team");
        assertThat(models[1].id()).isEqualTo(2L);
        assertThat(models[1].name()).isEqualTo("QA Team");
    }

    @Test
    void testListEntity_withEmptyList_shouldReturnEmptyArray() {
        List<TeamEntity> entities = Arrays.asList();

        TeamModels.TeamResponse[] models = teamMapper.listEntity(entities);

        assertThat(models).isEmpty();
    }

    @Test
    void testCreateEntity_shouldMapRequestToEntity() {
        TeamModels.PostTeamRequest request = new TeamModels.PostTeamRequest(
                "New Team",
                "A brand new team"
        );

        TeamEntity entity = teamMapper.createEntity(request);

        assertThat(entity).isNotNull();
        assertThat(entity.getId()).isNull(); // Not set by mapper
        assertThat(entity.getName()).isEqualTo("New Team");
        assertThat(entity.getDescription()).isEqualTo("A brand new team");
    }

    @Test
    void testCreateEntity_withNullDescription_shouldMapCorrectly() {
        TeamModels.PostTeamRequest request = new TeamModels.PostTeamRequest(
                "Team Without Description",
                null
        );

        TeamEntity entity = teamMapper.createEntity(request);

        assertThat(entity).isNotNull();
        assertThat(entity.getName()).isEqualTo("Team Without Description");
        assertThat(entity.getDescription()).isNull();
    }

    @Test
    void testReplaceEntity_shouldUpdateAllFields() {
        TeamModels.PutTeamRequest request = new TeamModels.PutTeamRequest(
                "Updated Team Name",
                "Updated description"
        );

        teamMapper.replaceEntity(teamEntity, request);

        assertThat(teamEntity.getName()).isEqualTo("Updated Team Name");
        assertThat(teamEntity.getDescription()).isEqualTo("Updated description");
        assertThat(teamEntity.getId()).isEqualTo(1L); // ID should remain unchanged
    }

    @Test
    void testReplaceEntity_withNullDescription_shouldSetDescriptionToNull() {
        TeamModels.PutTeamRequest request = new TeamModels.PutTeamRequest(
                "New Name",
                null
        );

        teamMapper.replaceEntity(teamEntity, request);

        assertThat(teamEntity.getName()).isEqualTo("New Name");
        assertThat(teamEntity.getDescription()).isNull();
        assertThat(teamEntity.getId()).isEqualTo(1L);
    }


    @Test
    void testUpdateEntity_shouldUpdateOnlyProvidedFields() {
        TeamModels.PatchTeamRequest request = new TeamModels.PatchTeamRequest(
                null,
                "Patched description only"
        );

        String originalName = teamEntity.getName();

        teamMapper.updateEntity(teamEntity, request);

        assertThat(teamEntity.getName()).isEqualTo(originalName); // Not updated
        assertThat(teamEntity.getDescription()).isEqualTo("Patched description only"); // Updated
    }

    @Test
    void testUpdateEntity_withNameOnly_shouldUpdateName() {
        TeamModels.PatchTeamRequest request = new TeamModels.PatchTeamRequest(
                "Patched Name",
                null
        );

        String originalDescription = teamEntity.getDescription();

        teamMapper.updateEntity(teamEntity, request);

        assertThat(teamEntity.getName()).isEqualTo("Patched Name"); // Updated
        assertThat(teamEntity.getDescription()).isEqualTo(originalDescription); // Not updated
    }

    @Test
    void testUpdateEntity_withAllNulls_shouldNotChangeEntity() {
        TeamModels.PatchTeamRequest request = new TeamModels.PatchTeamRequest(
                null,
                null
        );

        String originalName = teamEntity.getName();
        String originalDescription = teamEntity.getDescription();

        teamMapper.updateEntity(teamEntity, request);

        assertThat(teamEntity.getName()).isEqualTo(originalName);
        assertThat(teamEntity.getDescription()).isEqualTo(originalDescription);
    }

    @Test
    void testUpdateEntity_withBothFields_shouldUpdateBoth() {
        TeamModels.PatchTeamRequest request = new TeamModels.PatchTeamRequest(
                "Completely New Name",
                "Completely New Description"
        );

        teamMapper.updateEntity(teamEntity, request);

        assertThat(teamEntity.getName()).isEqualTo("Completely New Name");
        assertThat(teamEntity.getDescription()).isEqualTo("Completely New Description");
    }

    @Test
    void testToModel_withNullEntity_shouldReturnNull() {
        assertThat(teamMapper.toModel(null)).isNull();
    }

    @Test
    void testListEntity_stream_shouldMapEntitiesToModels() {
        TeamEntity team2 = new TeamEntity();
        team2.setId(2L);
        team2.setName("QA Team");
        team2.setDescription("Quality assurance team");

        TeamModels.TeamResponse[] models =
                teamMapper.listEntity(Stream.of(teamEntity, team2));

        assertThat(models).hasSize(2);
        assertThat(models[0].id()).isEqualTo(1L);
        assertThat(models[1].id()).isEqualTo(2L);
    }

    @Test
    void testListEntity_withNullList_shouldThrow() {
        assertThatThrownBy(() -> teamMapper.listEntity((List<TeamEntity>) null))
                .isInstanceOf(NullPointerException.class);
    }


    @Test
    void testCreateEntity_withNullRequest_shouldReturnNull() {
        assertThat(teamMapper.createEntity(null)).isNull();
    }

    @Test
    void testReplaceEntity_withNullBody_shouldDoNothing() {
        String originalName = teamEntity.getName();
        String originalDescription = teamEntity.getDescription();
        Long originalId = teamEntity.getId();

        teamMapper.replaceEntity(teamEntity, null);

        assertThat(teamEntity.getId()).isEqualTo(originalId);
        assertThat(teamEntity.getName()).isEqualTo(originalName);
        assertThat(teamEntity.getDescription()).isEqualTo(originalDescription);
    }

    @Test
    void testUpdateEntity_withNullBody_shouldDoNothing() {
        String originalName = teamEntity.getName();
        String originalDescription = teamEntity.getDescription();
        Long originalId = teamEntity.getId();

        teamMapper.updateEntity(teamEntity, null);

        assertThat(teamEntity.getId()).isEqualTo(originalId);
        assertThat(teamEntity.getName()).isEqualTo(originalName);
        assertThat(teamEntity.getDescription()).isEqualTo(originalDescription);
    }
}
