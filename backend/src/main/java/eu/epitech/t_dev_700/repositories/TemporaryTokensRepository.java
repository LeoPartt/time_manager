package eu.epitech.t_dev_700.repositories;

import eu.epitech.t_dev_700.entities.TemporaryTokenEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TemporaryTokensRepository extends JpaRepository<TemporaryTokenEntity, Long> {
    Optional<TemporaryTokenEntity> findByToken(String token);
}
