package utils;


import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

/**
 * Lookup DataSource do container cung cấp (Tomcat).
 * Ưu điểm: app không chứa secret; DevOps quản lý pool & secret.
 */
public final class DataSourceUtil {
    private static volatile DataSource ds;

    private DataSourceUtil() {}

    public static DataSource getDataSource() {
        if (ds == null) {
            synchronized (DataSourceUtil.class) {
                if (ds == null) {
                    ds = lookup("java:comp/env/jdbc/quan_li_hoi_thao");
                }
            }
        }
        return ds;
    }

    private static DataSource lookup(String jndiName) {
        try {
            Context ctx = new InitialContext();
            return (DataSource) ctx.lookup(jndiName);
        } catch (Exception e) {
            throw new RuntimeException("Không lookup được JNDI DataSource: " + jndiName, e);
        }
    }
}
