package p1.t4.IDAO;

import p1.t4.model.Item;
import java.util.List;

/**
 *
 * @author Usuari
 */
public interface IDAO_Item {
    // Métodos de lectura
    List<Item> MostrarTots();
    Item MostraPerId(int itCodi);
    List<Item> MostraPerTipus(String itTipus);
    List<Item> obtenerItemsDeProducto(int productoId);
    int actualizarCantidadEnProducto(int prodCodi, int itemCodi, int cantidad);
    List<Item> buscarItems(String busqueda);
    
    // Métodos de escritura
    int Afegir(Item item);
    int Actualitzar(Item item);
    int Eliminar(int itCodi);
    int EliminarTots();
    
    // Métodos adicionales
    int MostrarQt();
    boolean exists(int itCodi);
    
    /**
 * Afegeix un subitem a un producte
 */
int agregarSubitemEnProducto(int prodCodi, int subitemCodi, int cantidad);

/**
 * Elimina un subitem d'un producte
 */
int eliminarSubitemDeProducto(int prodCodi, int subitemCodi);

/**
 * Obté els items que poden ser subproductes
 */
List<Item> obtenerSubproductos();
}
