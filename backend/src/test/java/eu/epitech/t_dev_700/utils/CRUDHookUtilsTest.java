package eu.epitech.t_dev_700.utils;

import eu.epitech.t_dev_700.entities.TeamEntity;
import eu.epitech.t_dev_700.mappers.TeamMapper;
import eu.epitech.t_dev_700.models.TeamModels;
import eu.epitech.t_dev_700.repositories.TeamRepository;
import eu.epitech.t_dev_700.services.CRUDService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.assertj.core.api.Assertions.assertThat;

@ExtendWith(MockitoExtension.class)
class CRUDHookUtilsTest {

    @Mock
    private TeamRepository teamRepository;

    @Mock
    private TeamMapper teamMapper;

    private TestCRUDService testService;
    private TeamEntity testEntity;
    private TeamModels.PostTeamRequest postRequest;

    @BeforeEach
    void setUp() {
        testService = new TestCRUDService(teamRepository, teamMapper);
        testEntity = new TeamEntity();
        testEntity.setId(1L);
        testEntity.setName("Test Team");

        postRequest = new TeamModels.PostTeamRequest("Test Team", "Description");
    }

    @Test
    void testBeforeCreate_shouldInvokeHook() {
        CRUDHookUtils.beforeCreate(testService, testEntity, postRequest);

        assertThat(testService.beforeCreateCalled).isTrue();
    }

    @Test
    void testAfterCreate_shouldInvokeHook() {
        CRUDHookUtils.afterCreate(testService, testEntity, postRequest);

        assertThat(testService.afterCreateCalled).isTrue();
    }

    @Test
    void testBeforeUpdate_shouldInvokeHook() {
        CRUDHookUtils.beforeUpdate(testService, testEntity, postRequest);

        assertThat(testService.beforeUpdateCalled).isTrue();
    }

    @Test
    void testAfterUpdate_shouldInvokeHook() {
        CRUDHookUtils.afterUpdate(testService, testEntity, postRequest);

        assertThat(testService.afterUpdateCalled).isTrue();
    }

    @Test
    void testBeforeReplace_shouldInvokeHook() {
        CRUDHookUtils.beforeReplace(testService, testEntity, postRequest);

        assertThat(testService.beforeReplaceCalled).isTrue();
    }

    @Test
    void testAfterReplace_shouldInvokeHook() {
        CRUDHookUtils.afterReplace(testService, testEntity, postRequest);

        assertThat(testService.afterReplaceCalled).isTrue();
    }

    @Test
    void testBeforeDelete_shouldInvokeHook() {
        CRUDHookUtils.beforeDelete(testService, testEntity);

        assertThat(testService.beforeDeleteCalled).isTrue();
    }

    @Test
    void testAfterDelete_shouldInvokeHook() {
        CRUDHookUtils.afterDelete(testService, testEntity);

        assertThat(testService.afterDeleteCalled).isTrue();
    }

    @Test
    void testHookMoment_enum() {
        CRUDHookUtils.Moment[] moments = CRUDHookUtils.Moment.values();
        assertThat(moments).hasSize(2);
        assertThat(moments).containsExactlyInAnyOrder(
                CRUDHookUtils.Moment.BEFORE,
                CRUDHookUtils.Moment.AFTER
        );
    }

    @Test
    void testHookAction_enum() {
        CRUDHookUtils.Action[] actions = CRUDHookUtils.Action.values();
        assertThat(actions).hasSize(4);
        assertThat(actions).containsExactlyInAnyOrder(
                CRUDHookUtils.Action.CREATE,
                CRUDHookUtils.Action.UPDATE,
                CRUDHookUtils.Action.REPLACE,
                CRUDHookUtils.Action.DELETE
        );
    }

    @Test
    void testMultipleHooks_shouldAllBeInvoked() {
        TestServiceWithMultipleHooks service = new TestServiceWithMultipleHooks(teamRepository, teamMapper);

        CRUDHookUtils.beforeCreate(service, testEntity, postRequest);

        assertThat(service.hook1Called).isTrue();
        assertThat(service.hook2Called).isTrue();
    }

    @Test
    void testHook_withOnlyEntityParameter() {
        CRUDHookUtils.beforeDelete(testService, testEntity);

        assertThat(testService.beforeDeleteCalled).isTrue();
        assertThat(testService.entityReceived).isEqualTo(testEntity);
    }

    @Test
    void testHook_withEntityAndRequestParameters() {
        CRUDHookUtils.beforeCreate(testService, testEntity, postRequest);

        assertThat(testService.beforeCreateCalled).isTrue();
        assertThat(testService.entityReceived).isEqualTo(testEntity);
        assertThat(testService.requestReceived).isEqualTo(postRequest);
    }

    // Test service with hooks
    static class TestCRUDService extends CRUDService<TeamEntity, TeamModels.TeamResponse, TeamModels.PostTeamRequest, TeamModels.PutTeamRequest, TeamModels.PatchTeamRequest> {

        boolean beforeCreateCalled = false;
        boolean afterCreateCalled = false;
        boolean beforeUpdateCalled = false;
        boolean afterUpdateCalled = false;
        boolean beforeReplaceCalled = false;
        boolean afterReplaceCalled = false;
        boolean beforeDeleteCalled = false;
        boolean afterDeleteCalled = false;
        TeamEntity entityReceived = null;
        Object requestReceived = null;

        protected TestCRUDService(TeamRepository repository, TeamMapper mapper) {
            super(repository, mapper, "Test");
        }

        @CRUDHookUtils.CRUDHook(moment = CRUDHookUtils.Moment.BEFORE, action = CRUDHookUtils.Action.CREATE)
        public void beforeCreate(TeamEntity entity, TeamModels.PostTeamRequest request) {
            beforeCreateCalled = true;
            entityReceived = entity;
            requestReceived = request;
        }

        @CRUDHookUtils.CRUDHook(moment = CRUDHookUtils.Moment.AFTER, action = CRUDHookUtils.Action.CREATE)
        public void afterCreate(TeamEntity entity, TeamModels.PostTeamRequest request) {
            afterCreateCalled = true;
        }

        @CRUDHookUtils.CRUDHook(moment = CRUDHookUtils.Moment.BEFORE, action = CRUDHookUtils.Action.UPDATE)
        public void beforeUpdate(TeamEntity entity, TeamModels.PostTeamRequest request) {
            beforeUpdateCalled = true;
        }

        @CRUDHookUtils.CRUDHook(moment = CRUDHookUtils.Moment.AFTER, action = CRUDHookUtils.Action.UPDATE)
        public void afterUpdate(TeamEntity entity, TeamModels.PostTeamRequest request) {
            afterUpdateCalled = true;
        }

        @CRUDHookUtils.CRUDHook(moment = CRUDHookUtils.Moment.BEFORE, action = CRUDHookUtils.Action.REPLACE)
        public void beforeReplace(TeamEntity entity, TeamModels.PostTeamRequest request) {
            beforeReplaceCalled = true;
        }

        @CRUDHookUtils.CRUDHook(moment = CRUDHookUtils.Moment.AFTER, action = CRUDHookUtils.Action.REPLACE)
        public void afterReplace(TeamEntity entity, TeamModels.PostTeamRequest request) {
            afterReplaceCalled = true;
        }

        @CRUDHookUtils.CRUDHook(moment = CRUDHookUtils.Moment.BEFORE, action = CRUDHookUtils.Action.DELETE)
        public void beforeDelete(TeamEntity entity) {
            beforeDeleteCalled = true;
            entityReceived = entity;
        }

        @CRUDHookUtils.CRUDHook(moment = CRUDHookUtils.Moment.AFTER, action = CRUDHookUtils.Action.DELETE)
        public void afterDelete(TeamEntity entity) {
            afterDeleteCalled = true;
        }
    }

    // Test service with multiple hooks for the same action
    static class TestServiceWithMultipleHooks extends CRUDService<TeamEntity, TeamModels.TeamResponse, TeamModels.PostTeamRequest, TeamModels.PutTeamRequest, TeamModels.PatchTeamRequest> {

        boolean hook1Called = false;
        boolean hook2Called = false;

        protected TestServiceWithMultipleHooks(TeamRepository repository, TeamMapper mapper) {
            super(repository, mapper, "Test");
        }

        @CRUDHookUtils.CRUDHook(moment = CRUDHookUtils.Moment.BEFORE, action = CRUDHookUtils.Action.CREATE)
        public void hook1(TeamEntity entity, TeamModels.PostTeamRequest request) {
            hook1Called = true;
        }

        @CRUDHookUtils.CRUDHook(moment = CRUDHookUtils.Moment.BEFORE, action = CRUDHookUtils.Action.CREATE)
        public void hook2(TeamEntity entity, TeamModels.PostTeamRequest request) {
            hook2Called = true;
        }
    }

    @Test
    void hookWithInvalidSignature_shouldThrowInvalidMethodSignature_wrappedByRun() {
        class BadSignatureService extends CRUDService<TeamEntity, TeamModels.TeamResponse,
                TeamModels.PostTeamRequest, TeamModels.PutTeamRequest, TeamModels.PatchTeamRequest> {

            protected BadSignatureService(TeamRepository repo, TeamMapper mapper) {
                super(repo, mapper, "Test");
            }

            @CRUDHookUtils.CRUDHook(moment = CRUDHookUtils.Moment.BEFORE, action = CRUDHookUtils.Action.CREATE)
            public void badHook() { // <- invalid: 0 params
            }
        }

        BadSignatureService service = new BadSignatureService(teamRepository, teamMapper);

        RuntimeException ex = org.junit.jupiter.api.Assertions.assertThrows(
                RuntimeException.class,
                () -> CRUDHookUtils.beforeCreate(service, testEntity, postRequest)
        );

        // outer wrapper
        assertThat(ex.getMessage()).isEqualTo("Failed to invoke CRUD hooks");
        assertThat(ex.getCause()).isInstanceOf(CRUDHookUtils.InvalidMethodSignature.class);

        // cover InvalidMethodSignature message constructor
        assertThat(ex.getCause().getMessage()).contains("Invalid CRUDHookUtils method signature:");
    }

    @Test
    void hookThatThrows_shouldBeWrappedAsExceptionInHook_withOriginalCause() {
        class ThrowingHookService extends CRUDService<TeamEntity, TeamModels.TeamResponse,
                TeamModels.PostTeamRequest, TeamModels.PutTeamRequest, TeamModels.PatchTeamRequest> {

            protected ThrowingHookService(TeamRepository repo, TeamMapper mapper) {
                super(repo, mapper, "Test");
            }

            @CRUDHookUtils.CRUDHook(moment = CRUDHookUtils.Moment.BEFORE, action = CRUDHookUtils.Action.CREATE)
            public void boom(TeamEntity entity, TeamModels.PostTeamRequest request) {
                throw new IllegalStateException("boom");
            }
        }

        ThrowingHookService service = new ThrowingHookService(teamRepository, teamMapper);

        RuntimeException ex = org.junit.jupiter.api.Assertions.assertThrows(
                RuntimeException.class,
                () -> CRUDHookUtils.beforeCreate(service, testEntity, postRequest)
        );

        // run() outer wrapper
        assertThat(ex.getMessage()).isEqualTo("Failed to invoke CRUD hooks");

        // inner wrapper from invoke()
        assertThat(ex.getCause()).isInstanceOf(RuntimeException.class);
        assertThat(ex.getCause().getMessage()).isEqualTo("Exception in hook");

        // original cause preserved
        assertThat(ex.getCause().getCause())
                .isInstanceOf(IllegalStateException.class)
                .hasMessage("boom");
    }

    @Test
    void hookWithWrongEntityType_shouldThrowInvalidMethodSignature_wrapped() {
        class WrongEntityTypeService extends CRUDService<TeamEntity, TeamModels.TeamResponse,
                TeamModels.PostTeamRequest, TeamModels.PutTeamRequest, TeamModels.PatchTeamRequest> {

            protected WrongEntityTypeService(TeamRepository repo, TeamMapper mapper) {
                super(repo, mapper, "Test");
            }

            @CRUDHookUtils.CRUDHook(moment = CRUDHookUtils.Moment.BEFORE, action = CRUDHookUtils.Action.DELETE)
            public void wrongType(String notAnEntity) { // 1 param but not entity type
            }
        }

        WrongEntityTypeService service = new WrongEntityTypeService(teamRepository, teamMapper);

        RuntimeException ex = org.junit.jupiter.api.Assertions.assertThrows(
                RuntimeException.class,
                () -> CRUDHookUtils.beforeDelete(service, testEntity)
        );

        assertThat(ex.getMessage()).isEqualTo("Failed to invoke CRUD hooks");
        assertThat(ex.getCause()).isInstanceOf(CRUDHookUtils.InvalidMethodSignature.class);
    }

    @Test
    void hookWithWrongRequestType_shouldThrowInvalidMethodSignature_wrapped() {
        class WrongRequestTypeService extends CRUDService<TeamEntity, TeamModels.TeamResponse,
                TeamModels.PostTeamRequest, TeamModels.PutTeamRequest, TeamModels.PatchTeamRequest> {

            protected WrongRequestTypeService(TeamRepository repo, TeamMapper mapper) {
                super(repo, mapper, "Test");
            }

            @CRUDHookUtils.CRUDHook(moment = CRUDHookUtils.Moment.BEFORE, action = CRUDHookUtils.Action.CREATE)
            public void wrongReq(TeamEntity entity, Integer request) { // request type mismatch
            }
        }

        WrongRequestTypeService service = new WrongRequestTypeService(teamRepository, teamMapper);

        RuntimeException ex = org.junit.jupiter.api.Assertions.assertThrows(
                RuntimeException.class,
                () -> CRUDHookUtils.beforeCreate(service, testEntity, postRequest)
        );

        assertThat(ex.getMessage()).isEqualTo("Failed to invoke CRUD hooks");
        assertThat(ex.getCause()).isInstanceOf(CRUDHookUtils.InvalidMethodSignature.class);
    }

    @Test
    void hookWithTwoParams_whereFirstParamNotEntity_shouldHit_params0IsInstanceFalse() {
        class FirstParamNotEntityService extends CRUDService<TeamEntity, TeamModels.TeamResponse,
                TeamModels.PostTeamRequest, TeamModels.PutTeamRequest, TeamModels.PatchTeamRequest> {

            protected FirstParamNotEntityService(TeamRepository repo, TeamMapper mapper) {
                super(repo, mapper, "Test");
            }

            @CRUDHookUtils.CRUDHook(moment = CRUDHookUtils.Moment.BEFORE, action = CRUDHookUtils.Action.CREATE)
            public void badFirstParam(String notEntity, TeamModels.PostTeamRequest request) {
                // should never be called
            }
        }

        var service = new FirstParamNotEntityService(teamRepository, teamMapper);

        RuntimeException ex = org.junit.jupiter.api.Assertions.assertThrows(
                RuntimeException.class,
                () -> CRUDHookUtils.beforeCreate(service, testEntity, postRequest)
        );

        // run() wrapper
        assertThat(ex.getMessage()).isEqualTo("Failed to invoke CRUD hooks");
        // underlying reason: signature invalid (because params[0] doesn't match entity)
        assertThat(ex.getCause()).isInstanceOf(CRUDHookUtils.InvalidMethodSignature.class);
    }

}
