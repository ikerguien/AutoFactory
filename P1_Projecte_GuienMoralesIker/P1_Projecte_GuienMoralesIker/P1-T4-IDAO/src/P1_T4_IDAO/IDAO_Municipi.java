/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package P1_T4_IDAO;

import P1_T4_Model.Municipi;
import java.util.List;

/**
 *
 * @author Usuari
 */
public interface IDAO_Municipi {
    List<Municipi> MostrarTots();
    Municipi MostrarPerId(int codiMunicipi);
    List<Municipi> MostrarPerProvincia(int codiProvincia);
    
    // Métodos de escritura
    int Afegir(Municipi municipi);
    int Actualitzar(Municipi municipi);
    int Eliminar(int codiMunicipi);
    int EliminarTots();
    
    // Métodos adicionales
    int MostrarQt();
    boolean exists(int codiMunicipi);
}
