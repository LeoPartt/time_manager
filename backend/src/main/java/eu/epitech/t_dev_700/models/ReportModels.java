package eu.epitech.t_dev_700.models;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

public class ReportModels {

    @Schema(description = "A report object with values per week, month and year")
    public record Report(
            @Schema(description = "Weekly value", example = "0.5")
            @NotNull float weekly,

            @Schema(description = "Monthly value", example = "0.5")
            @NotNull float monthly,

            @Schema(description = "Yearly value", example = "0.5")
            @NotNull float yearly
    ) {
        public static final Report EMPTY = new Report(0f, 0f, 0f);
    }

    @Schema(description = "Reports for the whole company")
    public record GlobalReportResponse(

            @Schema(description = "Work time averages")
            @NotNull Report WorkAverages,

            @Schema(description = "Punctuality rates")
            @NotNull Report PunctualityRates,

            @Schema(description = "Attendance rates")
            @NotNull Report AttendanceRates
    ) {
    }

    @Schema(description = "Reports for a team")
    public record TeamReportResponse(

            @Schema(description = "Team's id", example = "1")
            @NotNull long teamId,

            @Schema(description = "Work time averages")
            @NotNull Report WorkAverages,

            @Schema(description = "Punctuality rates")
            @NotNull Report PunctualityRates,

            @Schema(description = "Attendance rates")
            @NotNull Report AttendanceRates

    ) {
    }

    @Schema(description = "Reports for a user")
    public record UserReportResponse(

            @Schema(description = "User's id", example = "1")
            @NotNull long userId,

            @Schema(description = "Work time averages")
            @NotNull Report WorkAverages,

            @Schema(description = "Punctuality rates")
            @NotNull Report PunctualityRates,

            @Schema(description = "Attendance rates")
            @NotNull Report AttendanceRates
    ) {
    }
}
