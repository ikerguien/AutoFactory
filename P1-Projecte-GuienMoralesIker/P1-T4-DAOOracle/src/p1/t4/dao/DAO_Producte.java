package p1.t4.dao;

import p1.t4.IDAO.IDAO_Producte;
import p1.t4.model.Item;
import p1.t4.model.Producte;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DAO_Producte implements IDAO_Producte {

    // Método para mostrar todos los productos
    @Override
    public List<Producte> MostrarTots() {
        List<Producte> productes = new ArrayList<>();
        String query = "SELECT * FROM PRODUCTE";  // Consulta para obtener todos los productos

        try (Connection conn = Connexio.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                Producte producte = new Producte();
                producte.setPrCodi(rs.getInt("PR_CODI"));  // Cambiado a int

                // Establecer los atributos heredados de Item directamente
                producte.setItCodi(rs.getInt("IT_CODI"));  // Cambiado a int
                producte.setItNom(rs.getString("IT_NOM"));
                producte.setItTipus(rs.getString("IT_TIPUS"));

                productes.add(producte);
            }

        } catch (SQLException e) {
            System.err.println("Error en MostrarTots(): " + e.getMessage());
        }
        return productes;
    }

    // Método para mostrar un producto por su código
    @Override
public Producte MostrarPerId(int prCodi) {
    Producte producte = null;
    // 1. Consulta para datos básicos del Producto e Item
    String queryPrincipal = "SELECT p.PR_CODI, i.* " + 
                             "FROM PRODUCTE p " +
                             "JOIN ITEM i ON p.IT_CODI = i.IT_CODI " +
                             "WHERE p.PR_CODI = ?";
    
    // 2. Consulta para traerse los "ingredientes" (subitems)
    String querySubitems = "SELECT pi.PI_IT_CODI, pi.PI_QUANTITAT, i.IT_NOM " +
                            "FROM PROD_ITEM pi " +
                            "JOIN ITEM i ON pi.PI_IT_CODI = i.IT_CODI " +
                            "WHERE pi.PI_PR_CODI = ?";

    try (Connection conn = Connexio.getConnection()) {
        // --- PASO 1: Cargar el producto ---
        try (PreparedStatement ps = conn.prepareStatement(queryPrincipal)) {
            ps.setInt(1, prCodi);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    producte = new Producte();
                    producte.setPrCodi(rs.getInt("PR_CODI"));
                    producte.setItCodi(rs.getInt("IT_CODI"));
                    producte.setItNom(rs.getString("IT_NOM"));
                    producte.setItTipus(rs.getString("IT_TIPUS"));
                    producte.setItStock(rs.getInt("IT_STOCK"));
                    // producte.setItDescripio(rs.getString("IT_DESCRIPCIO"));
                }
            }
        }

        // --- PASO 2: Si el producto existe, cargar sus subitems ---
        if (producte != null) {
            try (PreparedStatement psSub = conn.prepareStatement(querySubitems)) {
                psSub.setInt(1, prCodi);
                try (ResultSet rsSub = psSub.executeQuery()) {
                    while (rsSub.next()) {
                        Item hijo = new Item();
                        hijo.setItCodi(rsSub.getInt("PI_IT_CODI"));
                        hijo.setItNom(rsSub.getString("IT_NOM"));
                        
                        int cantidad = rsSub.getInt("PI_QUANTITAT");
                        
                        // Metemos el hijo en el mapa del producto
                        producte.addSubitem(hijo, cantidad);
                    }
                }
            }
        }

    } catch (SQLException e) {
        System.err.println("Error en MostrarPerId completo: " + e.getMessage());
    }

    return producte;
}




@Override
public int Afegir(Producte producte) {
    String queryGetId = "SELECT ITEM_SEQ.NEXTVAL FROM DUAL";
    String queryItem = "INSERT INTO ITEM (IT_CODI, IT_TIPUS, IT_NOM, IT_DESCRIPCIO, IT_STOCK, IT_FOTO) VALUES (?, ?, ?, ?, ?, ?)";
    String queryProducte = "INSERT INTO PRODUCTE (PR_CODI) VALUES (?)"; 
    String querySubitems = "INSERT INTO PROD_ITEM (PI_PR_CODI, PI_IT_CODI, PI_QUANTITAT) VALUES (?, ?, ?)";

    Connection conn = null;
    try {
        System.out.println("DEBUG DAO: Iniciando proceso de guardado de producto...");
        conn = Connexio.getConnection();
        conn.setAutoCommit(false); 

        int idGenerado = 0;

        // 1. Obtener ID de la secuencia
        try (PreparedStatement psId = conn.prepareStatement(queryGetId);
             ResultSet rs = psId.executeQuery()) {
            if (rs.next()) {
                idGenerado = rs.getInt(1);
                System.out.println("DEBUG DAO: ID generado por secuencia: " + idGenerado);
            }
        }

        if (idGenerado == 0) throw new SQLException("No se pudo obtener el ID de la secuencia.");

        // 2. Insertar en ITEM
        try (PreparedStatement psItem = conn.prepareStatement(queryItem)) {
            psItem.setInt(1, idGenerado);
            psItem.setString(2, "P"); 
            psItem.setString(3, producte.getItNom());
            psItem.setString(4, producte.getItDescripio());
            psItem.setInt(5, producte.getItStock());
            
            if (producte.getItFoto() != null) {
                psItem.setBytes(6, producte.getItFoto());
                System.out.println("DEBUG DAO: Foto detectada (" + producte.getItFoto().length + " bytes)");
            } else {
                psItem.setNull(6, java.sql.Types.BLOB);
                System.out.println("DEBUG DAO: Sin foto adjunta");
            }
            int rowsItem = psItem.executeUpdate();
            System.out.println("DEBUG DAO: Insert en ITEM finalizado (filas: " + rowsItem + ")");
        }

        // 3. Insertar en PRODUCTE
        try (PreparedStatement psProd = conn.prepareStatement(queryProducte)) {
            psProd.setInt(1, idGenerado);
            int rowsProd = psProd.executeUpdate();
            System.out.println("DEBUG DAO: Insert en PRODUCTE finalizado (filas: " + rowsProd + ")");
        }

        // 4. Insertar en PROD_ITEM (Relación con componentes/hijos)
        int numSubitems = (producte.getSubitems() != null) ? producte.getSubitems().size() : 0;
        System.out.println("DEBUG DAO: Preparando inserción de " + numSubitems + " subitems en PROD_ITEM");

        if (numSubitems > 0) {
            try (PreparedStatement psSub = conn.prepareStatement(querySubitems)) {
                for (java.util.Map.Entry<p1.t4.model.Item, Integer> entry : producte.getSubitems().entrySet()) {
                    int hijoId = entry.getKey().getItCodi();
                    int cantidad = entry.getValue();
                    
                    System.out.println("DEBUG DAO: -> Añadiendo al batch: Padre=" + idGenerado + ", Hijo=" + hijoId + ", Cant=" + cantidad);
                    
                    psSub.setInt(1, idGenerado);
                    psSub.setInt(2, hijoId);
                    psSub.setInt(3, cantidad);
                    psSub.addBatch();
                }
                int[] results = psSub.executeBatch();
                System.out.println("DEBUG DAO: Batch de subitems ejecutado con éxito. Registros: " + results.length);
            }
        } else {
            System.out.println("DEBUG DAO: No se detectaron subitems para este producto.");
        }

        conn.commit(); 
        System.out.println("DEBUG DAO: COMMIT realizado con éxito. ID final: " + idGenerado);
        return idGenerado;

    } catch (SQLException e) {
        System.err.println("!!! ERROR SQL EN DAO_PRODUCTE: " + e.getMessage());
        if (conn != null) {
            try { 
                conn.rollback(); 
                System.err.println("DEBUG DAO: ROLLBACK ejecutado debido al error.");
            } catch (SQLException ex) { 
                ex.printStackTrace(); 
            }
        }
        e.printStackTrace(); 
        return 0;
    } finally {
        if (conn != null) {
            try { 
                conn.setAutoCommit(true); 
                conn.close(); 
                System.out.println("DEBUG DAO: Conexión cerrada.");
            } catch (SQLException e) { 
                e.printStackTrace(); 
            }
        }
    }
}

    // Método para actualizar un producto
    @Override
public int Actualitzar(Producte producte) {
    String queryUpdateProd = "UPDATE PRODUCTE SET IT_CODI = ? WHERE PR_CODI = ?";
    String queryDeleteSubs = "DELETE FROM PROD_ITEM WHERE PI_PR_CODI = ?";
    String queryInsertSubs = "INSERT INTO PROD_ITEM (PI_PR_CODI, PI_IT_CODI, PI_QUANTITAT) VALUES (?, ?, ?)";

    Connection conn = null;
    try {
        conn = Connexio.getConnection();
        conn.setAutoCommit(false);

        // 1. Actualizar tabla principal
        try (PreparedStatement ps = conn.prepareStatement(queryUpdateProd)) {
            ps.setInt(1, producte.getItCodi());
            ps.setInt(2, producte.getPrCodi());
            ps.executeUpdate();
        }

        // 2. Borrar subitems viejos
        try (PreparedStatement psDel = conn.prepareStatement(queryDeleteSubs)) {
            psDel.setInt(1, producte.getPrCodi());
            psDel.executeUpdate();
        }

        // 3. Insertar los nuevos del HashMap
        if (producte.getSubitems() != null) {
            try (PreparedStatement psIns = conn.prepareStatement(queryInsertSubs)) {
                for (java.util.Map.Entry<p1.t4.model.Item, Integer> entry : producte.getSubitems().entrySet()) {
                    psIns.setInt(1, producte.getPrCodi());
                    psIns.setInt(2, entry.getKey().getItCodi());
                    psIns.setInt(3, entry.getValue());
                    psIns.addBatch();
                }
                psIns.executeBatch();
            }
        }

        conn.commit();
        return 1;
    } catch (SQLException e) {
        if (conn != null) try { conn.rollback(); } catch (Exception ex) {}
        return 0;
    }
}

    // Método para eliminar un producto por su código
    @Override
    public int Eliminar(int prCodi) {  // Cambiado a int
        String query = "DELETE FROM PRODUCTE WHERE PR_CODI = ?";

        try (Connection conn = Connexio.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            // Asignar el parámetro
            ps.setInt(1, prCodi);  // Cambiado a int

            return ps.executeUpdate();  // Ejecutar la eliminación

        } catch (SQLException e) {
            System.err.println("Error en Eliminar(): " + e.getMessage());
            return 0;  // Si ocurre un error, devolver 0
        }
    }

    // Método para eliminar todos los productos
    @Override
    public int EliminarTots() {
        String query = "DELETE FROM PRODUCTE";

        try (Connection conn = Connexio.getConnection(); Statement stmt = conn.createStatement()) {

            return stmt.executeUpdate(query);  // Ejecutar la eliminación de todos los productos

        } catch (SQLException e) {
            System.err.println("Error en EliminarTots(): " + e.getMessage());
            return 0;  // Si ocurre un error, devolver 0
        }
    }

    // Método para obtener el número total de productos
    @Override
    public int MostrarQt() {
        String query = "SELECT COUNT(*) FROM PRODUCTE";

        try (Connection conn = Connexio.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {

            if (rs.next()) {
                return rs.getInt(1);  // Devolver el número total de productos
            }

        } catch (SQLException e) {
            System.err.println("Error en MostrarQt(): " + e.getMessage());
        }

        return 0;
    }

    // Método para verificar si un producto existe por su código
    @Override
    public boolean exists(int prCodi) {  // Cambiado a int
        String query = "SELECT 1 FROM PRODUCTE WHERE PR_CODI = ?";

        try (Connection conn = Connexio.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, prCodi);  // Cambiado a int
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();  // Si devuelve algún registro, el producto existe
            }

        } catch (SQLException e) {
            System.err.println("Error en exists(): " + e.getMessage());
        }

        return false;
    }

    @Override
    public List<Producte> MostrarConFiltro(int id, String nombre, String categoria) {
        List<Producte> productes = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT * FROM PRODUCTE WHERE 1=1");

        // Usamos el StringBuilder para agregar condiciones dinámicamente
        if (id > 0) {  // id es int, no String, por lo que solo verificamos si es mayor que 0
            query.append(" AND PR_CODI = ?");
        }
        if (nombre != null && !nombre.trim().isEmpty()) {
            query.append(" AND NOM LIKE ?");
        }
        if (categoria != null && !categoria.trim().isEmpty()) {
            query.append(" AND CATEGORIA = ?");
        }

        // Ejecutar la consulta dinámica
        try (Connection conn = Connexio.getConnection(); PreparedStatement ps = conn.prepareStatement(query.toString())) {

            int paramIndex = 1;  // Índice de los parámetros en la consulta
            if (id > 0) {  // id es int, por lo que ya no es necesario convertirlo a String
                ps.setInt(paramIndex++, id);  // Establecemos 'id' como int
            }
            if (nombre != null && !nombre.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + nombre + "%");  // Usamos LIKE para búsqueda parcial en nombre
            }
            if (categoria != null && !categoria.trim().isEmpty()) {
                ps.setString(paramIndex++, categoria);
            }

            // Ejecutar la consulta y procesar los resultados
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Producte producte = new Producte();
                    producte.setPrCodi(rs.getInt("PR_CODI"));  // Cambiado a int

                    // Establecer los atributos heredados de Item directamente
                    producte.setItCodi(rs.getInt("IT_CODI"));  // Cambiado a int
                    producte.setItNom(rs.getString("IT_NOM"));
                    producte.setItTipus(rs.getString("IT_TIPUS"));

                    // Puedes agregar más atributos si es necesario
                    productes.add(producte);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en MostrarConFiltro(): " + e.getMessage());
        }

        return productes;
    }

}
