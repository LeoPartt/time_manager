package eu.epitech.t_dev_700.mappers;

import eu.epitech.t_dev_700.entities.PlanningEntity;
import eu.epitech.t_dev_700.models.PlanningModels;
import org.mapstruct.*;

import java.util.List;
import java.util.stream.Stream;

@Mapper(componentModel = "spring")
public interface PlanningMapper extends CRUDMapper<
        PlanningEntity,
        PlanningModels.PlanningResponse,
        PlanningModels.PostPlanningRequest,
        PlanningModels.PutPlanningRequest,
        PlanningModels.PatchPlanningRequest
        > {

    @Override
    @Mapping(target = "userId", source = "user.id")
    PlanningModels.PlanningResponse toModel(PlanningEntity entity);

    @Override
    default PlanningModels.PlanningResponse[] listEntity(List<PlanningEntity> entities) {
        return entities.stream().map(this::toModel).toArray(PlanningModels.PlanningResponse[]::new);
    }

    @Override
    default PlanningModels.PlanningResponse[] listEntity(Stream<PlanningEntity> stream) {
        return stream.map(this::toModel).toArray(PlanningModels.PlanningResponse[]::new);
    }

    @Override
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "user", ignore = true)
    PlanningEntity createEntity(PlanningModels.PostPlanningRequest req);

    @Override
    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "user", ignore = true)
    void replaceEntity(@MappingTarget PlanningEntity entity, PlanningModels.PutPlanningRequest body);

    @Override
    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "user", ignore = true)
    void updateEntity(@MappingTarget PlanningEntity entity, PlanningModels.PatchPlanningRequest body);

}
