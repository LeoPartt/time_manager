package eu.epitech.t_dev_700.config;

import eu.epitech.t_dev_700.models.ErrorModels;
import io.jsonwebtoken.*;
import io.jsonwebtoken.io.DecodingException;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.ConstraintViolationException;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.http.*;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.ServletWebRequest;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import java.util.NoSuchElementException;
import java.util.Optional;
import java.util.stream.Collectors;

@RestControllerAdvice
@Order(Ordered.HIGHEST_PRECEDENCE)
public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {

    @Override
    protected ResponseEntity<Object> handleMethodArgumentNotValid(
            MethodArgumentNotValidException ex,
            HttpHeaders headers,
            HttpStatusCode status,
            WebRequest request) {
        return new ErrorModels.ErrorResponse(
                HttpStatus.UNPROCESSABLE_ENTITY,
                "Validation failed",
                request,
                ex.getBindingResult()
                        .getFieldErrors()
                        .stream()
                        .collect(Collectors.toMap(
                                FieldError::getField,
                                e -> Optional.ofNullable(e.getDefaultMessage()).orElse("")
                        ))).toResponse();
    }

    @Override
    protected ResponseEntity<Object> handleHttpMessageNotReadable(
            HttpMessageNotReadableException ex,
            HttpHeaders headers,
            HttpStatusCode status,
            WebRequest request) {
        return new ErrorModels.ErrorResponse(HttpStatus.BAD_REQUEST, "Malformed JSON body", request).toResponse();
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<Object> handleConstraintViolation(ConstraintViolationException ex, WebRequest request) {
        return new ErrorModels.ErrorResponse(
                HttpStatus.UNPROCESSABLE_ENTITY,
                "Validation failed",
                request,
                ex.getConstraintViolations().stream()
                        .collect(Collectors.toMap(
                                v -> v.getPropertyPath().toString(),
                                v -> Optional.ofNullable(v.getMessage()).orElse("")
                        ))
        ).toResponse();
    }

    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<Object> handleConflict(IllegalStateException ex, WebRequest request) {
        return new ErrorModels.ErrorResponse(HttpStatus.CONFLICT, ex, request).toResponse();
    }

    @ExceptionHandler({EntityNotFoundException.class, NoSuchElementException.class})
    public ResponseEntity<Object> handleNotFound(RuntimeException ex, WebRequest request) {
        return new ErrorModels.ErrorResponse(HttpStatus.NOT_FOUND, ex, request).toResponse();
    }

    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<Object> AuthenticationException(AuthenticationException ex, WebRequest request) {
        return new ErrorModels.ErrorResponse(HttpStatus.UNAUTHORIZED, ex, request).toResponse();
    }

    @ExceptionHandler(JwtException.class)
    public ResponseEntity<Object> MalformedJwtTokenException(JwtException ex, WebRequest request) {
        return (switch (ex) {
            case ExpiredJwtException ignored -> new ErrorModels.ErrorResponse(HttpStatus.UNAUTHORIZED, "Token expired", request);
            case PrematureJwtException ignored ->
                    new ErrorModels.ErrorResponse(HttpStatus.UNAUTHORIZED, "Token not active yet", request);
            case MalformedJwtException ignored ->
                    new ErrorModels.ErrorResponse(HttpStatus.BAD_REQUEST, "Invalid token format", request);
            case DecodingException ignored -> new ErrorModels.ErrorResponse(HttpStatus.BAD_REQUEST, "Invalid token format", request);
            case InvalidClaimException ignored ->
                    new ErrorModels.ErrorResponse(HttpStatus.UNAUTHORIZED, "Invalid token claims", request);
            default -> new ErrorModels.ErrorResponse(HttpStatus.UNAUTHORIZED, "Invalid or unauthorized token", request);
        }).toResponse();
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<Object> handleUnexpected(AccessDeniedException ex, WebRequest request) {
        return new ErrorModels.ErrorResponse(
                HttpStatus.FORBIDDEN,
                (((ServletWebRequest) request).getHttpMethod() == HttpMethod.GET)
                        ? "You are not allowed to access this resource"
                        : "You are not allowed to perform this action",
                request).toResponse();
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Object> handleUnexpected(Exception ex, WebRequest request) {
        return new ErrorModels.ErrorResponse(HttpStatus.INTERNAL_SERVER_ERROR, "An unexpected error occurred", request, ex).toResponse();
    }
}
