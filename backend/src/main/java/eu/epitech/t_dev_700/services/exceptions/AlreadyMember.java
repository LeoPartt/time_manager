package eu.epitech.t_dev_700.services.exceptions;

import eu.epitech.t_dev_700.models.ErrorModels;
import eu.epitech.t_dev_700.utils.HasDetails;
import io.swagger.v3.oas.annotations.media.Schema;

@Schema(example = "User #0 is already a member of team #0")
public final class AlreadyMember extends IllegalStateException implements Runnable, HasDetails<ErrorModels.AlreadyMemberDetail> {

    private final ErrorModels.AlreadyMemberDetail details;

    public AlreadyMember(Long userId, Long teamId) {
        super("User #%d is already a member of team #%d".formatted(userId, teamId));
        this.details = new ErrorModels.AlreadyMemberDetail(userId, teamId);
    }

    @Override
    public void run() {
        throw this;
    }

    @Override
    public ErrorModels.AlreadyMemberDetail details() {
        return details;
    }
}
