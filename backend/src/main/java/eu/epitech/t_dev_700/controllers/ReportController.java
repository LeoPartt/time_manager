package eu.epitech.t_dev_700.controllers;

import eu.epitech.t_dev_700.doc.ApiErrorResponse;
import eu.epitech.t_dev_700.doc.ApiUnauthorizedResponse;
import eu.epitech.t_dev_700.models.ReportModels;
import eu.epitech.t_dev_700.services.ReportsService;
import eu.epitech.t_dev_700.services.exceptions.ResourceNotFound;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.OffsetDateTime;

@RestController
@RequestMapping("/reports")
@Tag(name = "Reports")
@ApiUnauthorizedResponse
@RequiredArgsConstructor
public class ReportController {

    private final ReportsService reportsService;

    @Operation(summary = "Get global dashboard (punctuality, attendance, work chart) for current week/month/year")
    @ApiResponse(responseCode = "200", useReturnTypeSchema = true)
    @ApiErrorResponse(ResourceNotFound.class)
    @PreAuthorize("@userAuth.isManager(authentication)")
    @GetMapping("/dashboard")
    public ResponseEntity<ReportModels.DashboardResponse> getGlobalDashboard(
            @RequestParam("mode") String mode,
            @RequestParam(value = "at", required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
            OffsetDateTime at
    ) {
        return ResponseEntity.ok(reportsService.getGlobalDashboard(ReportModels.Mode.fromQuery(mode), at));
    }

    @Operation(summary = "Get user dashboard (punctuality, attendance, work chart) for current week/month/year")
    @ApiResponse(responseCode = "200", useReturnTypeSchema = true)
    @ApiErrorResponse(ResourceNotFound.class)
    @PreAuthorize("@userAuth.isSelfOrManager(authentication, #id)")
    @GetMapping("/users/{id}/dashboard")
    public ResponseEntity<ReportModels.UserDashboardResponse> getUserDashboard(
            @PathVariable Long id,
            @RequestParam("mode") String mode,
            @RequestParam(value = "at", required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
            OffsetDateTime at
    ) {
        return ResponseEntity.ok(reportsService.getUserDashboard(id, ReportModels.Mode.fromQuery(mode), at));
    }

    @Operation(summary = "Get team dashboard (punctuality, attendance, work chart) for current week/month/year")
    @ApiResponse(responseCode = "200", useReturnTypeSchema = true)
    @ApiErrorResponse(ResourceNotFound.class)
    @PreAuthorize("@userAuth.isManagerOfTeam(authentication, #id)")
    @GetMapping("/teams/{id}/dashboard")
    public ResponseEntity<ReportModels.TeamDashboardResponse> getTeamDashboard(
            @PathVariable Long id,
            @RequestParam("mode") String mode,
            @RequestParam(value = "at", required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
            OffsetDateTime at
    ) {
        return ResponseEntity.ok(reportsService.getTeamDashboard(id, ReportModels.Mode.fromQuery(mode), at));
    }
}
