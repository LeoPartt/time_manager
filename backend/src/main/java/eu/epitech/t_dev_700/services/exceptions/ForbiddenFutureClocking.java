package eu.epitech.t_dev_700.services.exceptions;

import eu.epitech.t_dev_700.models.ErrorModels;
import eu.epitech.t_dev_700.utils.HasDetails;
import io.swagger.v3.oas.annotations.media.Schema;

import java.time.OffsetDateTime;
import java.util.function.Consumer;

@Schema(example = "Forbidden future clocking")
public final class ForbiddenFutureClocking extends IllegalStateException implements Consumer<Object>, Runnable, HasDetails<ErrorModels.ForbiddenFutureClockingDetail> {

    private final ErrorModels.ForbiddenFutureClockingDetail details;

    public ForbiddenFutureClocking(OffsetDateTime dateTime) {
        super("Forbidden future clocking");
        this.details = new ErrorModels.ForbiddenFutureClockingDetail(dateTime);
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
    public ErrorModels.ForbiddenFutureClockingDetail details() {
        return details;
    }
}
