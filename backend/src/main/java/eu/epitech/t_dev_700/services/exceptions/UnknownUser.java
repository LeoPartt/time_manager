package eu.epitech.t_dev_700.services.exceptions;

import eu.epitech.t_dev_700.models.ErrorModels;
import eu.epitech.t_dev_700.utils.HasDetails;
import io.swagger.v3.oas.annotations.media.Schema;
import org.springframework.security.core.AuthenticationException;

@Schema(description = "Unknown user", example = "Unknown user")
public final class UnknownUser extends AuthenticationException implements HasDetails<ErrorModels.InvalidCredentialsDetail> {

    private final ErrorModels.InvalidCredentialsDetail details;

    public UnknownUser(String username) {
        super("Unknown user");
        this.details = new ErrorModels.InvalidCredentialsDetail(username);
    }

    @Override
    public ErrorModels.InvalidCredentialsDetail details() {
        return details;
    }
}
