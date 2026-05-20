package controller;

import p1.t4.dao.DAOFactory;
import p1.t4.IDAO.IDAO_Component;
import p1.t4.IDAO.IDAO_Producte;
import p1.t4.model.Item;
import java.util.ArrayList;
import java.util.List;

/**
 * Controlador de gestió general d'items.
 * S'encarrega de filtrar i combinar components i productes.
 */
public class GestionController {

    /** DAO per accedir als components de la base de dades */
    private IDAO_Component daoComponent;

    /** DAO per accedir als productes de la base de dades */
    private IDAO_Producte daoProducte;

    /**
     * Constructor que inicialitza els DAOs mitjançant DAOFactory.
     * Usem les interfícies en lloc de les implementacions concretes
     * per desacoblar el codi de la capa de persistència.
     */
    public GestionController() {
        this.daoComponent = DAOFactory.getDAOComponent();
        this.daoProducte = DAOFactory.getDAOProducte();
    }

    /**
     * Filtra els items segons el tipus indicat.
     * Si no s'indica cap tipus, retorna tots els components i productes.
     * 
     * @param tipo "C" per components, "P" per productes, null o buit per tots
     * @return Llista d'items filtrats segons el tipus
     */
    public List<Item> filtrarItems(String tipo) {
        List<Item> resultado = new ArrayList<>();

        if (tipo == null || tipo.isEmpty()) {
            // Si no hay filtro, añadimos todos los componentes y productos
            resultado.addAll(daoComponent.MostrarTots());
            resultado.addAll(daoProducte.MostrarTots());

        } else if ("C".equalsIgnoreCase(tipo)) {
            // Filtramos solo componentes
            for (Item item : daoComponent.MostrarTots()) {
                if ("C".equalsIgnoreCase(item.getItTipus())) {
                    resultado.add(item);
                }
            }

        } else if ("P".equalsIgnoreCase(tipo)) {
            // Filtramos solo productos
            for (Item item : daoProducte.MostrarTots()) {
                if ("P".equalsIgnoreCase(item.getItTipus())) {
                    resultado.add(item);
                }
            }
        }

        return resultado;
    }
}