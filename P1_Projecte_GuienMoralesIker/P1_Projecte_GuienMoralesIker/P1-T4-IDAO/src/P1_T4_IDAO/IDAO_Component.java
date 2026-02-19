package P1_T4_IDAO;

import P1_T4_Model.Component;
import P1_T4_Model.Item;
import java.util.List;

/**
 *
 * @author Usuari
 */
public interface IDAO_Component {
    // Métodos de lectura
    List<Component> MostrarTots();
    Component MostrarPerId(int cmCodi);  // Cambiado de String a int
    
    List<Component> MostraPerItem(int itCodi);  // Cambiado de String a int
    List<Component> MostraPerUnitatMesura(int cmUmCodi);  // Cambiado de String a int
    
    // Métodos de escritura
    int Afegir(Component component);
    int Actualitzar(Component component);
    int Eliminar(int cmCodi);  // Cambiado de String a int
    int eliminarTots();
    
    // Métodos adicionales
    int mostrarQt();
    boolean exists(int cmCodi);  // Cambiado de String a int
}
