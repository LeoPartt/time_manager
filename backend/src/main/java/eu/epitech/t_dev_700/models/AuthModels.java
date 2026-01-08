package eu.epitech.t_dev_700.models;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

public class AuthModels {

    @Schema(description = "User login credentials")
    public record LoginRequest(
            @Schema(description = "Username for authentication", example = "john.doe")
            @NotNull String username,

            @Schema(description = "User password", example = "SecurePass123!")
            @NotNull String password
    ) {}

    @Schema(description = "User login credentials")
    public record ChangeRequest(
            @Schema(description = "Reset personal code", example = "A0x1Q3")
            @NotNull String code,

            @Schema(description = "User's new password", example = "SecurePass123!")
            @NotNull String password
    ) {}

    @Schema(description = "Authentication response containing JWT token")
    public record LoginResponse(
            @Schema(description = "JWT bearer token for API authentication", example = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...")
            String token,

            @Schema(description = "Token expiration time in milliseconds", example = "3600000")
            long expiresIn
    ) {}

}
