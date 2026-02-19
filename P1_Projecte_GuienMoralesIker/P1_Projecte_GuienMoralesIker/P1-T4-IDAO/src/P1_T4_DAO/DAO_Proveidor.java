package P1_T4_DAO;

import P1_T4_IDAO.Connexio;
import P1_T4_IDAO.IDAO_Proveidor;
import P1_T4_Model.Proveidor;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DAO_Proveidor implements IDAO_Proveidor {

    // ✅ 1. Mostrar todos los proveedores
    @Override
    public List<Proveidor> MostrarTots() {
        List<Proveidor> proveidors = new ArrayList<>();
        String query = "SELECT PV_CODI, PV_CIF, PV_RAO_SOCIAL, PV_LIN_ADRE_FAC, PV_PERSONA_CONTACTE, " +
                       "PV_TELEF_CONTACTE, PV_CODI_MUNICIPI, PV_CODI_PROVINCIA FROM PROVEIDOR ORDER BY PV_CODI";

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Proveidor p = new Proveidor();
                p.setPvCodi(rs.getInt("PV_CODI"));
                p.setPvCif(rs.getString("PV_CIF"));
                p.setPvRaoSocial(rs.getString("PV_RAO_SOCIAL"));
                p.setPvLinAdreFac(rs.getString("PV_LIN_ADRE_FAC"));
                p.setPvPersonaContacte(rs.getString("PV_PERSONA_CONTACTE"));
                p.setPvTelefContacte(rs.getString("PV_TELEF_CONTACTE"));
                p.setPvCodiMunicipi(rs.getString("PV_CODI_MUNICIPI"));
                p.setPvCodiProvincia(rs.getString("PV_CODI_PROVINCIA"));
                proveidors.add(p);
            }

        } catch (SQLException e) {
            System.err.println("Error en MostrarTots(): " + e.getMessage());
        }
        return proveidors;
    }

    // ✅ 2. Mostrar un proveedor por su código (PV_CODI)
    @Override
    public Proveidor MostrarPerId(int pvCodi) {
        Proveidor p = null;
        String query = "SELECT PV_CODI, PV_CIF, PV_RAO_SOCIAL, PV_LIN_ADRE_FAC, PV_PERSONA_CONTACTE, " +
                       "PV_TELEF_CONTACTE, PV_CODI_MUNICIPI, PV_CODI_PROVINCIA FROM PROVEIDOR WHERE PV_CODI = ?";

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, pvCodi);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    p = new Proveidor();
                    p.setPvCodi(rs.getInt("PV_CODI"));
                    p.setPvCif(rs.getString("PV_CIF"));
                    p.setPvRaoSocial(rs.getString("PV_RAO_SOCIAL"));
                    p.setPvLinAdreFac(rs.getString("PV_LIN_ADRE_FAC"));
                    p.setPvPersonaContacte(rs.getString("PV_PERSONA_CONTACTE"));
                    p.setPvTelefContacte(rs.getString("PV_TELEF_CONTACTE"));
                    p.setPvCodiMunicipi(rs.getString("PV_CODI_MUNICIPI"));
                    p.setPvCodiProvincia(rs.getString("PV_CODI_PROVINCIA"));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error en MostrarPerId(): " + e.getMessage());
        }
        return p;
    }

    // ✅ 3. Insertar un nuevo proveedor
    @Override
    public int afegir(Proveidor proveidor) {
        String query = "INSERT INTO PROVEIDOR (PV_CODI, PV_CIF, PV_RAO_SOCIAL, PV_LIN_ADRE_FAC, PV_PERSONA_CONTACTE, " +
                       "PV_TELEF_CONTACTE, PV_CODI_MUNICIPI, PV_CODI_PROVINCIA) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        int filas = 0;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, proveidor.getPvCodi());
            ps.setString(2, proveidor.getPvCif().trim());
            ps.setString(3, proveidor.getPvRaoSocial().trim());
            ps.setString(4, proveidor.getPvLinAdreFac().trim());
            ps.setString(5, proveidor.getPvPersonaContacte().trim());
            ps.setString(6, proveidor.getPvTelefContacte().trim());
            ps.setString(7, proveidor.getPvCodiMunicipi().trim());
            ps.setString(8, proveidor.getPvCodiProvincia().trim());

            filas = ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error en afegir(): " + e.getMessage());
        }
        return filas;
    }

    // ✅ 4. Actualizar un proveedor existente
    @Override
    public int actualitzar(Proveidor proveidor) {
        String query = "UPDATE PROVEIDOR SET PV_CIF = ?, PV_RAO_SOCIAL = ?, PV_LIN_ADRE_FAC = ?, PV_PERSONA_CONTACTE = ?, " +
                       "PV_TELEF_CONTACTE = ?, PV_CODI_MUNICIPI = ?, PV_CODI_PROVINCIA = ? WHERE PV_CODI = ?";
        int filas = 0;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, proveidor.getPvCif().trim());
            ps.setString(2, proveidor.getPvRaoSocial().trim());
            ps.setString(3, proveidor.getPvLinAdreFac().trim());
            ps.setString(4, proveidor.getPvPersonaContacte().trim());
            ps.setString(5, proveidor.getPvTelefContacte().trim());
            ps.setString(6, proveidor.getPvCodiMunicipi().trim());
            ps.setString(7, proveidor.getPvCodiProvincia().trim());
            ps.setInt(8, proveidor.getPvCodi());

            filas = ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error en actualitzar(): " + e.getMessage());
        }
        return filas;
    }

    // ✅ 5. Eliminar un proveedor por código
    @Override
    public int eliminar(int pvCodi) {
        String query = "DELETE FROM PROVEIDOR WHERE PV_CODI = ?";
        int filas = 0;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, pvCodi);
            filas = ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error en eliminar(): " + e.getMessage());
        }
        return filas;
    }

    // ✅ 6. Eliminar todos los proveedores
    @Override
    public int eliminarTots() {
        String query = "DELETE FROM PROVEIDOR";
        int filas = 0;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            filas = ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error en eliminarTots(): " + e.getMessage());
        }
        return filas;
    }

    // ✅ 7. Mostrar la cantidad total de proveedores
    @Override
    public int MostrarQt() {
        String query = "SELECT COUNT(*) AS TOTAL FROM PROVEIDOR";
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

    // ✅ 8. Verificar si un proveedor existe según su CIF
    @Override
    public boolean exists(int pvCodi) {
        String query = "SELECT 1 FROM PROVEIDOR WHERE PV_CIF = ?";
        boolean existe = false;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, pvCodi);
            try (ResultSet rs = ps.executeQuery()) {
                existe = rs.next();
            }

        } catch (SQLException e) {
            System.err.println("Error en exists(): " + e.getMessage());
        }
        return existe;
    }

    @Override
    public Proveidor MostrarPerCif(String pvCif) {
        Proveidor p = null;
        String query = "SELECT PV_CODI, PV_CIF, PV_RAO_SOCIAL, PV_LIN_ADRE_FAC, PV_PERSONA_CONTACTE, " +
                       "PV_TELEF_CONTACTE, PV_CODI_MUNICIPI, PV_CODI_PROVINCIA FROM PROVEIDOR WHERE PV_CIF = ?";

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, pvCif.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    p = new Proveidor();
                    p.setPvCodi(rs.getInt("PV_CODI"));
                    p.setPvCif(rs.getString("PV_CIF"));
                    p.setPvRaoSocial(rs.getString("PV_RAO_SOCIAL"));
                    p.setPvLinAdreFac(rs.getString("PV_LIN_ADRE_FAC"));
                    p.setPvPersonaContacte(rs.getString("PV_PERSONA_CONTACTE"));
                    p.setPvTelefContacte(rs.getString("PV_TELEF_CONTACTE"));
                    p.setPvCodiMunicipi(rs.getString("PV_CODI_MUNICIPI"));
                    p.setPvCodiProvincia(rs.getString("PV_CODI_PROVINCIA"));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error en MostrarPerId(): " + e.getMessage());
        }
        return p;
    }

}
