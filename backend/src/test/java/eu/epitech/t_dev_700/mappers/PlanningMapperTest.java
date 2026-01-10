package eu.epitech.t_dev_700.mappers;

import eu.epitech.t_dev_700.entities.PlanningEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.models.PlanningModels;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;

import java.util.List;
import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;

class PlanningMapperTest {

    private PlanningMapper planningMapper;

    private PlanningEntity planningEntity;

    @BeforeEach
    void setUp() {
        planningMapper = Mappers.getMapper(PlanningMapper.class);

        UserEntity userEntity = new UserEntity();
        userEntity.setId(42L);

        planningEntity = new PlanningEntity();
        planningEntity.setId(1L);
        planningEntity.setUser(userEntity);
    }

    @Test
    void testToModel_shouldMapEntityToModel() {
        PlanningModels.PlanningResponse model = planningMapper.toModel(planningEntity);

        assertThat(model).isNotNull();
        assertThat(model.id()).isEqualTo(1L);
        assertThat(model.userId()).isEqualTo(42L);
    }

    @Test
    void testListEntity_shouldMapList() {
        PlanningModels.PlanningResponse[] models =
                planningMapper.listEntity(List.of(planningEntity));

        assertThat(models).isNotNull();
        assertThat(models).hasSize(1);
        assertThat(models[0].id()).isEqualTo(1L);
        assertThat(models[0].userId()).isEqualTo(42L);
    }

    @Test
    void testListEntityStream_shouldMapStream() {
        PlanningModels.PlanningResponse[] models =
                planningMapper.listEntity(Stream.of(planningEntity));

        assertThat(models).isNotNull();
        assertThat(models).hasSize(1);
        assertThat(models[0].id()).isEqualTo(1L);
        assertThat(models[0].userId()).isEqualTo(42L);
    }
}
