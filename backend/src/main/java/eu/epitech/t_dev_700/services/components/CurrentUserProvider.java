package eu.epitech.t_dev_700.services.components;

import eu.epitech.t_dev_700.entities.UserEntity;

public interface CurrentUserProvider {
    UserEntity getCurrentUser();
}
