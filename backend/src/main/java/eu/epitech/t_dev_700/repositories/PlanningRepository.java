package eu.epitech.t_dev_700.repositories;

import eu.epitech.t_dev_700.entities.PlanningEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PlanningRepository extends JpaRepository<PlanningEntity, Long> {

    List<PlanningEntity> findByUser(UserEntity user);
}
