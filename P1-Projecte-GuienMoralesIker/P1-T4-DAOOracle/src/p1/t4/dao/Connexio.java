package p1.t4.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Connexio {

    // URL de conexión para Oracle
    private static final String URL = "jdbc:oracle:thin:@//10.2.109.238:1521/XEPDB1";
    private static final String USER = "alumne";
    private static final String PASSWORD = "alumne";

    // Método para obtener la conexión
    public static Connection getConnection() {
        Connection connection = null;
        try {
            // Cargar el driver JDBC de Oracle
            Class.forName("oracle.jdbc.OracleDriver");  // Driver correcto para Oracle
            // Establecer la conexión
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return connection;
    }

    // Método para cerrar la conexión
    public static void closeConnection(Connection connection) {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();  // Cierra la conexión
                System.out.println("Conexión cerrada correctamente.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
