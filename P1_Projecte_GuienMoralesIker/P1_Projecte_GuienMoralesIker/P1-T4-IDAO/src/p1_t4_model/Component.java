package P1_T4_Model;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

/**
 * @author Usuari
 * @version 1.0
 * @created 03-nov.-2025 16:30:13
 */
public class Component extends Item {

    private int cmCodi;
    private String cmCodiFabricant;
    private double cmPreuMig;
    private int cmUmCodi;
    private HashMap<Proveidor, BigDecimal> compra;

    public Component() {
        super();
    }
    
    public int getCmCodi() {
        return cmCodi;
    }

    public void setCmCodi(int cmCodi) {
        this.cmCodi = cmCodi;
    }

    public String getCmCodiFabricant() {
        return cmCodiFabricant;
    }

    public void setCmCodiFabricant(String cmCodiFabricant) {
        this.cmCodiFabricant = cmCodiFabricant;
    }

    public double getCmPreuMig() {
        return cmPreuMig;
    }

    public void setCmPreuMig(double cmPreuMig) {
        this.cmPreuMig = cmPreuMig;
    }

    public int getCmUmCodi() {
        return cmUmCodi;
    }

    public void setCmUmCodi(int cmUmCodi) {
        this.cmUmCodi = cmUmCodi;
    }

    public HashMap<Proveidor, BigDecimal> getCompra() {
        return compra;
    }

    public void setCompra(HashMap<Proveidor, BigDecimal> compra) {
        this.compra = compra;
    }

    public void finalize() throws Throwable {

    }
}//end Component
