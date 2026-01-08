package eu.epitech.t_dev_700.utils;

import org.hibernate.Session;

import java.util.function.Supplier;

public final class FiltersHelper {

    public static final String DELETED_MEMBERSHIP = "deletedMembershipFilter";
    public static final String DELETED_USER = "deletedUserFilter";
    public static final String DELETED_TEAM = "deletedTeamFilter";

    private FiltersHelper() {}

    public static void without(Session session, String filterName, Runnable action) {
        boolean wasEnabled = session.getEnabledFilter(filterName) != null;
        if (wasEnabled) {
            session.disableFilter(filterName);
        }
        try {
            action.run();
        } finally {
            if (wasEnabled) {
                session.enableFilter(filterName);
            }
        }
    }

    public static <T> T without(Session session, String filterName, Supplier<T> supplier) {
        boolean wasEnabled = session.getEnabledFilter(filterName) != null;
        if (wasEnabled) {
            session.disableFilter(filterName);
        }
        try {
            return supplier.get();
        } finally {
            if (wasEnabled) {
                session.enableFilter(filterName);
            }
        }
    }
}