package p1.t4.IDAO;

import p1.t4.model.Municipi;
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
