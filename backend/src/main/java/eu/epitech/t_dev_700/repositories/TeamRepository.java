package eu.epitech.t_dev_700.repositories;

import eu.epitech.t_dev_700.entities.TeamEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TeamRepository extends JpaRepository<TeamEntity, Long> {

    @Query(value="select * from team where id = :id", nativeQuery=true)
    Optional<TeamEntity> findByIdIncludeDeleted(@Param("id") long id);

}
