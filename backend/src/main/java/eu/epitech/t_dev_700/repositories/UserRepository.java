package eu.epitech.t_dev_700.repositories;

import eu.epitech.t_dev_700.entities.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Long> {

    @Query(value="select * from tm_user where id = :id", nativeQuery=true)
    Optional<UserEntity> findByIdIncludeDeleted(@Param("id") long id);

}
