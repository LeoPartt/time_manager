package eu.epitech.t_dev_700.controllers;

import eu.epitech.t_dev_700.doc.ApiUnauthorizedResponse;
import eu.epitech.t_dev_700.models.PlanningModels;
import eu.epitech.t_dev_700.models.groups.ExpectsUserId;
import eu.epitech.t_dev_700.services.PlanningService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/plannings")
@RequiredArgsConstructor
@Tag(name = "Plannings Management")
@ApiUnauthorizedResponse
public class PlanningController implements CRUDController<
        PlanningModels.PlanningResponse,
        PlanningModels.PostPlanningRequest,
        PlanningModels.PutPlanningRequest,
        PlanningModels.PatchPlanningRequest
        > {

    private final PlanningService planningService;

    @Override
    @Operation(summary = "Get planning at id")
    @PreAuthorize("@userAuth.isOwnerOrManagerOfOwner(authentication, #id)")
    @GetMapping("{id}")
    public ResponseEntity<PlanningModels.PlanningResponse> Get(@PathVariable("id") Long id) {
        return ResponseEntity.ok(planningService.get(id));
    }

    @Override
    @Operation(summary = "Get all plannings")
    @PreAuthorize("@userAuth.isAdmin(authentication)")
    @GetMapping
    public ResponseEntity<PlanningModels.PlanningResponse[]> GetAll() {
        return ResponseEntity.ok(planningService.list());
    }

    @Override
    @Operation(summary = "Create a planning")
    @PreAuthorize("@userAuth.isAdmin(authentication)")
    @PostMapping
    public ResponseEntity<PlanningModels.PlanningResponse> Post(@Valid @Validated(ExpectsUserId.class) @RequestBody PlanningModels.PostPlanningRequest body) {
        return this.created("plannings", planningService.create(body));
    }

    @Override
    @Operation(summary = "Modify an existing planning")
    @PreAuthorize("@userAuth.isManagerOfOwner(authentication, #id)")
    @PutMapping("{id}")
    public ResponseEntity<PlanningModels.PlanningResponse> Put(@PathVariable("id") Long id, @Valid @RequestBody PlanningModels.PutPlanningRequest body) {
        return ResponseEntity.ok(planningService.replace(id, body));
    }

    @Override
    @Operation(summary = "Update an existing planning")
    @PreAuthorize("@userAuth.isManagerOfOwner(authentication, #id)")
    @PatchMapping("{id}")
    public ResponseEntity<PlanningModels.PlanningResponse> Patch(@PathVariable("id") Long id, @Valid @RequestBody PlanningModels.PatchPlanningRequest body) {
        return ResponseEntity.ok(planningService.update(id, body));
    }

    @Override
    @Operation(summary = "Delete an existing planning")
    @PreAuthorize("@userAuth.isManagerOfOwner(authentication, #id)")
    @DeleteMapping("{id}")
    public ResponseEntity<Void> Delete(@PathVariable("id") Long id) {
        planningService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
