package eu.epitech.t_dev_700.models;

public class ReportModels {

    public record GlobalReportResponse(
            float WorkAverageWeekly,
            float WorkAverageMonthly,
            float PunctualityRate,
            float AttendanceRate
    ) {
    }

    public record TeamReportResponse(
            float WorkAverageWeekly,
            float WorkAverageMonthly,
            float PunctualityRate,
            float AttendanceRate

    ) {
    }

    public record UserReportResponse(
            float WorkAverageWeekly,
            float WorkAverageMonthly,
            float PunctualityRate,
            float AttendanceRate
    ) {
    }
}
