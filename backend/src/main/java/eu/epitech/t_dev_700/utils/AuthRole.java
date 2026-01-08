package eu.epitech.t_dev_700.utils;

import lombok.Getter;

@Getter
public enum AuthRole {

    SELF("Self"),
    MANAGER("Manager"),
    MANAGER_OF("Manager of"),
    MEMBER_OF("Member of"),
    ADMINISTRATOR("Administrator");

    private final String role;

    AuthRole(String role) {
        this.role = role;
    }
}
