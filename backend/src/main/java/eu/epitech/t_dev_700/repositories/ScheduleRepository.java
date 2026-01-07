package eu.epitech.t_dev_700.repositories;

import eu.epitech.t_dev_700.entities.ScheduleEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.OffsetDateTime;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

// ScheduleRepository.java
@Repository
public interface ScheduleRepository extends JpaRepository<ScheduleEntity, Long> {

    List<ScheduleEntity> findByUser(UserEntity user);

    Optional<ScheduleEntity> findByUserAndDepartureTsIsNull(UserEntity user);

    List<ScheduleEntity> findByUserAndArrivalTsBetween(UserEntity user, OffsetDateTime from, OffsetDateTime to);

    List<ScheduleEntity> findByDepartureTsIsNotNullAndArrivalTsBetween(OffsetDateTime from, OffsetDateTime to);

    List<ScheduleEntity> findByUserAndDepartureTsIsNotNullAndArrivalTsBetween(UserEntity user, OffsetDateTime from, OffsetDateTime to);

    List<ScheduleEntity> findByUserIdInAndDepartureTsIsNotNullAndArrivalTsBetween(Collection<Long> userIds,
                                                                                  OffsetDateTime from,
                                                                                  OffsetDateTime to);

    @Query("""
             select s
             from ScheduleEntity s
             where s.user = :user
               and s.arrivalTs <= :now
               and (s.departureTs is null or s.departureTs > :now)
             order by s.arrivalTs desc
            """)
    List<ScheduleEntity> findCurrentSchedules(
            @Param("user") UserEntity user,
            @Param("now") OffsetDateTime now
    );

    @Query("""
             select s
             from ScheduleEntity s
             where s.user = :user
               and (s.departureTs is null or s.departureTs >= :from)
             order by s.arrivalTs asc
            """)
    List<ScheduleEntity> findFrom(
            @Param("user") UserEntity user,
            @Param("from") OffsetDateTime from
    );

    @Query("""
             select s
             from ScheduleEntity s
             where s.user = :user
               and s.arrivalTs <= :to
             order by s.arrivalTs asc
            """)
    List<ScheduleEntity> findUntil(
            @Param("user") UserEntity user,
            @Param("to") OffsetDateTime to
    );

    @Query("""
             select s
             from ScheduleEntity s
             where s.user = :user
               and s.arrivalTs <= :to
               and (s.departureTs is null or s.departureTs >= :from)
             order by s.arrivalTs asc
            """)
    List<ScheduleEntity> findOverlapping(
            @Param("user") UserEntity user,
            @Param("from") OffsetDateTime from,
            @Param("to") OffsetDateTime to
    );
}

