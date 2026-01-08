package eu.epitech.t_dev_700.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Check;

import java.time.LocalTime;
import java.util.Objects;

@Getter
@Setter
@Entity
@Table(name = "planning")
@Check(constraints = "end_time >= start_time")
public class PlanningEntity {

    @Id
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id")
    private UserEntity user;

    @Column(name = "day_of_week", nullable = false)
    @Enumerated(EnumType.ORDINAL)
    private WeekDay WeekDay;

    @Column(name = "start_time", columnDefinition = "TIME", nullable = false)
    private LocalTime StartTime;

    @Column(name = "end_time", columnDefinition = "TIME", nullable = false)
    private LocalTime EndTime;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof PlanningEntity that)) return false;
        return id != null && id.equals(that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id);
    }

    public enum WeekDay {
        MONDAY,
        TUESDAY,
        WEDNESDAY,
        THURSDAY,
        FRIDAY,
        SATURDAY,
        SUNDAY
    }
}
