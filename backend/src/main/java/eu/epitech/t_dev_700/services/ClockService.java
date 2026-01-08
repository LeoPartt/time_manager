package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.entities.ScheduleEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.models.ClockModels;
import eu.epitech.t_dev_700.models.UserScheduleQuery;
import eu.epitech.t_dev_700.repositories.ScheduleRepository;
import eu.epitech.t_dev_700.services.components.UserAuthorization;
import eu.epitech.t_dev_700.services.components.UserComponent;
import eu.epitech.t_dev_700.services.exceptions.InvalidClocking;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.stream.Stream;

import static eu.epitech.t_dev_700.models.ClockModels.ClockAction;

@Service
@RequiredArgsConstructor
public class ClockService {

    private final UserComponent userComponent;
    private final ScheduleRepository scheduleRepository;

    public Long[] getUserClocks(Long id, UserScheduleQuery query) {
        UserEntity user = userComponent.getUser(id);

        List<ScheduleEntity> scheduleEntityList;
        OffsetDateTime from = query.getFrom();
        OffsetDateTime to = query.getTo();

        if (query.getCurrent())
            scheduleEntityList = scheduleRepository.findCurrentSchedules(user, OffsetDateTime.now());
        else if (from != null && to != null)
            scheduleEntityList = scheduleRepository.findOverlapping(user, from, to);
        else if (from != null)
            scheduleEntityList = scheduleRepository.findFrom(user, from);
        else if (to != null)
            scheduleEntityList = scheduleRepository.findUntil(user, to);
        else
            scheduleEntityList = scheduleRepository.findByUser(user);

        return getUserClocks(scheduleEntityList);
    }

    public Long[] getUserClocks(List<ScheduleEntity> supplier) {
        return supplier
                .stream()
                .flatMap(scheduleEntity -> scheduleEntity.getDepartureTs() == null ?
                        Stream.of(scheduleEntity.getArrivalTs().toEpochSecond()) :
                        Stream.of(scheduleEntity.getArrivalTs().toEpochSecond(), scheduleEntity.getDepartureTs().toEpochSecond())
                ).toArray(Long[]::new);
    }

    public void postClock(ClockModels.PostClockRequest body) {
        this.postClock(body, UserAuthorization.getCurrentUser());
    }

    public void postClock(ClockModels.PostClockRequest body, Long id) {
        this.postClock(body, userComponent.getUser(id));
    }

    public void postClock(ClockModels.PostClockRequest body, UserEntity user) {
        switch (body.io()) {
            case ClockAction.IN -> scheduleRepository
                    .findByUserAndDepartureTsIsNull(user)
                    .ifPresentOrElse(
                            new InvalidClocking(ClockAction.OUT),
                            () -> scheduleRepository.save(new ScheduleEntity(user, body.timestamp())));
            case ClockAction.OUT -> scheduleRepository
                    .findByUserAndDepartureTsIsNull(user)
                    .ifPresentOrElse(
                            scheduleEntity -> {
                                scheduleEntity.setDepartureTs(body.timestamp());
                                scheduleRepository.save(scheduleEntity);
                            },
                            new InvalidClocking(ClockAction.IN));
        }
    }

}
