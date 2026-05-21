package p1.t4.dao;

import p1.t4.IDAO.IDAO_Item;
import p1.t4.model.Item;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DAO_Item implements IDAO_Item {

    // 1. Mostrar todos los items
    @Override
    public List<Item> MostrarTots() {
        List<Item> items = new ArrayList<>();
        String query = "SELECT * FROM ITEM";  // Suponiendo que tienes una tabla ITEM

        try (Connection conn = Connexio.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                Item item = new Item();  // Ahora instanciamos un Item directamente
                item.setItCodi(rs.getInt("IT_CODI"));  // Asegúrate de que itCodi sea un int
                item.setItNom(rs.getString("IT_NOM"));
                item.setItDescripio(rs.getString("IT_DESCRIPCIO"));

                // Obtener el BLOB y convertirlo a un array de bytes
                //byte[] fotoBytes = rs.getBytes("IT_FOTO");  // Usamos getBytes para BLOB
                  // Guardamos la foto como byte[]

                item.setItStock(rs.getInt("IT_STOCK"));
                item.setItTipus(rs.getString("IT_TIPUS"));
                item.setItFoto(rs.getBytes("IT_FOTO"));

                items.add(item);
            }

        } catch (SQLException e) {
            System.err.println("Error en MostrarTots(): " + e.getMessage());
        }

        return items;
    }
    
    public List<Item> obtenerItemsDeProducto(int prodCodi) {
    List<Item> items = new ArrayList<>();
    String query = "SELECT i.*, pi.PI_QUANTITAT " +
                   "FROM ITEM i " +
                   "JOIN PROD_ITEM pi ON i.IT_CODI = pi.PI_IT_CODI " +
                   "WHERE pi.PI_PR_CODI = ?";

    try (Connection conn = Connexio.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {

        ps.setInt(1, prodCodi);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Item item = new Item();
                item.setItCodi(rs.getInt("IT_CODI"));
                item.setItNom(rs.getString("IT_NOM"));
                item.setItDescripio(rs.getString("IT_DESCRIPCIO"));
                item.setItStock(rs.getInt("IT_STOCK"));
                item.setItTipus(rs.getString("IT_TIPUS"));
                
                // Guardamos la cantidad dentro del objeto Item para usarla en el JSP
                item.setCantidad(rs.getInt("PI_QUANTITAT"));

                items.add(item);
            }
        }

    } catch (SQLException e) {
        System.err.println("Error obtenerItemsDelProducto(): " + e.getMessage());
    }

    return items;
}

    // 2. Mostrar un item por su código
    @Override
  public Item MostraPerId(int itCodi) {
      Item item = null;
      String query = "SELECT * FROM ITEM WHERE IT_CODI = ?"; 

      try (Connection conn = Connexio.getConnection();
           PreparedStatement ps = conn.prepareStatement(query)) {

          ps.setInt(1, itCodi);
          try (ResultSet rs = ps.executeQuery()) {
              if (rs.next()) {
                  item = new Item();
                  item.setItCodi(rs.getInt("IT_CODI"));
                  item.setItNom(rs.getString("IT_NOM"));
                  item.setItDescripio(rs.getString("IT_DESCRIPCIO"));

                  // --- CORRECCIÓN AQUÍ: Descomentar y asignar ---
                  byte[] fotoBytes = rs.getBytes("IT_FOTO");
                  item.setItFoto(fotoBytes); 

                  item.setItStock(rs.getInt("IT_STOCK"));
                  item.setItTipus(rs.getString("IT_TIPUS"));
              }
          }
      } catch (SQLException e) {
          System.err.println("Error en MostraPerId(): " + e.getMessage());
      }
      return item;
  }

    // 3. Mostrar items por tipo
    @Override
    public List<Item> MostraPerTipus(String itTipus) {
        List<Item> items = new ArrayList<>();
        String query = "SELECT * FROM ITEM WHERE TRIM(IT_TIPUS) = ?";

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, itTipus.trim());  // Usamos trim() para asegurarnos de que no haya espacios al principio o al final
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Item item = new Item();  // Instanciamos un Item directamente
                    item.setItCodi(rs.getInt("IT_CODI"));
                    item.setItNom(rs.getString("IT_NOM"));
                    item.setItDescripio(rs.getString("IT_DESCRIPCIO"));

                    // Obtener el BLOB y convertirlo a un array de bytes
                    //byte[] fotoBytes = rs.getBytes("IT_FOTO");
                    //item.setItFoto(fotoBytes);  // Guardamos como byte[]

                    item.setItStock(rs.getInt("IT_STOCK"));
                    item.setItTipus(rs.getString("IT_TIPUS").trim());

                    items.add(item);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error en MostraPerTipus(): " + e.getMessage());
        }

        return items;
    }

    // 4. Agregar un nuevo item
@Override
public int Afegir(Item item) {
        // El orden es: 1:NOM, 2:DESCRIPCIO, 3:FOTO, 4:STOCK, 5:TIPUS
        String query = "INSERT INTO ITEM (IT_CODI, IT_NOM, IT_DESCRIPCIO, IT_FOTO, IT_STOCK, IT_TIPUS) " +
                       "VALUES (ITEM_SEQ.NEXTVAL, ?, ?, ?, ?, ?)";
        
        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query, new String[] {"IT_CODI"})) {

            ps.setString(1, item.getItNom());
            ps.setString(2, item.getItDescripio());
            
            // --- MANEJO DE FOTO ---
            if (item.getItFoto() != null && item.getItFoto().length > 0) {
                ps.setBytes(3, item.getItFoto()); 
            } else {
                ps.setNull(3, java.sql.Types.BLOB);
            }
            
            ps.setInt(4, item.getItStock());
            ps.setString(5, item.getItTipus());

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Retorna el ID generado por la secuencia
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en Afegir(): " + e.getMessage());
        }
        return 0;
    }
    
    // 5. Actualizar un item
@Override
public int Actualitzar(Item item) {
    // 1. Decidimos el SQL basándonos en si hay foto o no
    boolean tieneFoto = (item.getItFoto() != null && item.getItFoto().length > 0);
    
    String query;
    if (tieneFoto) {
        query = "UPDATE ITEM SET IT_NOM = ?, IT_DESCRIPCIO = ?, IT_FOTO = ?, IT_STOCK = ?, IT_TIPUS = ? WHERE IT_CODI = ?";
    } else {
        // Si no hay foto, simplemente NO tocamos esa columna
        query = "UPDATE ITEM SET IT_NOM = ?, IT_DESCRIPCIO = ?, IT_STOCK = ?, IT_TIPUS = ? WHERE IT_CODI = ?";
    }

    int rowsAffected = 0;

    try (Connection conn = Connexio.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {

        ps.setString(1, item.getItNom());
        ps.setString(2, item.getItDescripio());

        if (tieneFoto) {
            ps.setBytes(3, item.getItFoto());
            ps.setInt(4, item.getItStock());
            ps.setString(5, item.getItTipus());
            ps.setInt(6, item.getItCodi());
        } else {
            // Reajustamos los índices porque el parámetro 3 ya no es la foto
            ps.setInt(3, item.getItStock());
            ps.setString(4, item.getItTipus());
            ps.setInt(5, item.getItCodi());
        }

        rowsAffected = ps.executeUpdate();

    } catch (SQLException e) {
        System.err.println("Error en Actualitzar(): " + e.getMessage());
    }

    return rowsAffected;
}

public int eliminarTodosSubitemsDeProducto(int prodCodi) {
    String query = "DELETE FROM PROD_COMP WHERE PD_PROD_CODI = ?"; // Ajusta el nombre de tabla/columna
    try (Connection conn = Connexio.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        ps.setInt(1, prodCodi);
        return ps.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
        return 0;
    }
}
    // 6. Eliminar un item por su código
@Override
public int Eliminar(int itCodi) {
    try (Connection conn = Connexio.getConnection()) {
        
        // 1. Comprovar si és fill d'algun producte (no es pot eliminar)
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT COUNT(*) FROM PROD_ITEM WHERE PI_IT_CODI = ?")) {
            ps.setInt(1, itCodi);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return -1; // Té dependències, no es pot eliminar
            }
        }

        // 2. Si és producte, eliminar els seus subitems de PROD_ITEM
        try (PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM PROD_ITEM WHERE PI_PR_CODI = ?")) {
            ps.setInt(1, itCodi);
            ps.executeUpdate();
        }

        // 3. Si és component, eliminar els seus proveïdors de PROV_COMP
        try (PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM PROV_COMP WHERE PC_CM_IT_CODI = ?")) {
            ps.setInt(1, itCodi);
            ps.executeUpdate();
        }

        // 4. Eliminar de COMPONENT (si és component)
        try (PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM COMPONENT WHERE CM_CODI = ?")) {
            ps.setInt(1, itCodi);
            ps.executeUpdate();
        }

        // 5. Eliminar de PRODUCTE (si és producte)
        try (PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM PRODUCTE WHERE PR_CODI = ?")) {
            ps.setInt(1, itCodi);
            ps.executeUpdate();
        }

        // 6. Finalment eliminar de ITEM
        try (PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM ITEM WHERE IT_CODI = ?")) {
            ps.setInt(1, itCodi);
            return ps.executeUpdate();
        }

    } catch (SQLException e) {
        System.err.println("Error en Eliminar(): " + e.getMessage());
        return 0;
    }
}

    // 7. Eliminar todos los items
    @Override
    public int EliminarTots() {
        String query = "DELETE FROM ITEM";
        int rowsAffected = 0;

        try (Connection conn = Connexio.getConnection();
             Statement stmt = conn.createStatement()) {

            rowsAffected = stmt.executeUpdate(query);

        } catch (SQLException e) {
            System.err.println("Error en EliminarTots(): " + e.getMessage());
        }

        return rowsAffected;
    }

    // 8. Obtener la cantidad de items
    @Override
    public int MostrarQt() {
        String query = "SELECT COUNT(*) FROM ITEM";
        int count = 0;

        try (Connection conn = Connexio.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (SQLException e) {
            System.err.println("Error en MostrarQt(): " + e.getMessage());
        }

        return count;
    }
    
    public int actualizarCantidadEnProducto(int prodCodi, int itemCodi, int cantidad){
    String query = "UPDATE PROD_ITEM SET PI_QUANTITAT = ? WHERE PI_PR_CODI = ? AND PI_IT_CODI = ?";
    try(Connection conn = Connexio.getConnection();
        PreparedStatement ps = conn.prepareStatement(query)){
        ps.setInt(1, cantidad);
        ps.setInt(2, prodCodi);
        ps.setInt(3, itemCodi);
        return ps.executeUpdate();
    } catch(SQLException e){
        System.err.println("Error en actualizarCantidadEnProducto(): " + e.getMessage());
        return 0;
    }
}

    // 9. Verificar si un item existe por su código
    @Override
    public boolean exists(int itCodi) {
        String query = "SELECT 1 FROM ITEM WHERE IT_CODI = ?";
        boolean exists = false;

        try (Connection conn = Connexio.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, itCodi);  // Cambié el tipo a int para que sea coherente con el modelo
            try (ResultSet rs = ps.executeQuery()) {
                exists = rs.next();
            }

        } catch (SQLException e) {
            System.err.println("Error en exists(): " + e.getMessage());
        }

        return exists;
    }
    
    // Agregar subitem a PROD_ITEM
    public int agregarSubitemEnProducto(int prodCodi, int subitemCodi, int cantidad) {
        // CORRECCIÓN: Usamos la tabla PROD_ITEM y las columnas correctas (PI_...)
        String sql = "INSERT INTO PROD_ITEM (PI_PR_CODI, PI_IT_CODI, PI_QUANTITAT) VALUES (?, ?, ?)";
        
        try (Connection conn = Connexio.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, prodCodi);      // ID del Producto Padre
            ps.setInt(2, subitemCodi);   // ID del Item Hijo
            ps.setInt(3, cantidad);      // Cantidad
            
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
public List<Item> buscarItems(String busqueda) {
    List<Item> items = new ArrayList<>();
    String query = "SELECT * FROM ITEM WHERE IT_NOM LIKE ? OR IT_CODI = ?";

    try (Connection conn = Connexio.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {
        
        ps.setString(1, "%" + busqueda + "%");

        // Intentamos convertir a número, si no es número, ponemos un ID imposible (-1)
        int idBusqueda;
        try {
            idBusqueda = Integer.parseInt(busqueda);
        } catch (NumberFormatException e) {
            idBusqueda = -1; 
        }
        ps.setInt(2, idBusqueda);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Item item = new Item();
                item.setItCodi(rs.getInt("IT_CODI"));
                item.setItNom(rs.getString("IT_NOM"));
                item.setItDescripio(rs.getString("IT_DESCRIPCIO"));
                item.setItTipus(rs.getString("IT_TIPUS"));
                item.setItStock(rs.getInt("IT_STOCK"));
                items.add(item);
            }
        }
    } catch (SQLException e) {
        System.err.println("Error en la consulta: " + e.getMessage());
    }
    return items;
}

// Eliminar subitem de PROD_ITEM
public int eliminarSubitemDeProducto(int prodCodi, int itemCodi){
    String query = "DELETE FROM PROD_ITEM WHERE PI_PR_CODI = ? AND PI_IT_CODI = ?";
    try(Connection conn = Connexio.getConnection();
        PreparedStatement ps = conn.prepareStatement(query)){
        ps.setInt(1, prodCodi);
        ps.setInt(2, itemCodi);
        return ps.executeUpdate();
    } catch(SQLException e){
        System.err.println("Error en eliminarSubitemDeProducto(): " + e.getMessage());
        return 0;
    }
}

public List<Item> obtenerSubproductos() {
    // Queremos obtener tanto productos como componentes
    String sql = "SELECT * FROM item WHERE it_tipus IN ('P', 'C')";  // 'P' para productos y 'C' para componentes
    List<Item> subproductos = new ArrayList<>();
    try (Connection conn = Connexio.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Item item = new Item();
            item.setItCodi(rs.getInt("it_codi"));
            item.setItNom(rs.getString("it_nom"));
            item.setItTipus(rs.getString("it_tipus"));  // Guardamos el tipo (P o C)
            subproductos.add(item);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return subproductos;
}
}
