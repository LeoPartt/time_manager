package eu.epitech.t_dev_700.services.exceptions;

import eu.epitech.t_dev_700.models.ClockModels;
import eu.epitech.t_dev_700.models.ErrorModels;
import eu.epitech.t_dev_700.utils.HasDetails;
import io.swagger.v3.oas.annotations.media.Schema;

import java.util.function.Consumer;

@Schema(example = "Invalid clocking action")
public final class InvalidClockingAction extends IllegalStateException implements Consumer<Object>, Runnable, HasDetails<ErrorModels.InvalidClockingActionDetail> {

    private final ErrorModels.InvalidClockingActionDetail details;

    public InvalidClockingAction(ClockModels.ClockAction expectedAction) {
        super("Invalid clocking action");
        this.details = new ErrorModels.InvalidClockingActionDetail(expectedAction);
    }

    @Override
    public void accept(Object o) {
        throw this;
    }

    @Override
    public void run() {
        throw this;
    }

    @Override
    public ErrorModels.InvalidClockingActionDetail details() {
        return details;
    }
}
