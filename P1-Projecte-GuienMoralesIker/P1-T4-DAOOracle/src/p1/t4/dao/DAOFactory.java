package p1.t4.dao;

import p1.t4.IDAO.IDAO_Item;
import p1.t4.IDAO.IDAO_Component;
import p1.t4.IDAO.IDAO_Producte;
import p1.t4.IDAO.IDAO_Proveidor;
import p1.t4.IDAO.IDAO_Municipi;
import p1.t4.IDAO.IDAO_Provincia;
import p1.t4.IDAO.IDAO_UnitatMesura;
import p1.t4.IDAO.IDAO_Usuari;

/**
 * Factoria de DAOs per Oracle.
 * Proporciona instàncies de cada interfície DAO implementades per Oracle.
 */
public class DAOFactory {

    /**
     * Retorna una instància de IDAO_Item implementada per Oracle.
     * @return IDAO_Item
     */
    public static IDAO_Item getDAOItem() {
        return new DAO_Item();
    }

    /**
     * Retorna una instància de IDAO_Component implementada per Oracle.
     * @return IDAO_Component
     */
    public static IDAO_Component getDAOComponent() {
        return new DAO_Component();
    }

    /**
     * Retorna una instància de IDAO_Producte implementada per Oracle.
     * @return IDAO_Producte
     */
    public static IDAO_Producte getDAOProducte() {
        return new DAO_Producte();
    }

    /**
     * Retorna una instància de IDAO_Proveidor implementada per Oracle.
     * @return IDAO_Proveidor
     */
    public static IDAO_Proveidor getDAOProveidor() {
        return new DAO_Proveidor();
    }

    /**
     * Retorna una instància de IDAO_Municipi implementada per Oracle.
     * @return IDAO_Municipi
     */
    public static IDAO_Municipi getDAOMunicipi() {
        return new DAO_Municipi();
    }

    /**
     * Retorna una instància de IDAO_Provincia implementada per Oracle.
     * @return IDAO_Provincia
     */
    public static IDAO_Provincia getDAOProvincia() {
        return new DAO_Provincia();
    }

    /**
     * Retorna una instància de IDAO_UnitatMesura implementada per Oracle.
     * @return IDAO_UnitatMesura
     */
    public static IDAO_UnitatMesura getDAOUnitatMesura() {
        return new DAO_UnitatMesura();
    }

    /**
     * Retorna una instància de IDAO_Usuari implementada per Oracle.
     * @return IDAO_Usuari
     */
    public static IDAO_Usuari getDAOUsuari() {
        return new DAO_Usuari();
    }
}