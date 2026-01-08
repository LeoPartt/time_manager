package eu.epitech.t_dev_700.models.constraints;

import eu.epitech.t_dev_700.models.PlanningModels;
import jakarta.validation.Constraint;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import jakarta.validation.Payload;

import java.lang.annotation.*;
import java.time.LocalTime;

@Documented
@Constraint(validatedBy = ValidTimeRange.TimeRangeValidator.class)
@Target({ ElementType.TYPE })
@Retention(RetentionPolicy.RUNTIME)
public @interface ValidTimeRange {
    String message() default "Invalid time range: startTime must be before endTime";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};

    class TimeRangeValidator implements ConstraintValidator<ValidTimeRange, PlanningModels.Planning> {

        @Override
        public boolean isValid(PlanningModels.Planning dto, ConstraintValidatorContext context) {
            if (dto == null) return true; // nothing to validate

            LocalTime start = dto.startTime();
            LocalTime end = dto.endTime();

            if (start == null || end == null)
                return true; // leave @NotNull to handle missing fields

            if (end.isBefore(start) || end.equals(start)) {
                context.disableDefaultConstraintViolation();
                context.buildConstraintViolationWithTemplate(
                        "endTime must be after startTime"
                ).addConstraintViolation();
                return false;
            }

            // Optional: enforce working hours, e.g. 06:00–22:00
            LocalTime min = LocalTime.of(6, 0);
            LocalTime max = LocalTime.of(22, 0);
            if (start.isBefore(min) || end.isAfter(max)) {
                context.disableDefaultConstraintViolation();
                context.buildConstraintViolationWithTemplate(
                        "Time range must be within working hours (06:00–22:00)"
                ).addConstraintViolation();
                return false;
            }

            return true;
        }
    }


}
