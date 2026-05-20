package p1.t4.dao;

import p1.t4.IDAO.IDAO_Municipi;
import p1.t4.model.Municipi;
import p1.t4.model.Proveidor;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para la clase Municipi
 * Implementa los métodos definidos en la interfaz IDAO_Municipi
 */
public class DAO_Municipi implements IDAO_Municipi {

    /**
     * Mostrar todos los municipios
     */
    @Override
    public List<Municipi> MostrarTots() {
        List<Municipi> municipis = new ArrayList<>();
        String query = "SELECT CODI_MUNICIPI, CODI_PROVINCIA, NOM FROM MUNICIPI";

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Municipi municipi = new Municipi();
                municipi.setCodi_municipi(rs.getInt("CODI_MUNICIPI"));
                municipi.setCodi_provincia(rs.getInt("CODI_PROVINCIA"));
                municipi.setNom(rs.getString("NOM"));
                // Si necesitas cargar el Proveidor, puedes hacerlo aquí
                municipis.add(municipi);
            }
        } catch (SQLException e) {
            System.err.println("Error al mostrar todos los municipios: " + e.getMessage());
        }
        return municipis;
    }

    /**
     * Mostrar un municipio por su ID
     */
    @Override
    public Municipi MostrarPerId(int codiMunicipi) {
        Municipi municipi = null;
        String query = "SELECT CODI_MUNICIPI, CODI_PROVINCIA, NOM FROM MUNICIPI WHERE CODI_MUNICIPI = ?";

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, codiMunicipi);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    municipi = new Municipi();
                    municipi.setCodi_municipi(rs.getInt("CODI_MUNICIPI"));
                    municipi.setCodi_provincia(rs.getInt("CODI_PROVINCIA"));
                    municipi.setNom(rs.getString("NOM"));
                    // Si necesitas cargar el Proveidor, puedes hacerlo aquí
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al mostrar municipio por ID: " + e.getMessage());
        }
        return municipi;
    }

    /**
     * Mostrar los municipios por el código de la provincia
     */
    @Override
    public List<Municipi> MostrarPerProvincia(int codiProvincia) {
        List<Municipi> municipis = new ArrayList<>();
        String query = "SELECT CODI_MUNICIPI, CODI_PROVINCIA, NOM FROM MUNICIPI WHERE CODI_PROVINCIA = ?";

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, codiProvincia);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Municipi municipi = new Municipi();
                    municipi.setCodi_municipi(rs.getInt("CODI_MUNICIPI"));
                    municipi.setCodi_provincia(rs.getInt("CODI_PROVINCIA"));
                    municipi.setNom(rs.getString("NOM"));
                    // Aquí también puedes cargar el Proveidor si es necesario
                    municipis.add(municipi);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al mostrar municipios por provincia: " + e.getMessage());
        }
        return municipis;
    }

    /**
     * Añadir un nuevo municipio
     */
    @Override
    public int Afegir(Municipi municipi) {
        String query = "INSERT INTO MUNICIPI (CODI_MUNICIPI, CODI_PROVINCIA, NOM) VALUES (?, ?, ?)";
        int rowsAffected = 0;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, municipi.getCodi_municipi());
            ps.setInt(2, municipi.getCodi_provincia());
            ps.setString(3, municipi.getNom());

            rowsAffected = ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al agregar municipio: " + e.getMessage());
        }
        return rowsAffected;
    }

    /**
     * Actualizar los datos de un municipio
     */
    @Override
    public int Actualitzar(Municipi municipi) {
        String query = "UPDATE MUNICIPI SET CODI_PROVINCIA = ?, NOM = ? WHERE CODI_MUNICIPI = ?";
        int rowsAffected = 0;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, municipi.getCodi_provincia());
            ps.setString(2, municipi.getNom());
            ps.setInt(3, municipi.getCodi_municipi());

            rowsAffected = ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al actualizar municipio: " + e.getMessage());
        }
        return rowsAffected;
    }

    /**
     * Eliminar un municipio por su ID
     */
    @Override
    public int Eliminar(int codiMunicipi) {
        String query = "DELETE FROM MUNICIPI WHERE CODI_MUNICIPI = ?";
        int rowsAffected = 0;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, codiMunicipi);
            rowsAffected = ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al eliminar municipio: " + e.getMessage());
        }
        return rowsAffected;
    }

    /**
     * Eliminar todos los municipios de la base de datos
     */
    @Override
    public int EliminarTots() {
        String query = "DELETE FROM MUNICIPI";
        int rowsAffected = 0;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            rowsAffected = ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al eliminar todos los municipios: " + e.getMessage());
        }
        return rowsAffected;
    }

    /**
     * Mostrar la cantidad total de municipios
     */
    @Override
    public int MostrarQt() {
        String query = "SELECT COUNT(*) FROM MUNICIPI";
        int count = 0;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);  // Número de municipios
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener el número de municipios: " + e.getMessage());
        }
        return count;
    }

    /**
     * Verificar si un municipio existe por su código
     */
    @Override
    public boolean exists(int codiMunicipi) {
        String query = "SELECT 1 FROM MUNICIPI WHERE CODI_MUNICIPI = ?";
        boolean exists = false;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, codiMunicipi);
            try (ResultSet rs = ps.executeQuery()) {
                exists = rs.next();  // Si hay resultado, el municipio existe
            }
        } catch (SQLException e) {
            System.err.println("Error al verificar existencia de municipio: " + e.getMessage());
        }
        return exists;
    }
}
