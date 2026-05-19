package org.example.polideportivojsp.DAO;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class ConexionDB {

    private static final Properties PROPS = cargarPropiedades();

    private static Properties cargarPropiedades() {
        Properties props = new Properties();
        try (InputStream is = ConexionDB.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (is == null) {
                throw new RuntimeException("No se encontró el archivo db.properties");
            }
            props.load(is);
        } catch (IOException e) {
            throw new RuntimeException("Error al leer db.properties", e);
        }
        return props;
    }

    public static Connection getConexion() throws SQLException {
        String url  = PROPS.getProperty("db.url");
        String user = PROPS.getProperty("db.user");
        String pass = PROPS.getProperty("db.password");
        return DriverManager.getConnection(url, user, pass);
    }
}
