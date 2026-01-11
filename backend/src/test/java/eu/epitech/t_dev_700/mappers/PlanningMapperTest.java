package eu.epitech.t_dev_700.mappers;

import eu.epitech.t_dev_700.entities.PlanningEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.models.PlanningModels;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;

import java.time.LocalTime;
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
        planningEntity.setWeekDay(PlanningEntity.WeekDay.MONDAY);
        planningEntity.setStartTime(LocalTime.of(9, 0));
        planningEntity.setEndTime(LocalTime.of(17, 0));
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

    @Test
    void toModel_nullEntity_shouldReturnNull() {
        assertThat(planningMapper.toModel(null)).isNull();
    }

    @Test
    void toModel_userNull_shouldSetUserIdNull() {
        PlanningEntity e = new PlanningEntity();
        e.setId(1L);
        e.setUser(null); // hit entityUserId(...) user==null branch
        e.setWeekDay(PlanningEntity.WeekDay.MONDAY);
        e.setStartTime(LocalTime.of(9, 0));
        e.setEndTime(LocalTime.of(17, 0));

        PlanningModels.PlanningResponse model = planningMapper.toModel(e);

        assertThat(model).isNotNull();
        assertThat(model.id()).isEqualTo(1L);
        assertThat(model.userId()).isNull();
    }

    @Test
    void createEntity_nullRequest_shouldReturnNull() {
        assertThat(planningMapper.createEntity(null)).isNull();
    }

    @Test
    void replaceEntity_nullBody_shouldDoNothing() {
        PlanningEntity target = new PlanningEntity();
        target.setWeekDay(PlanningEntity.WeekDay.TUESDAY);
        target.setStartTime(LocalTime.of(10, 0));
        target.setEndTime(LocalTime.of(18, 0));

        planningMapper.replaceEntity(target, null);

        // unchanged
        assertThat(target.getWeekDay()).isEqualTo(PlanningEntity.WeekDay.TUESDAY);
        assertThat(target.getStartTime()).isEqualTo(LocalTime.of(10, 0));
        assertThat(target.getEndTime()).isEqualTo(LocalTime.of(18, 0));
    }

    @Test
    void updateEntity_nullBody_shouldDoNothing() {
        PlanningEntity target = new PlanningEntity();
        target.setWeekDay(PlanningEntity.WeekDay.TUESDAY);
        target.setStartTime(LocalTime.of(10, 0));
        target.setEndTime(LocalTime.of(18, 0));

        planningMapper.updateEntity(target, null);

        // unchanged
        assertThat(target.getWeekDay()).isEqualTo(PlanningEntity.WeekDay.TUESDAY);
        assertThat(target.getStartTime()).isEqualTo(LocalTime.of(10, 0));
        assertThat(target.getEndTime()).isEqualTo(LocalTime.of(18, 0));
    }

    @Test
    void updateEntity_shouldUpdateOnlyNonNullFields() {
        PlanningEntity target = new PlanningEntity();
        target.setWeekDay(PlanningEntity.WeekDay.MONDAY);
        target.setStartTime(LocalTime.of(9, 0));
        target.setEndTime(LocalTime.of(17, 0));

        // weekDay null -> false branch
        // startTime non-null -> true branch
        // endTime non-null -> true branch
        PlanningModels.PatchPlanningRequest patch = new PlanningModels.PatchPlanningRequest(
                null,
                LocalTime.of(8, 30),
                LocalTime.of(16, 30)
        );

        planningMapper.updateEntity(target, patch);

        assertThat(target.getWeekDay()).isEqualTo(PlanningEntity.WeekDay.MONDAY); // unchanged
        assertThat(target.getStartTime()).isEqualTo(LocalTime.of(8, 30));        // updated
        assertThat(target.getEndTime()).isEqualTo(LocalTime.of(16, 30));         // updated
    }

    @Test
    void updateEntity_weekDayNonNull_shouldUpdateWeekDay() {
        PlanningEntity target = new PlanningEntity();
        target.setWeekDay(PlanningEntity.WeekDay.MONDAY);
        target.setStartTime(LocalTime.of(9, 0));
        target.setEndTime(LocalTime.of(17, 0));

        // weekDay true branch
        // startTime null -> false branch
        // endTime null -> false branch
        PlanningModels.PatchPlanningRequest patch = new PlanningModels.PatchPlanningRequest(
                PlanningEntity.WeekDay.FRIDAY,
                null,
                null
        );

        planningMapper.updateEntity(target, patch);

        assertThat(target.getWeekDay()).isEqualTo(PlanningEntity.WeekDay.FRIDAY);
        assertThat(target.getStartTime()).isEqualTo(LocalTime.of(9, 0));
        assertThat(target.getEndTime()).isEqualTo(LocalTime.of(17, 0));
    }

    @Test
    void createEntity_nonNullRequest_shouldCopyWeekDayAndTimes() {
        PlanningModels.PostPlanningRequest req = new PlanningModels.PostPlanningRequest(
                1L, // userId (mapper ignores it here)
                PlanningEntity.WeekDay.WEDNESDAY,
                LocalTime.of(8, 15),
                LocalTime.of(16, 45)
        );

        PlanningEntity entity = planningMapper.createEntity(req);

        assertThat(entity).isNotNull();
        assertThat(entity.getId()).isNull(); // mapper doesn't set id
        assertThat(entity.getUser()).isNull(); // mapper doesn't set user
        assertThat(entity.getWeekDay()).isEqualTo(PlanningEntity.WeekDay.WEDNESDAY);
        assertThat(entity.getStartTime()).isEqualTo(LocalTime.of(8, 15));
        assertThat(entity.getEndTime()).isEqualTo(LocalTime.of(16, 45));
    }

    @Test
    void replaceEntity_nonNullBody_shouldOverwriteAllFields() {
        PlanningEntity target = new PlanningEntity();
        target.setWeekDay(PlanningEntity.WeekDay.MONDAY);
        target.setStartTime(LocalTime.of(9, 0));
        target.setEndTime(LocalTime.of(17, 0));

        PlanningModels.PutPlanningRequest body = new PlanningModels.PutPlanningRequest(
                PlanningEntity.WeekDay.FRIDAY,
                LocalTime.of(10, 0),
                LocalTime.of(18, 0)
        );

        planningMapper.replaceEntity(target, body);

        assertThat(target.getWeekDay()).isEqualTo(PlanningEntity.WeekDay.FRIDAY);
        assertThat(target.getStartTime()).isEqualTo(LocalTime.of(10, 0));
        assertThat(target.getEndTime()).isEqualTo(LocalTime.of(18, 0));
    }
}
