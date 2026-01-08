package eu.epitech.t_dev_700.mappers;

import eu.epitech.t_dev_700.entities.AccountEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.models.UserModels;
import eu.epitech.t_dev_700.services.components.PasswordMapper;
import org.mapstruct.*;

import java.util.List;
import java.util.stream.Stream;

@Mapper(componentModel = "spring", uses = PasswordMapper.class)
public interface UserMapper extends CRUDMapper<
        UserEntity,
        UserModels.UserResponse,
        UserModels.PostUserRequest,
        UserModels.PutUserRequest,
        UserModels.PatchUserRequest
        > {

    @Override
    @Mapping(target = "username", source = "account.username")
    @Mapping(target = "isManager", source = "manager")
    @Mapping(target = "isAdministrator", source = "account.admin")
    UserModels.UserResponse toModel(UserEntity entity);

    @Override
    default UserModels.UserResponse[] listEntity(List<UserEntity> entities) {
        return entities.stream().map(this::toModel).toArray(UserModels.UserResponse[]::new);
    }

    @Override
    default UserModels.UserResponse[] listEntity(Stream<UserEntity> stream) {
        return stream.map(this::toModel).toArray(UserModels.UserResponse[]::new);
    }

    @Override
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "account", ignore = true)
    @Mapping(target = "deletedAt", ignore = true)
    @Mapping(target = "account.username", source = "username")
    @Mapping(target = "account.password", source = "password", qualifiedByName = "encodePassword")
    UserEntity createEntity(UserModels.PostUserRequest req);

    @Override
    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "deletedAt", ignore = true)
    @Mapping(target = "account", ignore = true)
    void replaceEntity(@MappingTarget UserEntity entity, UserModels.PutUserRequest body);

    @AfterMapping
    default void replaceAccountUsername(UserModels.PutUserRequest req, @MappingTarget UserEntity user) {
        AccountEntity acc = user.getAccount();
        acc.setUsername(req.username());
    }
    @Override
    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "deletedAt", ignore = true)
    @Mapping(target = "account", ignore = true)
    void updateEntity(@MappingTarget UserEntity entity, UserModels.PatchUserRequest body);

    @AfterMapping
    default void updateAccountUsername(UserModels.PatchUserRequest req, @MappingTarget UserEntity user) {
        AccountEntity acc = user.getAccount();
        acc.setUsername(req.username());
    }
}

