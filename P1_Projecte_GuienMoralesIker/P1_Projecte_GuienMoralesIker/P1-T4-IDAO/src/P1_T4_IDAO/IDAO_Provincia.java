/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package P1_T4_IDAO;

import P1_T4_Model.Provincia;
import java.util.List;

/**
 *
 * @author Usuari
 */
public interface IDAO_Provincia {
    List<Provincia> mostrarTots();
    Provincia MostraPerId(int codiProvincia);
    List<Provincia> MostraPerNom(String nom);
    
    // Métodos de escritura
    int Afegir(Provincia provincia);
    int Actualitzar(Provincia provincia);
    int Eliminar(int codiProvincia);
    int EliminarTots();
    
    // Métodos adicionales
    int MostrarQt();
    boolean exists(int codiProvincia);
}
