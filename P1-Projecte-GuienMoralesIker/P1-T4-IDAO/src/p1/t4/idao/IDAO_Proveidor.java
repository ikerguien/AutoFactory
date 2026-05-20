package p1.t4.IDAO;

import p1.t4.model.Proveidor;
import java.util.List;

/**
 *
 * @author Usuari
 */
public interface IDAO_Proveidor {
    List<Proveidor> MostrarTots();
    Proveidor MostrarPerId(int pvCodi);
    Proveidor MostrarPerCif(String pvCif);

    
    // Métodos de escritura
    int afegir(Proveidor proveidor);
    int actualitzar(Proveidor proveidor);
    int eliminar(int pvCodi);
    int eliminarTots();
    
    // Métodos adicionales
    int MostrarQt();
    boolean exists(int pvCodi);
}
