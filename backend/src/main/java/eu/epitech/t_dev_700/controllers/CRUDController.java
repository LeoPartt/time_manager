package eu.epitech.t_dev_700.controllers;

import eu.epitech.t_dev_700.doc.ApiErrorResponse;
import eu.epitech.t_dev_700.models.HasId;
import eu.epitech.t_dev_700.services.exceptions.ResourceNotFound;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import org.springframework.http.ResponseEntity;

import java.net.URI;

/**
 * Generic CRUD service with mapping and template hooks.
 *
 * @param <M> DTO Model type
 * @param <C> DTO Create type
 * @param <R> DTO PUT type
 * @param <U> DTO Update type
 */
public interface CRUDController<M extends HasId, C, R, U> {

    @ApiResponse(responseCode = "200", useReturnTypeSchema = true)
    @ApiErrorResponse(ResourceNotFound.class)
    ResponseEntity<M> Get(Long id);

    @ApiResponse(responseCode = "200", useReturnTypeSchema = true)
    ResponseEntity<M[]> GetAll();

    @ApiResponse(responseCode = "201", useReturnTypeSchema = true)
    ResponseEntity<M> Post(C body);

    @ApiResponse(responseCode = "200", useReturnTypeSchema = true)
    @ApiErrorResponse(ResourceNotFound.class)
    ResponseEntity<M> Put(Long id, R body);

    @ApiResponse(responseCode = "200", useReturnTypeSchema = true)
    @ApiErrorResponse(ResourceNotFound.class)
    ResponseEntity<M> Patch(Long id, U body);

    @ApiResponse(responseCode = "204")
    @ApiErrorResponse(ResourceNotFound.class)
    ResponseEntity<Void> Delete(Long id);

    default <T extends HasId> ResponseEntity<T> created(String path, T model) {
        return ResponseEntity.created(URI.create("/%s/%d".formatted(path, (model == null)?0:model.id()))).body(model);
    }
}
