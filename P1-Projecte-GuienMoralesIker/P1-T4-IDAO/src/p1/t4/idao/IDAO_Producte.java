package p1.t4.IDAO;

import p1.t4.model.Producte;
import java.util.List;

public interface IDAO_Producte {
    // Métodos de lectura
    List<Producte> MostrarTots();
    Producte MostrarPerId(int id);  // Cambiado de 'int' a 'String' porque PR_CODI es CHAR(5)
    
    // Método único para mostrar por filtros
    List<Producte> MostrarConFiltro(int id, String nombre, String categoria);  // Parámetros opcionales
    
    // Métodos de escritura
    int Afegir(Producte product);
    int Actualitzar(Producte product);
    int Eliminar(int id);  // Cambiado de 'int' a 'String'
    int EliminarTots();
    
    // Métodos adicionales
    int MostrarQt();
    boolean exists(int id);  // Cambiado de 'int' a 'String'
}
