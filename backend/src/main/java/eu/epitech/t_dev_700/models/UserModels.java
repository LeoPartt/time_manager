package eu.epitech.t_dev_700.models;

import eu.epitech.t_dev_700.models.constraints.NullableNotBlank;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class UserModels {

    public interface User {
        String username();

        String firstName();

        String lastName();

        String email();

        String phoneNumber();
    }

    @Schema(description = "User information model")
    public record UserResponse(
            @Schema(description = "Unique user identifier", example = "1")
            Long id,

            @Schema(description = "Username for authentication", example = "john.doe")
            String username,

            @Schema(description = "User's first name", example = "John")
            String firstName,

            @Schema(description = "User's last name", example = "Doe")
            String lastName,

            @Schema(description = "User's email address", example = "john.doe@example.com")
            String email,

            @Schema(description = "User's phone number", example = "+1234567890")
            String phoneNumber,

            @Schema(description = "Whether the user is manager of at least one team", example = "true")
            boolean isManager,

            @Schema(description = "Whether the user is an administrator", example = "true")
            boolean isAdministrator
    ) implements User, HasId {
    }

    @Schema(description = "Request body for creating a new user")
    public record PostUserRequest(
            @Schema(description = "Username for the new user", example = "john.doe")
            @NotBlank String username,

            @Schema(description = "Password for the new user", example = "SecurePass123!")
            @NotBlank String password,

            @Schema(description = "First name of the user", example = "John")
            @NotBlank String firstName,

            @Schema(description = "Last name of the user", example = "Doe")
            @NotBlank String lastName,

            @Schema(description = "Email address of the user", example = "john.doe@example.com")
            @NotBlank @Email String email,

            @Schema(description = "Phone number of the user", example = "+1234567890")
            @NotNull String phoneNumber
    ) implements User {
    }

    @Schema(description = "Request body for completely replacing a user (PUT)")
    public record PutUserRequest(
            @Schema(description = "Username", example = "john.doe")
            @NotBlank String username,

            @Schema(description = "First name", example = "John")
            @NotBlank String firstName,

            @Schema(description = "Last name", example = "Doe")
            @NotBlank String lastName,

            @Schema(description = "Email address", example = "john.doe@example.com")
            @NotBlank String email,

            @Schema(description = "Phone number", example = "+1234567890")
            @NotNull String phoneNumber
    ) implements User {
    }

    @Schema(description = "Request body for partially updating a user (PATCH)")
    public record PatchUserRequest(
            @Schema(description = "Username (optional)", example = "john.doe")
            @NullableNotBlank String username,

            @Schema(description = "First name (optional)", example = "John")
            @NullableNotBlank String firstName,

            @Schema(description = "Last name (optional)", example = "Doe")
            @NullableNotBlank String lastName,

            @Schema(description = "Email address (optional)", example = "john.doe@example.com")
            String email,

            @Schema(description = "Phone number (optional)", example = "+1234567890")
            String phoneNumber
    ) implements User {
    }

}
