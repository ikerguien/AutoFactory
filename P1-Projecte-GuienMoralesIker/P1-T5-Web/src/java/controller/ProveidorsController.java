package controller;

import p1.t4.dao.DAOFactory;
import p1.t4.IDAO.IDAO_Proveidor;
import p1.t4.IDAO.IDAO_Municipi;
import p1.t4.model.Municipi;
import p1.t4.model.Proveidor;
import java.util.ArrayList;
import java.util.List;

/**
 * Controlador de gestió de proveïdors.
 * S'encarrega de les operacions sobre proveïdors i municipis.
 */
public class ProveidorsController {

    /** DAO per gestionar proveïdors */
    private IDAO_Proveidor dao;

    /** DAO per gestionar municipis */
    private IDAO_Municipi daoMuni;

    /**
     * Constructor que inicialitza els DAOs mitjançant DAOFactory.
     */
    public ProveidorsController() {
        this.dao = DAOFactory.getDAOProveidor();
        this.daoMuni = DAOFactory.getDAOMunicipi();
    }

    /**
     * Obté la llista completa de proveïdors de la base de dades.
     * Retorna una llista buida si hi ha algun error.
     * @return Llista de proveïdors
     */
    public List<Proveidor> obtenerTodos() {
        try {
            return dao.MostrarTots();
        } catch (Exception e) {
            System.err.println("Error al obtenir proveïdors: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * Insereix un nou proveïdor a la base de dades.
     * @param p Proveïdor a inserir
     * @return true si s'ha inserit correctament, false si hi ha error
     */
    public boolean insertar(Proveidor p) {
        try {
            dao.afegir(p);
            return true;
        } catch (Exception e) {
            System.err.println("Error al inserir proveïdor: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Obté el nom d'un municipi a partir del seu codi.
     * Retorna missatges descriptius si el codi és invàlid o no existeix.
     * @param codiMuniStr Codi del municipi en format String
     * @return Nom del municipi, o missatge d'error descriptiu
     */
    public String obtenerNombreMunicipio(String codiMuniStr) {
        if (codiMuniStr == null || codiMuniStr.isEmpty()) {
            return "N/A";
        }

        try {
            int id = Integer.parseInt(codiMuniStr);
            Municipi m = daoMuni.MostrarPerId(id);
            return (m != null) ? m.getNom() : "No trobat (" + id + ")";
        } catch (NumberFormatException e) {
            System.err.println("Codi de municipi invàlid: " + codiMuniStr);
            return "Codi invàlid";
        }
    }
}