package p1.t4.IDAO;

import p1.t4.model.Component;
import p1.t4.model.Proveidor;
import java.util.HashMap;
import java.util.List;
import java.math.BigDecimal;

/**
 * Interfície per la gestió de components a la base de dades.
 * Defineix les operacions sobre les taules COMPONENT i PROV_COMP.
 */
public interface IDAO_Component {

    // ==================== LECTURA ====================

    /**
     * Obté tots els components amb les seves dades d'ITEM i PROV_COMP.
     * @return Llista de tots els components
     */
    List<Component> MostrarTots();

    /**
     * Obté un component per el seu identificador.
     * @param cmCodi Identificador del component
     * @return Component trobat o null si no existeix
     */
    Component MostrarPerId(int cmCodi);

    /**
     * Obté els components associats a un item.
     * @param itCodi Identificador de l'item
     * @return Llista de components de l'item
     */
    List<Component> MostraPerItem(int itCodi);

    /**
     * Obté els components filtrats per unitat de mesura.
     * @param cmUmCodi Identificador de la unitat de mesura
     * @return Llista de components amb la unitat de mesura indicada
     */
    List<Component> MostraPerUnitatMesura(int cmUmCodi);

    /**
     * Obté els preus per proveïdor d'un component.
     * Consulta la taula PROV_COMP i retorna un HashMap.
     * @param idComponente Identificador del component
     * @return HashMap amb el proveïdor i el seu preu
     */
    HashMap<Proveidor, BigDecimal> obtenerPreciosPorProveedor(int idComponente);

    // ==================== ESCRIPTURA ====================

    /**
     * Afegeix un nou component a la taula COMPONENT.
     * L'item pare ja ha d'estar inserit prèviament a ITEM.
     * @param component Component a inserir
     * @return Nombre de files afectades
     */
    int Afegir(Component component);

    /**
     * Actualitza les dades d'un component existent.
     * @param component Component amb les dades actualitzades
     * @return Nombre de files afectades
     */
    int Actualitzar(Component component);

    /**
     * Elimina un component per el seu identificador.
     * @param cmCodi Identificador del component
     * @return Nombre de files afectades
     */
    int Eliminar(int cmCodi);

    /**
     * Elimina tots els components de la base de dades.
     * @return Nombre de files eliminades
     */
    int eliminarTots();

    // ==================== PROV_COMP ====================

    /**
     * Vincula un proveïdor a un component amb el seu preu.
     * Insereix un registre a la taula PROV_COMP.
     * @param cmCodi Identificador del component
     * @param pvCodi Identificador del proveïdor
     * @param preu Preu ofert pel proveïdor
     * @return Nombre de files afectades
     */
    int vincularProveedor(int cmCodi, int pvCodi, double preu);

    /**
     * Elimina tots els proveïdors associats a un component.
     * Elimina tots els registres de PROV_COMP del component.
     * @param idComponente Identificador del component
     * @return Nombre de files eliminades
     */
    int eliminarTodosProveedoresDeComponente(int idComponente);

    // ==================== AUXILIARS ====================

    /**
     * Obté el nombre total de components.
     * @return Nombre de components
     */
    int mostrarQt();

    /**
     * Comprova si existeix un component amb el codi indicat.
     * @param cmCodi Identificador a comprovar
     * @return true si existeix
     */
    boolean exists(int cmCodi);
}