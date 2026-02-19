package controller;

import P1_T4_DAO.DAO_Municipi;
import P1_T4_DAO.DAO_Proveidor;
import P1_T4_Model.Municipi;
import P1_T4_Model.Proveidor;
import java.util.ArrayList;
import java.util.List;

public class ProveidorsController {
    
    private DAO_Proveidor dao;
    private DAO_Municipi daoMuni;

    public ProveidorsController() {
        this.dao = new DAO_Proveidor();
        this.daoMuni = new DAO_Municipi();
    }

    /**
     * Obtiene la lista completa de proveedores desde la DB
     */
    public List<Proveidor> obtenerTodos() {
        try {
            return dao.MostrarTots(); // Usamos el método de tu DAO
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>(); // Retornamos lista vacía si falla
        }
    }

    /**
     * Ejemplo de cómo añadiríamos un proveedor
     */
    public boolean insertar(Proveidor p) {
        try {
            dao.afegir(p);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    public String obtenerNombreMunicipio(String codiMuniStr) {
        if (codiMuniStr == null || codiMuniStr.isEmpty()) return "N/A";
        
        try {
            int id = Integer.parseInt(codiMuniStr);
            Municipi m = daoMuni.MostrarPerId(id);
            return (m != null) ? m.getNom() : "No trobat (" + id + ")";
        } catch (NumberFormatException e) {
            return "Codi invàlid";
        }
    }
}