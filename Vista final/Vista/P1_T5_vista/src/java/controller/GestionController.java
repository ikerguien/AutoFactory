/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import P1_T4_DAO.DAO_Component;
import P1_T4_DAO.DAO_Producte;
import P1_T4_Model.Component;
import P1_T4_Model.Item;
import java.util.ArrayList;
import java.util.List;

public class GestionController {

    private DAO_Component daoComponent;
    private DAO_Producte daoProducte;

    // Constructor
    public GestionController() {
        // Inicializamos los DAOs
        this.daoComponent = new DAO_Component();
        this.daoProducte = new DAO_Producte();
    }

    public List<Item> filtrarItems(String tipo) {
        List<Item> resultado = new ArrayList<>();

        if (tipo == null || tipo.isEmpty()) {
            resultado.addAll(daoComponent.MostrarTots());
            resultado.addAll(daoProducte.MostrarTots());

        } else if ("C".equalsIgnoreCase(tipo)) {
            // Filtrar componentes "a mano" de todos los componentes
            for (Item item : daoComponent.MostrarTots()) {
                if ("C".equalsIgnoreCase(item.getItTipus())) {
                    resultado.add(item);
                }
            }

        } else if ("P".equalsIgnoreCase(tipo)) {
            // Filtrar productos "a mano" de todos los productos
            for (Item item : daoProducte.MostrarTots()) {
                if ("P".equalsIgnoreCase(item.getItTipus())) {
                    resultado.add(item);
                }
            }
        }

        return resultado;
    }
    

}