package eu.epitech.t_dev_700.models.constraints;

import eu.epitech.t_dev_700.config.GlobalExceptionHandler;
import eu.epitech.t_dev_700.config.filters.JwtAuthenticationFilter;
import eu.epitech.t_dev_700.controllers.UserController;
import eu.epitech.t_dev_700.models.PlanningModels;
import eu.epitech.t_dev_700.services.ClockService;
import eu.epitech.t_dev_700.services.TeamService;
import eu.epitech.t_dev_700.services.UserService;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.Path;
import jakarta.validation.Validator;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.FilterType;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Set;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(
        controllers = UserController.class,
        excludeFilters = @ComponentScan.Filter(
                type = FilterType.ASSIGNABLE_TYPE,
                classes = JwtAuthenticationFilter.class
        )
)
@ActiveProfiles("test")
@AutoConfigureMockMvc(addFilters = false)
@Import(GlobalExceptionHandler.class)
class ValidScheduleQueryTest {

    @Autowired
    MockMvc mockMvc;

    @MockitoBean
    UserService userService; // used by controller
    @MockitoBean
    TeamService teamService;
    @MockitoBean
    ClockService clockService;

    @Autowired
    GlobalExceptionHandler geh;

    @MockitoBean
    Validator validator;

    @Test
    void postPlanning_whenValidatorReturnsViolations_shouldReturn422_andNotCallService() throws Exception {
        @SuppressWarnings("unchecked")
        ConstraintViolation<PlanningModels.PostPlanningRequest> v =
                (ConstraintViolation<PlanningModels.PostPlanningRequest>) mock(ConstraintViolation.class);

        Path path = mock(Path.class);
        when(path.toString()).thenReturn("userId");          // or any field name
        when(v.getPropertyPath()).thenReturn(path);
        when(v.getMessage()).thenReturn("must not be null"); // optional but nice

        when(validator.validate(any(PlanningModels.PostPlanningRequest.class)))
                .thenReturn(Set.of(v));

        String body = """
            {
              "weekDay": "MONDAY",
              "startTime": "09:00",
              "endTime": "17:00"
            }
            """;

        mockMvc.perform(post("/users/1/plannings")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isUnprocessableEntity())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.title").value("Unprocessable Entity"))
                .andExpect(jsonPath("$.status").value(422))
                .andExpect(jsonPath("$.instance").value("/users/1/plannings"))
                .andExpect(jsonPath("$.details.userId").value("must not be null"));

        verifyNoInteractions(userService);
        verify(validator).validate(any(PlanningModels.PostPlanningRequest.class));
    }
}