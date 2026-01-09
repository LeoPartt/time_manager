package eu.epitech.t_dev_700.models;

import eu.epitech.t_dev_700.models.constraints.ValidScheduleQuery;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

import java.time.OffsetDateTime;

@Setter
@Getter
@ValidScheduleQuery
@Schema(description = "Query parameters for filtering schedules")
public class UserScheduleQuery {

    @Schema(
            description = "Start date (ISO-8601). " + "Cannot be used with `current`.",
            example = "2024-01-15T10:30:00Z"
    )
    private OffsetDateTime from;

    @Schema(
            description = "End date (ISO-8601). " + "Cannot be used with `current`.",
            example = "2024-01-15T10:30:00Z"
    )
    private OffsetDateTime to;

    @Schema(
            description = "If true, returns only current schedules. " + "Cannot be combined with `from` or `to`.",
            defaultValue = "false",
            example = "true"
    )
    private Boolean current = false;

    public boolean isCurrent() {
        return Boolean.TRUE.equals(current);
    }
}
