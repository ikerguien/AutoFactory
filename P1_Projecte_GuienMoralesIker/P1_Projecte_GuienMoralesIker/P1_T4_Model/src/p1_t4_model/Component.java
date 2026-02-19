package P1_T4_Model;

import java.math.BigDecimal;
import java.util.HashMap;



/**
 * @author Usuari
 * @version 1.0
 * @created 03-nov.-2025 16:30:13
 */
public class Component {

	private String cmCodi;
	private String cmCodiFabricant;
	private double cmPreuMig;
	private String cmUmCodi;
	private Item item;
	public Item m_Item;
	public UnitatMesura m_UnitatMesura;
        private HashMap<Proveidor,BigDecimal> compra;

	public Component(){

	}

    public String getCmCodi() {
        return cmCodi;
    }

    public void setCmCodi(String cmCodi) {
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

    public String getCmUmCodi() {
        return cmUmCodi;
    }

    public void setCmUmCodi(String cmUmCodi) {
        this.cmUmCodi = cmUmCodi;
    }

    public Item getItem() {
        return item;
    }

    public void setItem(Item item) {
        this.item = item;
    }

    public Item getM_Item() {
        return m_Item;
    }

    public void setM_Item(Item m_Item) {
        this.m_Item = m_Item;
    }

    public UnitatMesura getM_UnitatMesura() {
        return m_UnitatMesura;
    }

    public void setM_UnitatMesura(UnitatMesura m_UnitatMesura) {
        this.m_UnitatMesura = m_UnitatMesura;
    }

	public void finalize() throws Throwable {

	}
}//end Component