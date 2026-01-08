package eu.epitech.t_dev_700.models;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

import java.time.OffsetDateTime;
import java.util.List;

public class ReportModels {

    public enum Mode {
        W, M, Y;

        public static Mode fromQuery(String value) {
            if (value == null) throw new IllegalArgumentException("Missing required query param 'mode' (w|m|y)");
            return switch (value.toLowerCase()) {
                case "w" -> W;
                case "m" -> M;
                case "y" -> Y;
                default -> throw new IllegalArgumentException("Invalid mode '" + value + "' (expected w|m|y)");
            };
        }
    }

    public enum WorkBucket {
        DAY, WEEK, MONTH
    }

    @Schema(description = "Resolved date range for the dashboard period (from inclusive, to exclusive)")
    public record DateRange(
            @Schema(description = "Start of the period (inclusive)")
            @NotNull OffsetDateTime from,

            @Schema(description = "End of the period (exclusive)")
            @NotNull OffsetDateTime to
    ) { }

    @Schema(description = "A single KPI value represented as a percentage [0..100]")
    public record PercentKpi(
            @Schema(description = "Value in percent", example = "92.3")
            @NotNull float percent
    ) {
        public static final PercentKpi ZERO = new PercentKpi(0f);
    }

    @Schema(description = "One point in a work time series")
    public record WorkPoint(
            @Schema(description = "Bucket label suitable for display", example = "Mon / W2 / Jan")
            @NotNull String label,

            @Schema(description = "Bucket start time (inclusive)")
            @NotNull OffsetDateTime start,

            @Schema(description = "Worked hours for this bucket", example = "7.5")
            @NotNull float value
    ) { }

    @Schema(description = "Work time series for the selected mode")
    public record WorkSeries(
            @Schema(description = "Unit of the series values", example = "hours")
            @NotNull String unit,

            @Schema(description = "Bucket type used for the series")
            @NotNull WorkBucket bucket,

            @Schema(description = "Series points")
            @NotNull List<WorkPoint> series,

            @Schema(
                    description = """
                Average worked hours over the selected period.
                - week  → average hours per worked day
                - month → average hours per worked week
                - year  → average hours per worked month
                """,
                    example = "7.6"
            )
            @NotNull float average
    ) {
        public static WorkSeries empty(WorkBucket bucket) {
            return new WorkSeries("hours", bucket, List.of(), 0f);
        }
    }

    @Schema(description = "Dashboard response matching the three frontend widgets")
    public record DashboardResponse(
            @Schema(description = "Selected mode (w/m/y)")
            @NotNull Mode mode,

            @Schema(description = "Resolved range for the selected mode")
            @NotNull DateRange range,

            @Schema(description = "Punctuality computed on the current period")
            @NotNull PercentKpi punctuality,

            @Schema(description = "Attendance computed on the current period")
            @NotNull PercentKpi attendance,

            @Schema(description = "Work chart data computed on the current period")
            @NotNull WorkSeries work
    ) { }

    @Schema(description = "Dashboard response for a team")
    public record TeamDashboardResponse(
            @Schema(description = "Team id", example = "1")
            @NotNull long teamId,

            @NotNull DashboardResponse dashboard
    ) { }

    @Schema(description = "Dashboard response for a user")
    public record UserDashboardResponse(
            @Schema(description = "User id", example = "1")
            @NotNull long userId,

            @NotNull DashboardResponse dashboard
    ) { }
}
