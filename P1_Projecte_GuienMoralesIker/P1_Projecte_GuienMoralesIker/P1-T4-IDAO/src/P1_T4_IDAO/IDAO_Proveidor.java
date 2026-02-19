/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package P1_T4_IDAO;

import P1_T4_Model.Proveidor;
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
