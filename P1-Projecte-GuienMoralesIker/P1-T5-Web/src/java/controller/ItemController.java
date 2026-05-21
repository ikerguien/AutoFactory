package controller;

import p1.t4.dao.DAOFactory;
import p1.t4.IDAO.IDAO_Item;
import p1.t4.IDAO.IDAO_Producte;
import p1.t4.IDAO.IDAO_Component;
import p1.t4.IDAO.IDAO_Proveidor;
import p1.t4.IDAO.IDAO_UnitatMesura;
import p1.t4.model.Component;
import p1.t4.model.Item;
import p1.t4.model.Producte;
import p1.t4.model.Proveidor;
import p1.t4.model.UnitatMesura;
import java.util.List;
import java.util.Map;

/**
 * Controlador principal d'items.
 * Gestiona les operacions sobre components, productes i les seves relacions.
 */
public class ItemController {

    /** DAO per gestionar items genèrics */
    private IDAO_Item daoItem;

    /** DAO per gestionar productes */
    private IDAO_Producte daoProducte;

    /** DAO per gestionar components */
    private IDAO_Component daoComponent;

    /** DAO per gestionar proveïdors */
    private IDAO_Proveidor daoProv;

    /** DAO per gestionar unitats de mesura */
    private IDAO_UnitatMesura daoUM;

    /**
     * Constructor que inicialitza els DAOs mitjançant DAOFactory.
     */
    public ItemController() {
        daoItem = DAOFactory.getDAOItem();
        daoProducte = DAOFactory.getDAOProducte();
        daoComponent = DAOFactory.getDAOComponent();
        daoProv = DAOFactory.getDAOProveidor();
        daoUM = DAOFactory.getDAOUnitatMesura();
    }

    /**
     * Obté tots els items filtrats per tipus.
     * @param tipo "C" per components, "P" per productes, null o buit per tots
     * @return Llista d'items filtrats
     */
    public List<Item> obtenerItems(String tipo) {
        System.out.println("Tipo recibido en ItemController: '" + tipo + "'");
        List<Item> items;

        if (tipo != null && !tipo.isEmpty()) {
            items = daoItem.MostraPerTipus(tipo);
            System.out.println("Items filtrados: " + items.size());
        } else {
            items = daoItem.MostrarTots();
            System.out.println("Todos los items: " + items.size());
        }

        return items;
    }

    /**
     * Obté tots els items sense filtre.
     * Útil per seleccionar subitems en la creació de productes.
     * @return Llista de tots els items
     */
    public List<Item> obtenerTodosItems() {
        return daoItem.MostrarTots();
    }

    /**
     * Obté un item per el seu identificador.
     * @param id Identificador de l'item
     * @return Item trobat o null si no existeix
     */
    public Item obtenerItemPorId(int id) {
        return daoItem.MostraPerId(id);
    }

    /**
     * Actualitza les dades d'un item existent.
     * @param item Item amb les dades actualitzades
     * @return Nombre de files afectades
     */
    public int actualizarItem(Item item) {
        return daoItem.Actualitzar(item);
    }

    /**
     * Obté tots els subitems que formen part d'un producte.
     * @param codigoProducto Identificador del producte pare
     * @return Llista d'items fills del producte
     */
    public List<Item> obtenerItemsDelProducto(int codigoProducto) {
        return daoItem.obtenerItemsDeProducto(codigoProducto);
    }

    /**
     * Actualitza la quantitat d'un item fill dins d'un producte.
     * @param prodCodi Identificador del producte pare
     * @param itemCodi Identificador de l'item fill
     * @param cantidad Nova quantitat
     * @return true si s'ha actualitzat correctament
     */
    public boolean actualizarCantidadItemHijo(int prodCodi, int itemCodi, int cantidad) {
        return daoItem.actualizarCantidadEnProducto(prodCodi, itemCodi, cantidad) > 0;
    }

    /**
     * Afegeix un subitem a un producte existent.
     * @param prodCodi Identificador del producte pare
     * @param subitemCodi Identificador del subitem a afegir
     * @param cantidad Quantitat del subitem
     * @return true si s'ha afegit correctament
     */
    public boolean agregarSubitem(int prodCodi, int subitemCodi, int cantidad) {
        if (prodCodi == subitemCodi || cantidad <= 0) return false;
        return daoItem.agregarSubitemEnProducto(prodCodi, subitemCodi, cantidad) > 0;
    }

    /**
     * Elimina un subitem d'un producte.
     * @param prodCodi Identificador del producte pare
     * @param subitemCodi Identificador del subitem a eliminar
     * @return true si s'ha eliminat correctament
     */
    public boolean eliminarSubitem(int prodCodi, int subitemCodi) {
        return daoItem.eliminarSubitemDeProducto(prodCodi, subitemCodi) > 0;
    }

    /**
     * Cerca items per nom o identificador.
     * @param busqueda Text de cerca
     * @return Llista d'items que coincideixen amb la cerca
     */
    public List<Item> buscarItems(String busqueda) {
        return daoItem.buscarItems(busqueda);
    }

    /**
     * Afegeix un nou producte a la base de dades.
     * El DAO gestiona la inserció a ITEM, PRODUCTE i PROD_ITEM.
     * @param producto Producte a inserir
     * @return ID del nou producte o 0 si hi ha error
     */
    public int agregarProducto(Producte producto) {
        int nuevoId = daoProducte.Afegir(producto);

        if (nuevoId > 0) {
            System.out.println("Producto insertado con éxito. ID: " + nuevoId);
            return nuevoId;
        }

        System.err.println("Error al insertar el producto en el DAO");
        return 0;
    }

    /**
     * Afegeix un nou component a la base de dades.
     * Gestiona la inserció a ITEM, COMPONENT i PROV_COMP.
     * @param componente Component a inserir
     * @return ID del nou component o 0 si hi ha error
     */
    public int agregarComponente(Component componente) {
        // 1. Insertem a ITEM i recuperem el nou ID
        int nuevoId = daoItem.Afegir(componente);

        if (nuevoId > 0) {
            componente.setItCodi(nuevoId);
            componente.setCmCodi(nuevoId);

            // 2. Insertem a la taula COMPONENT
            int resultado = daoComponent.Afegir(componente);

            // 3. Insertem els proveïdors si existeixen al HashMap
            if (resultado > 0 && componente.getCompra() != null) {
                for (Map.Entry<Proveidor, java.math.BigDecimal> entry : componente.getCompra().entrySet()) {
                    vincularProveedor(nuevoId, entry.getKey().getPvCodi(), entry.getValue().doubleValue());
                }
            }

            return (resultado > 0) ? nuevoId : 0;
        }
        return 0;
    }

    /**
     * Vincula un proveïdor a un component amb el seu preu.
     * Insereix un registre a la taula PROV_COMP.
     * @param cmCodi Identificador del component
     * @param pvCodi Identificador del proveïdor
     * @param preu Preu ofert pel proveïdor
     * @return true si s'ha vinculat correctament
     */
    public boolean vincularProveedor(int cmCodi, int pvCodi, double preu) {
        return daoComponent.vincularProveedor(cmCodi, pvCodi, preu) > 0;
    }

    /**
     * Obté la llista de subproductes disponibles.
     * @return Llista d'items que poden ser subproductes
     */
    public List<Item> obtenerSubproductos() {
        return daoItem.obtenerSubproductos();
    }

    /**
     * Elimina un item per el seu identificador.
     * No es pot eliminar si està referenciat en algun BOM.
     * @param id Identificador de l'item a eliminar
     * @return true si s'ha eliminat correctament
     */
    public boolean eliminarItem(int id) {
        return daoItem.Eliminar(id) > 0;
    }

    /**
     * Obté la llista de tots els proveïdors disponibles.
     * @return Llista de proveïdors
     */
    public List<Proveidor> obtenerProveedores() {
        return daoProv.MostrarTots();
    }

    /**
     * Obté la llista de totes les unitats de mesura disponibles.
     * @return Llista d'unitats de mesura
     */
    public List<UnitatMesura> obtenerUnidades() {
        return daoUM.MostrarTots();
    }
    
    /**
    * Obté un component per el seu identificador.
    * @param id Identificador del component
    * @return Component trobat o null si no existeix
    */
   public Component obtenerComponentPorId(int id) {
       return DAOFactory.getDAOComponent().MostrarPerId(id);
   }
}