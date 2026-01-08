package eu.epitech.t_dev_700.services;

import eu.epitech.t_dev_700.mappers.CRUDMapper;
import eu.epitech.t_dev_700.services.exceptions.ResourceNotFound;
import eu.epitech.t_dev_700.utils.CRUDHookUtils;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Generic CRUD service with mapping and template hooks.
 *
 * @param <E> Entity type
 * @param <M> DTO Model type
 * @param <C> DTO Create type
 */
public abstract class CRUDService<E, M, C, R, U> {

    protected final JpaRepository<E, Long> repository;
    protected final CRUDMapper<E, M, C, R, U> CRUDMapper;
    protected final String entityName;

    protected CRUDService(JpaRepository<E, Long> repository,
                          CRUDMapper<E, M, C, R, U> CRUDMapper,
                          String entityName) {
        this.repository = repository;
        this.CRUDMapper = CRUDMapper;
        this.entityName = entityName;
    }

    @Transactional(readOnly = true)
    public List<E> getAll() {
        return repository.findAll();
    }

    @Transactional(readOnly = true)
    public M[] list() {
        return CRUDMapper.listEntity(this.getAll());
    }

    @Transactional(readOnly = true)
    public M get(Long id) {
        return CRUDMapper.toModel(findEntityOrThrow(id));
    }

    @Transactional
    public M create(C request) {
        E entity = CRUDMapper.createEntity(request);
        CRUDHookUtils.beforeCreate(this, entity, request);
        E saved = repository.save(entity);
        CRUDHookUtils.afterCreate(this, saved, request);
        return CRUDMapper.toModel(saved);
    }

    @Transactional
    public M replace(Long id, R request) {
        E entity = findEntityOrThrow(id);
        CRUDMapper.replaceEntity(entity, request);
        CRUDHookUtils.beforeReplace(this, entity, request);
        E saved = repository.save(entity);
        CRUDHookUtils.afterReplace(this, saved, request);
        return CRUDMapper.toModel(saved);
    }

    @Transactional
    public M update(Long id, U request) {
        E entity = findEntityOrThrow(id);
        CRUDMapper.updateEntity(entity, request);
        CRUDHookUtils.beforeUpdate(this, entity, request);
        E saved = repository.save(entity);
        CRUDHookUtils.afterUpdate(this, saved, request);
        return CRUDMapper.toModel(saved);
    }

    @Transactional
    public void delete(Long id) {
        E entity = findEntityOrThrow(id);
        CRUDHookUtils.beforeDelete(this, entity);
        repository.delete(entity);
        CRUDHookUtils.afterDelete(this, entity);
    }

    public E findEntityOrThrow(Long id) {
        return repository.findById(id).orElseThrow(new ResourceNotFound(this.entityName, id));
    }

}

