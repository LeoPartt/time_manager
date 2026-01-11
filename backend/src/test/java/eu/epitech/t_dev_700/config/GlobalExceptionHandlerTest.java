package eu.epitech.t_dev_700.config;

import eu.epitech.t_dev_700.models.ErrorModels;
import io.jsonwebtoken.*;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import jakarta.validation.Path;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.context.request.ServletWebRequest;

import java.util.NoSuchElementException;
import java.util.Optional;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;

class GlobalExceptionHandlerTest {

    private GlobalExceptionHandler handler;

    @BeforeEach
    void setUp() {
        handler = new GlobalExceptionHandler();
    }

    private static ServletWebRequest req(String method, String uri) {
        MockHttpServletRequest r = new MockHttpServletRequest(method, uri);
        return new ServletWebRequest(r);
    }

    @SuppressWarnings("unchecked")
    private static ErrorModels.ErrorResponse bodyOf(Object responseEntityBody) {
        // If your toResponse() returns ResponseEntity<Object> with body = ErrorResponse:
        return (ErrorModels.ErrorResponse) responseEntityBody;
    }

    @Test
    void handleHttpMessageNotReadable_400() {
        var request = req("POST", "/readable");
        var ex = new HttpMessageNotReadableException("bad json");

        var re = handler.handleHttpMessageNotReadable(ex, new HttpHeaders(), HttpStatus.BAD_REQUEST, request);

        assertThat(re.getStatusCode().value()).isEqualTo(400);
        var body = bodyOf(re.getBody());
        assertThat(body.status()).isEqualTo(400);
        assertThat(body.detail()).isEqualTo("Malformed JSON body");
        assertThat(body.instance()).isEqualTo("/readable");
    }

    @Test
    void handleMethodArgumentNotValid_422_multipleFieldErrors() throws Exception {
        var request = req("POST", "/validate-body");

        // Build a BindingResult with 2 field errors to cover the stream + map collector
        Object target = new Object();
        var br = new BeanPropertyBindingResult(target, "target");
        br.addError(new FieldError("target", "name", "must not be blank"));
        br.addError(new FieldError("target", "email", "must be a well-formed email address"));

        // MethodArgumentNotValidException needs a MethodParameter; easiest is Mockito mock
        var mp = Mockito.mock(org.springframework.core.MethodParameter.class);
        var ex = new MethodArgumentNotValidException(mp, br);

        var re = handler.handleMethodArgumentNotValid(ex, new HttpHeaders(), HttpStatus.UNPROCESSABLE_ENTITY, request);

        assertThat(re.getStatusCode().value()).isEqualTo(422);
        var body = bodyOf(re.getBody());
        assertThat(body.detail()).isEqualTo("Validation failed");
        assertThat(body.instance()).isEqualTo("/validate-body");

        // Details should contain both keys
        assertThat((java.util.Map<String, Object>) body.details())
                .containsKeys("name", "email");
    }

    @Test
    void handleConstraintViolation_422() {
        var request = req("GET", "/constraint");

        Path path = Mockito.mock(Path.class);
        Mockito.when(path.toString()).thenReturn("field");

        @SuppressWarnings("unchecked")
        ConstraintViolation<Object> v = (ConstraintViolation<Object>) Mockito.mock(ConstraintViolation.class);
        Mockito.when(v.getPropertyPath()).thenReturn(path);
        Mockito.when(v.getMessage()).thenReturn(Optional.of("must not be blank").orElse(""));

        var ex = new ConstraintViolationException(Set.of(v));

        var re = handler.handleConstraintViolation(ex, request);

        assertThat(re.getStatusCode().value()).isEqualTo(422);
        var body = bodyOf(re.getBody());
        assertThat(body.detail()).isEqualTo("Validation failed");
        assertThat(((java.util.Map<String, Object>) body.details()).get("field")).isEqualTo("must not be blank");
    }

    @Test
    void handleConflict_409() {
        var request = req("GET", "/conflict");
        var re = handler.handleConflict(new IllegalStateException("conflict happened"), request);

        assertThat(re.getStatusCode().value()).isEqualTo(409);
        var body = bodyOf(re.getBody());
        assertThat(body.detail()).isEqualTo("conflict happened");
    }

    @Test
    void handleNotFound_404_entityNotFound_and_noSuchElement() {
        var request = req("GET", "/x");

        var re1 = handler.handleNotFound(new EntityNotFoundException("missing entity"), request);
        assertThat(re1.getStatusCode().value()).isEqualTo(404);
        assertThat(bodyOf(re1.getBody()).detail()).isEqualTo("missing entity");

        var re2 = handler.handleNotFound(new NoSuchElementException("no element"), request);
        assertThat(re2.getStatusCode().value()).isEqualTo(404);
        assertThat(bodyOf(re2.getBody()).detail()).isEqualTo("no element");
    }

    // ---- JWT switch coverage: hit every branch
    @Test
    void jwtException_branches() {
        var request = req("GET", "/jwt");

        assertThat(bodyOf(handler.MalformedJwtTokenException(
                new ExpiredJwtException(null, null, "expired"), request).getBody()).detail())
                .isEqualTo("Token expired");

        assertThat(bodyOf(handler.MalformedJwtTokenException(
                new PrematureJwtException(null, null, "premature"), request).getBody()).detail())
                .isEqualTo("Token not active yet");

        assertThat(bodyOf(handler.MalformedJwtTokenException(
                new MalformedJwtException("malformed"), request).getBody()).detail())
                .isEqualTo("Invalid token format");

        // If you use JJWT DecodingException (package io.jsonwebtoken.io)
        assertThat(bodyOf(handler.MalformedJwtTokenException(
                new io.jsonwebtoken.io.DecodingException("decoding"), request).getBody()).detail())
                .isEqualTo("Invalid token format");

        // InvalidClaimException has protected ctor => subclass
        class TestInvalidClaimException extends InvalidClaimException {
            public TestInvalidClaimException(Header header, Claims claims, String message) {
                super(header, claims, message);
            }
        }
        assertThat(bodyOf(handler.MalformedJwtTokenException(
                new TestInvalidClaimException(null, null, "invalid claim"), request).getBody()).detail())
                .isEqualTo("Invalid token claims");

        assertThat(bodyOf(handler.MalformedJwtTokenException(
                new UnsupportedJwtException("unsupported"), request).getBody()).detail())
                .isEqualTo("Invalid or unauthorized token");
    }

    @Test
    void accessDenied_GET_vs_write() {
        var getReq = req("GET", "/denied-get");
        var postReq = req("POST", "/denied-post");

        var r1 = handler.handleUnexpected(new org.springframework.security.access.AccessDeniedException("nope"), getReq);
        assertThat(r1.getStatusCode().value()).isEqualTo(403);
        assertThat(bodyOf(r1.getBody()).detail()).isEqualTo("You are not allowed to access this resource");

        var r2 = handler.handleUnexpected(new org.springframework.security.access.AccessDeniedException("nope"), postReq);
        assertThat(r2.getStatusCode().value()).isEqualTo(403);
        assertThat(bodyOf(r2.getBody()).detail()).isEqualTo("You are not allowed to perform this action");
    }

    @Test
    void handleUnexpected_500() {
        var request = req("GET", "/boom");
        var re = handler.handleUnexpected(new RuntimeException("boom"), request);

        assertThat(re.getStatusCode().value()).isEqualTo(500);
        var body = bodyOf(re.getBody());
        assertThat(body.detail()).isEqualTo("An unexpected error occurred");

        var details = (java.util.Map<String, Object>) body.details();
        assertThat(details).containsKey("type");
        assertThat(details.get("message")).isEqualTo("boom");
    }

    @Test
    void authenticationException_shouldReturn401() {
        GlobalExceptionHandler handler = new GlobalExceptionHandler();

        var request = new ServletWebRequest(new MockHttpServletRequest("GET", "/auth"));
        var ex = new BadCredentialsException("bad creds");

        var re = handler.AuthenticationException(ex, request);

        assertThat(re.getStatusCode().value()).isEqualTo(401);

        // if your ResponseEntity body is ErrorModels.ErrorResponse:
        var body = (ErrorModels.ErrorResponse) re.getBody();
        assertThat(body.status()).isEqualTo(401);
        assertThat(body.detail()).isEqualTo("bad creds");
        assertThat(body.instance()).isEqualTo("/auth");
    }
}
