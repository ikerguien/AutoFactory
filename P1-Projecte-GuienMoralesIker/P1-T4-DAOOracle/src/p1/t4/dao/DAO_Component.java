package p1.t4.dao;

import p1.t4.IDAO.IDAO_Component;
import p1.t4.model.Component;
import p1.t4.model.Item;
import p1.t4.model.Proveidor;
import p1.t4.model.UnitatMesura;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class DAO_Component implements IDAO_Component {

    public List<Component> MostrarTots() {
        List<Component> llista = new ArrayList<>();
        // Hacemos JOIN con ITEM para obtener el nombre, stock y descripción
        String query = "SELECT * FROM COMPONENT c INNER JOIN ITEM i ON c.CM_CODI = i.IT_CODI";

        try (Connection conn = Connexio.getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Component c = new Component();

                // 1. Datos de la tabla ITEM (Heredados)
                c.setItCodi(rs.getInt("IT_CODI"));
                c.setCmCodi(rs.getInt("IT_CODI")); // El código es el mismo
                c.setItNom(rs.getString("IT_NOM"));
                c.setItDescripio(rs.getString("IT_DESCRIPCIO"));
                c.setItStock(rs.getInt("IT_STOCK"));
                c.setItTipus(rs.getString("IT_TIPUS"));
                c.setItFoto(rs.getBytes("IT_FOTO"));

                // 2. Datos de la tabla COMPONENT
                c.setCmCodiFabricant(rs.getString("CM_CODI_FABRICANT"));
                c.setCmPreuMig(rs.getDouble("CM_PREU_MIG"));
                c.setCmUmCodi(rs.getInt("CM_UM_CODI"));

                // 3. LA CLAVE: Cargamos los precios de PROV_COMP para este componente
                // Esto rellena el HashMap que usas en el JSP
                c.setCompra(this.obtenerPreciosPorProveedor(c.getItCodi()));

                llista.add(c);
            }
        } catch (SQLException e) {
            System.err.println("Error en DAO_Component.MostrarTots: " + e.getMessage());
        }
        return llista;
    }

    public Component MostrarPerId(int id) {
        Component c = null;
        // Hacemos JOIN para traer los datos de ITEM y COMPONENT a la vez
        String sql = "SELECT i.IT_NOM, i.IT_DESCRIPCIO, i.IT_STOCK, "
                + "c.CM_CODI_FABRICANT, c.CM_PREU_MIG, c.CM_UM_CODI "
                + "FROM ITEM i "
                + "INNER JOIN COMPONENT c ON i.IT_CODI = c.CM_CODI "
                + "WHERE i.IT_CODI = ?";

        try (Connection conn = Connexio.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    c = new Component();
                    c.setItCodi(id);
                    // Datos de la tabla ITEM
                    c.setItNom(rs.getString("IT_NOM"));
                    c.setItDescripio(rs.getString("IT_DESCRIPCIO"));
                    c.setItStock(rs.getInt("IT_STOCK"));

                    // Datos de la tabla COMPONENT
                    c.setCmCodiFabricant(rs.getString("CM_CODI_FABRICANT"));
                    c.setCmPreuMig(rs.getInt("CM_PREU_MIG"));
                    c.setCmUmCodi(rs.getInt("CM_UM_CODI"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en DAO_Component.MostrarPerId: " + e.getMessage());
        }
        return c;
    }

    public int eliminarTodosProveedoresDeComponente(int idComponente) {
        String sql = "DELETE FROM PROV_COMP WHERE CM_CODI = ?"; // CM_CODI es la FK del componente
        int filasBorradas = 0;

        // Uso de try-with-resources para asegurar que se cierre la conexión
        try (Connection conn = Connexio.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idComponente);
            filasBorradas = ps.executeUpdate();

        } catch (java.sql.SQLException e) {
            System.err.println("Error al borrar proveedores del componente: " + e.getMessage());
        }

        return filasBorradas;
    }

    @Override
    public int Afegir(Component component) {
        // ELIMINAMOS todos los campos IT_... del SQL
        // Solo dejamos los que pertenecen a la tabla COMPONENT
        String sql = "INSERT INTO COMPONENT (CM_CODI, CM_CODI_FABRICANT, CM_PREU_MIG, CM_UM_CODI) VALUES (?, ?, ?, ?)";
        int filasAfectadas = 0;

        try (Connection conn = Connexio.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            // 1. CM_CODI es el ID que recuperamos del Item (nuevoId)
            ps.setInt(1, component.getCmCodi());

            // 2. Datos específicos de componente
            ps.setString(2, component.getCmCodiFabricant());
            ps.setDouble(3, component.getCmPreuMig());
            ps.setInt(4, component.getCmUmCodi());

            filasAfectadas = ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error al guardar en la tabla COMPONENT: " + e.getMessage());
            e.printStackTrace();
        }

        return filasAfectadas;
    }

    @Override
    public int Actualitzar(Component component) {
        int filas = 0;
        String query = "UPDATE COMPONENT SET CM_CODI_FABRICANT = ?, CM_PREU_MIG = ?, CM_UM_CODI = ?, IT_CODI = ?, IT_NOM = ?, IT_DESCRIPIO = ?, IT_FOTO = ?, IT_STOCK = ?, IT_TIPUS = ? WHERE CM_CODI = ?";

        try (Connection conn = Connexio.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, component.getCmCodiFabricant());
            ps.setDouble(2, component.getCmPreuMig());
            ps.setInt(3, component.getCmUmCodi());  // Cambiado a int
            ps.setInt(4, component.getItCodi());  // Cambiado a int
            ps.setString(5, component.getItNom());
            ps.setString(6, component.getItDescripio());
            ps.setBytes(7, component.getItFoto());  // Foto como byte[]
            ps.setInt(8, component.getItStock());
            ps.setString(9, component.getItTipus());
            ps.setInt(10, component.getCmCodi());  // Cambiado a int

            filas = ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error en Actualitzar(): " + e.getMessage());
        }

        return filas;
    }

    @Override
    public int Eliminar(int cmCodi) {
        int filas = 0;
        String query = "DELETE FROM COMPONENT WHERE CM_CODI = ?";

        try (Connection conn = Connexio.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, cmCodi);  // Cambiado a int
            filas = ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error en Eliminar(): " + e.getMessage());
        }

        return filas;
    }

    @Override
    public List<Component> MostraPerItem(int itCodi) {
        List<Component> components = new ArrayList<>();
        String query = "SELECT * FROM COMPONENT WHERE IT_CODI = ?";  // Suponiendo que hay una relación entre COMPONENT e ITEM

        try (Connection conn = Connexio.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, itCodi);  // Se pasa el código del Item

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Component component = new Component();
                    component.setCmCodi(rs.getInt("CM_CODI"));  // Cambiado a int
                    component.setCmCodiFabricant(rs.getString("CM_CODI_FABRICANT"));
                    component.setCmPreuMig(rs.getDouble("CM_PREU_MIG"));
                    component.setCmUmCodi(rs.getInt("CM_UM_CODI"));  // Cambiado a int

                    // El Item asociado es el propio 'component', ya que 'Component' es un tipo de 'Item'
                    component.setItCodi(rs.getInt("IT_CODI"));  // Cambiado a int
                    component.setItNom(rs.getString("IT_NOM"));
                    component.setItDescripio(rs.getString("IT_DESCRIPCIO"));

                    // Cargar el BLOB (foto) y convertirlo a byte[]
                    byte[] fotoBytes = rs.getBytes("IT_FOTO");
                    component.setItFoto(fotoBytes);  // Guardamos la foto como byte[]

                    component.setItStock(rs.getInt("IT_STOCK"));
                    component.setItTipus(rs.getString("IT_TIPUS"));

                    // Aquí solo asignamos el código de la unidad de medida (ya no es necesario crear la instancia de UnitatMesura)
                    component.setCmUmCodi(rs.getInt("CM_UM_CODI"));  // Asignamos solo el código de la unidad de medida

                    components.add(component);  // Añadimos el componente a la lista
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en MostraPerItem(): " + e.getMessage());
        }

        return components;
    }

    @Override
    public List<Component> MostraPerUnitatMesura(int cmUmCodi) {
        List<Component> components = new ArrayList<>();
        String query = "SELECT * FROM COMPONENT WHERE CM_UM_CODI = ?";  // Buscamos componentes con la unidad de medida indicada

        try (Connection conn = Connexio.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, cmUmCodi);  // Se pasa el código de la unidad de medida

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Component component = new Component();
                    component.setCmCodi(rs.getInt("CM_CODI"));  // Cambiado a int
                    component.setCmCodiFabricant(rs.getString("CM_CODI_FABRICANT"));
                    component.setCmPreuMig(rs.getDouble("CM_PREU_MIG"));
                    component.setCmUmCodi(rs.getInt("CM_UM_CODI"));  // Cambiado a int

                    // El Item asociado es el propio 'component', ya que 'Component' es un tipo de 'Item'
                    component.setItCodi(rs.getInt("IT_CODI"));  // Cambiado a int
                    component.setItNom(rs.getString("IT_NOM"));
                    component.setItDescripio(rs.getString("IT_DESCRIPIO"));

                    // Cargar el BLOB (foto) y convertirlo a byte[]
                    byte[] fotoBytes = rs.getBytes("IT_FOTO");
                    component.setItFoto(fotoBytes);  // Guardamos la foto como byte[]

                    component.setItStock(rs.getInt("IT_STOCK"));
                    component.setItTipus(rs.getString("IT_TIPUS"));

                    // Aquí solo asignamos el código de la unidad de medida (ya no es necesario crear la instancia de UnitatMesura)
                    component.setCmUmCodi(rs.getInt("CM_UM_CODI"));  // Asignamos solo el código de la unidad de medida

                    components.add(component);  // Añadimos el componente a la lista
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en MostraPerUnitatMesura(): " + e.getMessage());
        }

        return components;
    }

    @Override
    public int eliminarTots() {
        int filasEliminadas = 0;
        String query = "DELETE FROM COMPONENT";  // Eliminar todos los componentes

        try (Connection conn = Connexio.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            filasEliminadas = ps.executeUpdate();  // Ejecutamos la eliminación

        } catch (SQLException e) {
            System.err.println("Error en eliminarTots(): " + e.getMessage());
        }

        return filasEliminadas;
    }

    @Override
    public int mostrarQt() {
        int totalComponentes = 0;
        String query = "SELECT COUNT(*) FROM COMPONENT";  // Contamos todos los registros en la tabla COMPONENT

        try (Connection conn = Connexio.getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                totalComponentes = rs.getInt(1);  // Obtenemos el resultado de la consulta (número total de componentes)
            }

        } catch (SQLException e) {
            System.err.println("Error en mostrarQt(): " + e.getMessage());
        }

        return totalComponentes;
    }

    @Override
    public boolean exists(int cmCodi) {
        boolean exists = false;
        String query = "SELECT 1 FROM COMPONENT WHERE CM_CODI = ?";

        try (Connection conn = Connexio.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, cmCodi);  // Se pasa el código del componente
            try (ResultSet rs = ps.executeQuery()) {
                exists = rs.next();
            }

        } catch (SQLException e) {
            System.err.println("Error en exists(): " + e.getMessage());
        }

        return exists;
    }

    // Método para guardar la relación entre el componente y su proveedor con el precio
    public int vincularProveedor(int cmCodi, int pvCodi, double preu) {
        // Usamos PROV_COMP y sus nombres de columna exactos
        String sql = "INSERT INTO PROV_COMP (PC_CM_IT_CODI, PC_PV_CODI, PC_PREU) VALUES (?, ?, ?)";
        int filasAfectadas = 0;

        try (Connection conn = Connexio.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cmCodi); // PC_CM_IT_CODI
            ps.setInt(2, pvCodi); // PC_PV_CODI
            ps.setDouble(3, preu); // PC_PREU

            filasAfectadas = ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error en vincularProveedor: " + e.getMessage());
        }
        return filasAfectadas;
    }

    public HashMap<Proveidor, java.math.BigDecimal> obtenerPreciosPorProveedor(int idComponente) {
        HashMap<Proveidor, java.math.BigDecimal> mapa = new HashMap<>();

        // SQL ajustada a tus nombres reales de columna:
        // PROVEIDOR.PV_CODI se junta con PROV_COMP.PC_PV_CODI
        String sql = "SELECT P.PV_CODI, P.PV_RAO_SOCIAL, P.PV_CIF, PC.PC_PREU "
                + "FROM PROVEIDOR P "
                + "INNER JOIN PROV_COMP PC ON P.PV_CODI = PC.PC_PV_CODI "
                + "WHERE PC.PC_CM_IT_CODI = ?";

        try (Connection conn = Connexio.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idComponente);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Proveidor prov = new Proveidor();
                    prov.setPvCodi(rs.getInt("PV_CODI"));
                    prov.setPvRaoSocial(rs.getString("PV_RAO_SOCIAL"));
                    prov.setPvCif(rs.getString("PV_CIF"));

                    // Ojo: la columna de precio se llama PC_PREU según tu script
                    mapa.put(prov, rs.getBigDecimal("PC_PREU"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en obtenerPreciosPorProveedor: " + e.getMessage());
        }
        return mapa;
    }

}
