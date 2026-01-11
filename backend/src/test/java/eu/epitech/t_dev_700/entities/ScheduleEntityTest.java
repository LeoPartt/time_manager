package eu.epitech.t_dev_700.entities;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.OffsetDateTime;

import static org.assertj.core.api.Assertions.assertThat;

class ScheduleEntityTest {

    private ScheduleEntity schedule;
    private UserEntity user;

    private OffsetDateTime now;
    private OffsetDateTime arrivalTime;
    private OffsetDateTime departureTime;

    @BeforeEach
    void setUp() {
        schedule = new ScheduleEntity();

        user = new UserEntity();
        user.setId(1L);
        user.setFirstName("John");
        user.setLastName("Doe");

        // Deterministic timestamps (no flakiness, no nanos surprises)
        now = OffsetDateTime.parse("2026-01-09T12:00:00+01:00");
        arrivalTime = now.minusHours(8);
        departureTime = now;

        schedule.setUser(user);
        schedule.setArrivalTs(arrivalTime);
        schedule.setDepartureTs(departureTime);
    }

    @Test
    void testGettersAndSetters() {
        assertThat(schedule.getUser()).isEqualTo(user);
        assertThat(schedule.getArrivalTs()).isEqualTo(arrivalTime);
        assertThat(schedule.getDepartureTs()).isEqualTo(departureTime);
    }

    @Test
    void testScheduleWithOnlyArrival() {
        ScheduleEntity activeSchedule = new ScheduleEntity();
        activeSchedule.setUser(user);
        activeSchedule.setArrivalTs(arrivalTime);

        assertThat(activeSchedule.getArrivalTs()).isEqualTo(arrivalTime);
        assertThat(activeSchedule.getDepartureTs()).isNull();
    }

    @Test
    void testScheduleWithArrivalAndDeparture_hasConsistentTimes() {
        assertThat(schedule.getDepartureTs()).isAfterOrEqualTo(schedule.getArrivalTs());
    }

    @Test
    void testSetDepartureTime() {
        ScheduleEntity newSchedule = new ScheduleEntity();
        newSchedule.setArrivalTs(arrivalTime);

        assertThat(newSchedule.getDepartureTs()).isNull();

        newSchedule.setDepartureTs(departureTime);
        assertThat(newSchedule.getDepartureTs()).isEqualTo(departureTime);
        assertThat(newSchedule.getDepartureTs()).isAfterOrEqualTo(newSchedule.getArrivalTs());
    }

    @Test
    void testRelationshipWithUser() {
        UserEntity newUser = new UserEntity();
        newUser.setId(2L);
        newUser.setFirstName("Jane");

        schedule.setUser(newUser);

        assertThat(schedule.getUser()).isEqualTo(newUser);
        assertThat(schedule.getUser().getFirstName()).isEqualTo("Jane");
    }

    @Test
    void testArrivalBeforeDeparture_example() {
        OffsetDateTime arrival = now;
        OffsetDateTime departure = arrival.plusHours(8);

        schedule.setArrivalTs(arrival);
        schedule.setDepartureTs(departure);

        assertThat(schedule.getDepartureTs()).isAfter(schedule.getArrivalTs());
    }

    @Test
    void testSameArrivalAndDeparture_allowedByConstraint() {
        OffsetDateTime sameTime = now;

        schedule.setArrivalTs(sameTime);
        schedule.setDepartureTs(sameTime);

        assertThat(schedule.getDepartureTs()).isEqualTo(schedule.getArrivalTs());
    }

    @Test
    void testCreateScheduleWithMinimalData() {
        ScheduleEntity minimalSchedule = new ScheduleEntity();
        minimalSchedule.setUser(user);
        minimalSchedule.setArrivalTs(arrivalTime);

        assertThat(minimalSchedule.getUser()).isNotNull();
        assertThat(minimalSchedule.getArrivalTs()).isNotNull();
        assertThat(minimalSchedule.getDepartureTs()).isNull();
    }

    @Test
    void testConstructor_withUserAndArrival_shouldSetFields() {
        ScheduleEntity constructed = new ScheduleEntity(user, arrivalTime);

        assertThat(constructed.getUser()).isEqualTo(user);
        assertThat(constructed.getArrivalTs()).isEqualTo(arrivalTime);
        assertThat(constructed.getDepartureTs()).isNull();
    }
}
