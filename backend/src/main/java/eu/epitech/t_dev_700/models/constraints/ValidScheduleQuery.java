package eu.epitech.t_dev_700.models.constraints;

import eu.epitech.t_dev_700.models.UserScheduleQuery;
import jakarta.validation.Constraint;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import jakarta.validation.Payload;

import java.lang.annotation.*;

@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = ValidScheduleQuery.ScheduleQueryValidator.class)
@Documented
public @interface ValidScheduleQuery {
    String message() default "`current` cannot be combined with `from` or `to`";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};

    class ScheduleQueryValidator implements ConstraintValidator<ValidScheduleQuery, UserScheduleQuery> {

        @Override
        public boolean isValid(UserScheduleQuery value, ConstraintValidatorContext context) {
            if (value == null) return true;

            boolean current = Boolean.TRUE.equals(value.getCurrent());
            boolean hasRange = value.getFrom() != null || value.getTo() != null;

            if (current && hasRange) {
                context.disableDefaultConstraintViolation();
                context.buildConstraintViolationWithTemplate(
                        "`current` cannot be combined with `from` or `to`"
                ).addPropertyNode("current").addConstraintViolation();
                return false;
            }
            return true;
        }
    }

}