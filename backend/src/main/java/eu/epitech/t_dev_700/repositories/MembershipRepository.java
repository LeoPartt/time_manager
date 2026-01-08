package eu.epitech.t_dev_700.repositories;

import eu.epitech.t_dev_700.entities.MembershipEntity;
import eu.epitech.t_dev_700.entities.TeamEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MembershipRepository extends JpaRepository<MembershipEntity, Long> {

    List<MembershipEntity> findByUser(UserEntity user);

    List<MembershipEntity> findByTeam(TeamEntity team);

    Optional<MembershipEntity> findByTeamAndUser(TeamEntity team, UserEntity user);

    Optional<MembershipEntity> findByTeamAndRole(TeamEntity team, MembershipEntity.TeamRole role);

    boolean existsByUserAndTeam_Id(UserEntity user, Long team_id);

    boolean existsByUserAndTeam_IdAndRole(UserEntity currentUser, Long teamId, MembershipEntity.TeamRole role);

    boolean existsByUserAndRole(UserEntity user, MembershipEntity.TeamRole role);

    @Query(value="select * from membership where id = :id", nativeQuery=true)
    Optional<MembershipEntity> findByIdIncludeDeleted(@Param("id") long id);


    @Query(value="select * from membership where team_id = :teamId and user_id = :userId", nativeQuery=true)
    Optional<MembershipEntity> findByTeamIdAndUserIdIncludeDeleted(@Param("userId") long userId, @Param("teamId") long teamId);

    @Query("""
    select (count(mA) > 0)
    from MembershipEntity mA
    join MembershipEntity mB on mB.team = mA.team
    where mA.user.id = :userId
      and mB.user = :other
      and mB.role = eu.epitech.t_dev_700.entities.MembershipEntity.TeamRole.MANAGER
""")
    boolean existsMembershipOfUserIdOnTeamsManagedByOther(
            @Param("userId") Long userId,
            @Param("other") UserEntity other
    );
}