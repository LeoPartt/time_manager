package eu.epitech.t_dev_700.mappers;

import eu.epitech.t_dev_700.entities.TeamEntity;
import eu.epitech.t_dev_700.models.TeamModels;
import org.mapstruct.*;

import java.util.List;
import java.util.stream.Stream;

@Mapper(componentModel = "spring")
public interface TeamMapper extends CRUDMapper<
        TeamEntity,
        TeamModels.TeamResponse,
        TeamModels.PostTeamRequest,
        TeamModels.PutTeamRequest,
        TeamModels.PatchTeamRequest
        > {

    @Override
    TeamModels.TeamResponse toModel(TeamEntity entity);

    @Override
    default TeamModels.TeamResponse[] listEntity(List<TeamEntity> entities) {
        return listEntity(entities.stream());
    }

    @Override
    default TeamModels.TeamResponse[] listEntity(Stream<TeamEntity> stream) {
        return stream.map(this::toModel).toArray(TeamModels.TeamResponse[]::new);
    }

    @Override
    @Mapping(target = "id", ignore = true)
    
    TeamEntity createEntity(TeamModels.PostTeamRequest req);

    @Override
    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.SET_TO_NULL)
    @Mapping(target = "id", ignore = true)
    void replaceEntity(@MappingTarget TeamEntity entity, TeamModels.PutTeamRequest body);

    @Override
    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "id", ignore = true)
    
    void updateEntity(@MappingTarget TeamEntity entity, TeamModels.PatchTeamRequest body);
}

