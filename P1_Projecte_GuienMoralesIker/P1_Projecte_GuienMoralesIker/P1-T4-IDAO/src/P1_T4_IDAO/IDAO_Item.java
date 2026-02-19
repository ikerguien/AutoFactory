/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package P1_T4_IDAO;

import P1_T4_Model.Item;
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
}
