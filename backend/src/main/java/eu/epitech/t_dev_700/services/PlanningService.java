package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.entities.PlanningEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.mappers.PlanningMapper;
import eu.epitech.t_dev_700.models.PlanningModels;
import eu.epitech.t_dev_700.repositories.PlanningRepository;
import eu.epitech.t_dev_700.services.components.UserComponent;
import eu.epitech.t_dev_700.utils.CRUDHookUtils;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PlanningService extends CRUDService<
        PlanningEntity,
        PlanningModels.PlanningResponse,
        PlanningModels.PostPlanningRequest,
        PlanningModels.PutPlanningRequest,
        PlanningModels.PatchPlanningRequest
        > {

    private final PlanningRepository planningRepository;
    private final MembershipService membershipService;
    private final UserComponent userComponent;

    public PlanningService(
            PlanningRepository planningRepository,
            PlanningMapper planningMapper,
            MembershipService membershipService,
            UserComponent userComponent) {
        super(planningRepository, planningMapper, "Planning");
        this.planningRepository = planningRepository;
        this.membershipService = membershipService;
        this.userComponent = userComponent;
    }


    @CRUDHookUtils.CRUDHook(action = CRUDHookUtils.Action.CREATE, moment = CRUDHookUtils.Moment.BEFORE)
    public void onpPlanningCreation(PlanningEntity entity, PlanningModels.PostPlanningRequest request) {
        UserEntity user = userComponent.getUser(request.userId());
        entity.setUser(user);
    }

    public List<PlanningEntity> getForUser(UserEntity user) {
        return this.planningRepository.findByUser(user);
    }

    public PlanningModels.PlanningResponse[] listForUser(UserEntity user) {
        return this.CRUDMapper.listEntity(this.getForUser(user));
    }

    public boolean isOwner(UserEntity user, Long planningId) {
        return this.findEntityOrThrow(planningId).getUser().equals(user);
    }

    public boolean isManagerOfOwner(UserEntity user, Long planningId) {
        return membershipService.isUserManagerOfOther(user, this.findEntityOrThrow(planningId).getUser());
    }
}
