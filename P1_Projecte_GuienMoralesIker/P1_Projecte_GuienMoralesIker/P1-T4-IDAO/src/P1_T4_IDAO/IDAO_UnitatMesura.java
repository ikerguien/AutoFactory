/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package P1_T4_IDAO;

import P1_T4_Model.UnitatMesura;
import java.util.List;

/**
 *
 * @author Usuari
 */
public interface IDAO_UnitatMesura {
   
    // Métodos de lectura
    List<UnitatMesura> MostrarTots();
    UnitatMesura MostrarPerId(int codiMesura);
    
    // Métodos de escritura
    int Afegir(UnitatMesura unitatMesura);
    int Actualitzar(UnitatMesura unitatMesura);
    int Eliminar(int codiMesura);
    int EliminarTots();
    
    // Métodos adicionales
    int MostrarQt();
    boolean exists(int codiMesura);


}
