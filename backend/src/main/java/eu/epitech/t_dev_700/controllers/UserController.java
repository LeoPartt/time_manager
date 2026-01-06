package eu.epitech.t_dev_700.controllers;

import eu.epitech.t_dev_700.doc.ApiUnauthorizedResponse;
import eu.epitech.t_dev_700.models.PlanningModels;
import eu.epitech.t_dev_700.models.TeamModels;
import eu.epitech.t_dev_700.models.UserModels;
import eu.epitech.t_dev_700.models.UserScheduleQuery;
import eu.epitech.t_dev_700.services.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import jakarta.validation.Valid;
import jakarta.validation.Validator;
import lombok.RequiredArgsConstructor;
import org.springdoc.core.annotations.ParameterObject;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Set;

@RestController
@RequestMapping("/users")
@Tag(name = "User Management")
@ApiUnauthorizedResponse
@RequiredArgsConstructor
public class UserController implements CRUDController<
        UserModels.UserResponse,
        UserModels.PostUserRequest,
        UserModels.PutUserRequest,
        UserModels.PatchUserRequest
        > {
    private final Validator validator;
    private final UserService userService;

    @Override
    @Operation(summary = "Get user at id")
    @PreAuthorize("@userAuth.isSelfOrManager(authentication, #id)")
    @GetMapping("{id}")
    public ResponseEntity<UserModels.UserResponse> Get(@PathVariable("id") Long id) {
        return ResponseEntity.ok(userService.get(id));
    }

    @Override
    @Operation(summary = "Get all users")
    @PreAuthorize("@userAuth.isManager(authentication)")
    @GetMapping
    public ResponseEntity<UserModels.UserResponse[]> GetAll() {
        return ResponseEntity.ok(userService.list());
    }

    @Override
    @Operation(summary = "Create a user")
    @PreAuthorize("@userAuth.isManager(authentication)")
    @PostMapping
    public ResponseEntity<UserModels.UserResponse> Post(@Valid @RequestBody UserModels.PostUserRequest body) {
        return this.created("users", userService.create(body));
    }

    @Override
    @Operation(summary = "Modify an existing user")
    @PreAuthorize("@userAuth.isSelfOrManagerOfUser(authentication, #id)")
    @PutMapping("{id}")
    public ResponseEntity<UserModels.UserResponse> Put(@PathVariable Long id, @Valid @RequestBody UserModels.PutUserRequest body) {
        return ResponseEntity.ok(userService.replace(id, body));
    }

    @Override
    @Operation(summary = "Update an existing user")
    @PreAuthorize("@userAuth.isSelfOrManagerOfUser(authentication, #id)")
    @PatchMapping("{id}")
    public ResponseEntity<UserModels.UserResponse> Patch(@PathVariable Long id, @Valid @RequestBody UserModels.PatchUserRequest body) {
        return ResponseEntity.ok(userService.update(id, body));
    }

    @Override
    @Operation(summary = "Delete an existing user")
    @PreAuthorize("@userAuth.isSelfOrManagerOfUser(authentication, #id)")
    @DeleteMapping("{id}")
    public ResponseEntity<Void> Delete(@PathVariable Long id) {
        userService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "Get current authenticated user")
    @ApiResponse(responseCode = "200", useReturnTypeSchema = true)
    @GetMapping("/me")
    public UserModels.UserResponse getMe() {
        return userService.getCurrentUser();
    }

    @Operation(summary = "Get user's clock records")
    @PreAuthorize("@userAuth.isSelfOrManagerOfUser(authentication, #id)")
    @GetMapping("{id}/clocks")
    public ResponseEntity<Long[]> getUserClocks(
            @Valid @ParameterObject @ModelAttribute UserScheduleQuery query,
            @PathVariable Long id) {
        return ResponseEntity.ok(this.userService.getClocks(id, query));
    }

    @Operation(summary = "Get user's teams")
    @GetMapping("{id}/teams")
    public ResponseEntity<TeamModels.TeamResponse[]> getTeams(@PathVariable Long id) {
        return ResponseEntity.ok(userService.getTeams(id));
    }

    @Operation(summary = "Get user's plannings")
    @PreAuthorize("@userAuth.isSelfOrManagerOfUser(authentication, #id)")
    @GetMapping("{id}/plannings")
    public ResponseEntity<PlanningModels.PlanningResponse[]> getPlannings(@PathVariable Long id) {
        return ResponseEntity.ok(userService.getPlannings(id));
    }

    @Operation(summary = "Create a user's planning")
    @PreAuthorize("@userAuth.isManagerOfUser(authentication, #id)")
    @PostMapping("{id}/plannings")
    public ResponseEntity<PlanningModels.PlanningResponse> postPlanning(@PathVariable Long id, @RequestBody PlanningModels.PostPlanningRequest body) {
        PlanningModels.PostPlanningRequest fullBody = setPlanningBodyIdAndValidate(id, body);
        return created("users/%d/plannings".formatted(id), userService.createPlanning(fullBody));
    }

    private PlanningModels.PostPlanningRequest setPlanningBodyIdAndValidate(Long id, PlanningModels.PostPlanningRequest body) {
        PlanningModels.PostPlanningRequest fullBody = new PlanningModels.PostPlanningRequest(id, body);
        Set<ConstraintViolation<PlanningModels.PostPlanningRequest>> violations = validator.validate(fullBody);
        if (!violations.isEmpty()) throw new ConstraintViolationException(violations);
        return fullBody;
    }

}
