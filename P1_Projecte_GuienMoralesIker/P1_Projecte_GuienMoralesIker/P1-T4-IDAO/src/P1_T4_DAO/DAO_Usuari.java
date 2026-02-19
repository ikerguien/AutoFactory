/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package P1_T4_DAO;

import P1_T4_IDAO.IDAO_Usuari;
import P1_T4_IDAO.Connexio;  // Importa la clase Connexio
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;

public class DAO_Usuari implements IDAO_Usuari {

    // Constructor sin parámetros, se usará Connexio para obtener la conexión
    public DAO_Usuari() {
    }

    /**
     * Verifica si el usuario y la contraseña son correctos.
     * @param usuario El nombre de usuario.
     * @param contrasenya La contraseña proporcionada.
     * @return true si el usuario y la contraseña son correctos, false de lo contrario.
     */
        @Override
    public boolean login(String usuario, String contrasenya) {
        String sql = "SELECT USUARI_CONTRASENYA FROM USUARI WHERE USUARI_NOM = ?";
        try (Connection connection = Connexio.getConnection();  // Usamos Connexio para obtener la conexión
             PreparedStatement stmt = connection.prepareStatement(sql)) {
            
            // Establecer el parámetro del nombre de usuario
            stmt.setString(1, usuario);
            ResultSet rs = stmt.executeQuery();

            // Si se encuentra un resultado, comparamos el hash de la contraseña
            if (rs.next()) {
                String hashAlmacenado = rs.getString("USUARI_CONTRASENYA");

                // Verificamos si la contraseña proporcionada coincide con el hash almacenado
                return BCrypt.checkpw(contrasenya, hashAlmacenado);
            }

            // Si no existe el usuario, retornamos false
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}