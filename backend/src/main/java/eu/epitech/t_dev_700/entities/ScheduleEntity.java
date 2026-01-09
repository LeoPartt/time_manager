package eu.epitech.t_dev_700.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Check;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.OffsetDateTime;

@Entity
@Getter
@Setter
@Table(name = "schedule",
        indexes = {
                @Index(name = "idx_schedule_user_arrival_ts", columnList = "user_id, arrival_ts"),
                @Index(name = "idx_schedule_arrival_ts", columnList = "arrival_ts"),
                @Index(name = "idx_schedule_departure_ts", columnList = "departure_ts")
        }
)
@Check(constraints = "departure_ts IS NULL OR departure_ts >= arrival_ts")
public class ScheduleEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private UserEntity user;

    @JdbcTypeCode(SqlTypes.TIMESTAMP_WITH_TIMEZONE)
    @Column(name = "arrival_ts", nullable = false)
    private OffsetDateTime arrivalTs;

    @JdbcTypeCode(SqlTypes.TIMESTAMP_WITH_TIMEZONE)
    @Column(name = "departure_ts")
    private OffsetDateTime departureTs;

    public ScheduleEntity() {}

    public ScheduleEntity(UserEntity user, OffsetDateTime arrivalTs) {
        this.user = user;
        this.arrivalTs = arrivalTs;
    }

}
