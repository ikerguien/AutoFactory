package P1_T4_DAO;

import P1_T4_IDAO.Connexio;
import P1_T4_IDAO.IDAO_Provincia;
import P1_T4_Model.Provincia;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DAO_Provincia implements IDAO_Provincia {

    // ✅ 1. Mostrar todas las provincias
    @Override
    public List<Provincia> mostrarTots() {
        List<Provincia> provincias = new ArrayList<>();
        String query = "SELECT CODI_PROVINCIA, NOM FROM PROVINCIA ORDER BY CODI_PROVINCIA";

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Provincia p = new Provincia();
                p.setCodiProvincia(rs.getInt("CODI_PROVINCIA"));
                p.setNom(rs.getString("NOM"));
                provincias.add(p);
            }

        } catch (SQLException e) {
            System.err.println("Error en mostrarTots(): " + e.getMessage());
        }
        return provincias;
    }

    // ✅ 2. Mostrar provincia por su código
    @Override
    public Provincia MostraPerId(int codiProvincia) {
        Provincia p = null;
        String query = "SELECT CODI_PROVINCIA, NOM FROM PROVINCIA WHERE CODI_PROVINCIA = ?";

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, codiProvincia);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    p = new Provincia();
                    p.setCodiProvincia(rs.getInt("CODI_PROVINCIA"));
                    p.setNom(rs.getString("NOM"));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error en MostraPerId(): " + e.getMessage());
        }
        return p;
    }

    // ✅ 3. Mostrar provincias por nombre
    @Override
    public List<Provincia> MostraPerNom(String nom) {
        List<Provincia> provincias = new ArrayList<>();
        String query = "SELECT CODI_PROVINCIA, NOM FROM PROVINCIA WHERE NOM LIKE ? ORDER BY CODI_PROVINCIA";

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, "%" + nom.trim() + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Provincia p = new Provincia();
                    p.setCodiProvincia(rs.getInt("CODI_PROVINCIA"));
                    p.setNom(rs.getString("NOM"));
                    provincias.add(p);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error en MostraPerNom(): " + e.getMessage());
        }
        return provincias;
    }

    // ✅ 4. Insertar una nueva provincia
    @Override
    public int Afegir(Provincia provincia) {
        String query = "INSERT INTO PROVINCIA (CODI_PROVINCIA, NOM) VALUES (?, ?)";
        int filas = 0;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, provincia.getCodiProvincia());
            ps.setString(2, provincia.getNom().trim());
            filas = ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error en Afegir(): " + e.getMessage());
        }
        return filas;
    }

    // ✅ 5. Actualizar una provincia existente
    @Override
    public int Actualitzar(Provincia provincia) {
        String query = "UPDATE PROVINCIA SET NOM = ? WHERE CODI_PROVINCIA = ?";
        int filas = 0;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, provincia.getNom().trim());
            ps.setInt(2, provincia.getCodiProvincia());
            filas = ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error en Actualitzar(): " + e.getMessage());
        }
        return filas;
    }

    // ✅ 6. Eliminar una provincia por código
    @Override
    public int Eliminar(int codiProvincia) {
        String query = "DELETE FROM PROVINCIA WHERE CODI_PROVINCIA = ?";
        int filas = 0;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, codiProvincia);
            filas = ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error en Eliminar(): " + e.getMessage());
        }
        return filas;
    }

    // ✅ 7. Eliminar todas las provincias
    @Override
    public int EliminarTots() {
        String query = "DELETE FROM PROVINCIA";
        int filas = 0;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            filas = ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error en EliminarTots(): " + e.getMessage());
        }
        return filas;
    }

    // ✅ 8. Mostrar la cantidad total de provincias
    @Override
    public int MostrarQt() {
        String query = "SELECT COUNT(*) AS TOTAL FROM PROVINCIA";
        int total = 0;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                total = rs.getInt("TOTAL");
            }

        } catch (SQLException e) {
            System.err.println("Error en MostrarQt(): " + e.getMessage());
        }
        return total;
    }

    // ✅ 9. Comprobar si una provincia existe con su código
    @Override
    public boolean exists(int codiProvincia) {
        String query = "SELECT 1 FROM PROVINCIA WHERE CODI_PROVINCIA = ?";
        boolean existe = false;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, codiProvincia);
            try (ResultSet rs = ps.executeQuery()) {
                existe = rs.next();
            }

        } catch (SQLException e) {
            System.err.println("Error en exists(): " + e.getMessage());
        }
        return existe;
    }
}
