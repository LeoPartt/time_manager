package eu.epitech.t_dev_700.models;

import com.fasterxml.jackson.annotation.JsonFormat;
import eu.epitech.t_dev_700.entities.PlanningEntity;
import eu.epitech.t_dev_700.models.constraints.ValidTimeRange;
import eu.epitech.t_dev_700.models.groups.ExpectsUserId;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

import java.time.LocalTime;

public class PlanningModels {

    public interface Planning {

        PlanningEntity.WeekDay weekDay();

        LocalTime startTime();

        LocalTime endTime();

    }

    @Schema(description = "Planning information model")
    public record PlanningResponse(
            @Schema(description = "Unique planning entry identifier", example = "1")
            Long id,

            @Schema(description = "Unique identifier of the user that owns this entry", example = "1")
            Long userId,

            @Schema(description = "Day of week of this entry", example = "1")
            @JsonFormat(shape = JsonFormat.Shape.NUMBER)
            PlanningEntity.WeekDay weekDay,

            @Schema(description = "Start time of this entry", format = "Time", example = "09:30")
            @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HH:mm")
            LocalTime startTime,

            @Schema(description = "End time of this entry (must be after startTime)", format = "Time", example = "09:30")
            @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HH:mm")
            LocalTime endTime

    ) implements Planning, HasId {
    }

    @Schema(description = "Request body for creating a new planning entry")
    @ValidTimeRange
    public record PostPlanningRequest(

            @Schema(hidden = true)
            @NotNull(groups = ExpectsUserId.class)
            Long userId,

            @Schema(description = "Day of week of this entry", example = "1")
            @JsonFormat(shape = JsonFormat.Shape.NUMBER)
            @NotNull
            PlanningEntity.WeekDay weekDay,

            @Schema(description = "Start time of this entry", format = "Time", example = "09:30")
            @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HH:mm")
            @NotNull
            LocalTime startTime,

            @Schema(description = "End time of this entry (must be after startTime)", format = "Time", example = "09:30")
            @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HH:mm")
            @NotNull
            LocalTime endTime

    ) implements Planning {
        public PostPlanningRequest(Long id, PostPlanningRequest body) {
            this(id, body.weekDay(), body.startTime(), body.endTime());
        }
    }

    @Schema(description = "Request body for completely replacing a planning entry (PUT)")
    @ValidTimeRange
    public record PutPlanningRequest(
            @Schema(description = "Day of week of this entry", example = "1")
            @JsonFormat(shape = JsonFormat.Shape.NUMBER)
            @NotNull
            PlanningEntity.WeekDay weekDay,

            @Schema(description = "Start time of this entry", format = "Time", example = "09:30")
            @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HH:mm")
            @NotNull
            LocalTime startTime,

            @Schema(description = "End time of this entry (must be after startTime)", format = "Time", example = "09:30")
            @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HH:mm")
            @NotNull
            LocalTime endTime

    ) implements Planning {
    }

    @Schema(description = "Request body for partially updating a planning entry (PATCH)")
    @ValidTimeRange
    public record PatchPlanningRequest(
            @Schema(description = "Day of week of this entry", example = "1")
            @JsonFormat(shape = JsonFormat.Shape.NUMBER)
            PlanningEntity.WeekDay weekDay,

            @Schema(description = "Start time of this entry", format = "Time", example = "09:30")
            @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HH:mm")
            LocalTime startTime,

            @Schema(description = "End time of this entry (must be after startTime)", format = "Time", example = "09:30")
            @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HH:mm")
            LocalTime endTime

    ) implements Planning {
    }

}
