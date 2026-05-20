package p1.t4.IDAO;

import p1.t4.model.Provincia;
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
