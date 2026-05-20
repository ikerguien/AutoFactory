package p1.t4.IDAO;

import p1.t4.model.UnitatMesura;
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
