package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.entities.PlanningEntity;
import eu.epitech.t_dev_700.entities.UserEntity;
import eu.epitech.t_dev_700.mappers.PlanningMapper;
import eu.epitech.t_dev_700.models.PlanningModels;
import eu.epitech.t_dev_700.repositories.PlanningRepository;
import eu.epitech.t_dev_700.repositories.UserRepository;
import eu.epitech.t_dev_700.services.exceptions.ResourceNotFound;

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
    private final UserRepository userRepository;
      private final PlanningMapper planningMapper;

    public PlanningService(
            PlanningRepository planningRepository, UserRepository userRepository,
            
            PlanningMapper planningMapper, MembershipService membershipService) {
        super(planningRepository, planningMapper, "Planning");
        this.planningRepository = planningRepository;
        this.membershipService = membershipService;
         this.userRepository = userRepository;
         this.planningMapper = planningMapper;
    }

    @Override
    public PlanningModels.PlanningResponse create(PlanningModels.PostPlanningRequest body) {
        
        UserEntity user = userRepository.findById(body.userId())
                .orElseThrow(() -> new ResourceNotFound("User", body.userId()));

     
        PlanningEntity entity = planningMapper.createEntity(body);
        
       
        entity.setUser(user);

       
        PlanningEntity saved = planningRepository.save(entity);

    
        return planningMapper.toModel(saved);
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
