package P1_T4_DAO;

import P1_T4_IDAO.Connexio;
import P1_T4_IDAO.IDAO_UnitatMesura;
import P1_T4_Model.UnitatMesura;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DAO_UnitatMesura implements IDAO_UnitatMesura {

    // ✅ 1. Mostrar todas las unidades de medida
    @Override
    public List<UnitatMesura> MostrarTots() {
        List<UnitatMesura> unitats = new ArrayList<>();
        String query = "SELECT CODI_MESURA, NOM FROM UNITAT_MESURA ORDER BY CODI_MESURA";

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                UnitatMesura u = new UnitatMesura();
                u.setCodiMesura(rs.getInt("CODI_MESURA"));
                u.setNom(rs.getString("NOM"));
                unitats.add(u);
            }
        } catch (SQLException e) {
            System.err.println("Error en MostrarTots(): " + e.getMessage());
        }
        return unitats;
    }

    // ✅ 2. Mostrar una unidad por su código
    @Override
    public UnitatMesura MostrarPerId(int codiMesura) {
        UnitatMesura u = null;
        String query = "SELECT CODI_MESURA, NOM FROM UNITAT_MESURA WHERE CODI_MESURA = ?";


        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, codiMesura);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    u = new UnitatMesura();
                    u.setCodiMesura(rs.getInt("CODI_MESURA"));
                    u.setNom(rs.getString("NOM"));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error en MostrarPerId(): " + e.getMessage());
        }
        return u;
    }

    // ✅ 3. Insertar una nueva unidad
    @Override
    public int Afegir(UnitatMesura unitatMesura) {
        String query = "INSERT INTO UNITAT_MESURA (CODI_MESURA, NOM) VALUES (?, ?)";
        int filas = 0;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, unitatMesura.getCodiMesura());
            ps.setString(2, unitatMesura.getNom().trim());
            filas = ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error en Afegir(): " + e.getMessage());
        }
        return filas;
    }

    
    // ✅ 4. Actualizar una unidad existente
    @Override
    public int Actualitzar(UnitatMesura unitatMesura) {
        String query = "UPDATE UNITAT_MESURA SET NOM = ? WHERE CODI_MESURA = ?";
        int filas = 0;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, unitatMesura.getNom().trim());
            ps.setInt(2, unitatMesura.getCodiMesura());
            filas = ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error en Actualitzar(): " + e.getMessage());
        }
        return filas;
    }

    // ✅ 5. Eliminar una unidad por código
    @Override
    public int Eliminar(int codiMesura) {
        String query = "DELETE FROM UNITAT_MESURA WHERE CODI_MESURA = ?";
        int filas = 0;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, codiMesura);
            filas = ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error en Eliminar(): " + e.getMessage());
        }
        return filas;
    }

    // ✅ 6. Mostrar cantidad total de unidades
    @Override
    public int MostrarQt() {
        String query = "SELECT COUNT(*) AS TOTAL FROM UNITAT_MESURA";
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

    // ✅ 7. Comprobar si existe una unidad con cierto código
    @Override
    public boolean exists(int codiMesura) {
        String query = "SELECT 1 FROM UNITAT_MESURA WHERE CODI_MESURA = ?";
        boolean existe = false;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, codiMesura);
            try (ResultSet rs = ps.executeQuery()) {
                existe = rs.next();
            }

        } catch (SQLException e) {
            System.err.println("Error en exists(): " + e.getMessage());
        }
        return existe;
    }

    // ✅ 8. Eliminar todas las unidades
    @Override
    public int EliminarTots() {
        String query = "DELETE FROM UNITAT_MESURA";
        int filas = 0;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            filas = ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error en EliminarTots(): " + e.getMessage());
        }
        return filas;
    }
}
