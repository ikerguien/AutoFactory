package P1_T4_Model;

/**
 * @author Usuari
 * @version 1.0
 * @created 03-nov.-2025 16:30:18
 */
public class Item {

	private String itCodi;
	//private String itDesc;
	private String itDescripio;
	private byte[] itFoto;
	private String itNom;
	private int itStock;
	private String itTipus;

	public Item(){

	}

    public String getItCodi() {
        return itCodi;
    }

    public void setItCodi(String itCodi) {
        this.itCodi = itCodi;
    }

    public String getItDescripio() {
        return itDescripio;
    }

    public void setItDescripio(String itDescripio) {
        this.itDescripio = itDescripio;
    }

    public byte[] getItFoto() {
        return itFoto;
    }

    public void setItFoto(byte[] itFoto) {
        this.itFoto = itFoto;
    }

    public String getItNom() {
        return itNom;
    }

    public void setItNom(String itNom) {
        this.itNom = itNom;
    }

    public int getItStock() {
        return itStock;
    }

    public void setItStock(int itStock) {
        this.itStock = itStock;
    }

    public String getItTipus() {
        return itTipus;
    }

    public void setItTipus(String itTipus) {
        this.itTipus = itTipus;
    }

    public Item(String itCodi, String itDescripio, byte[] itFoto, String itNom, int itStock, String itTipus) {
        this.itCodi = itCodi;
        this.itDescripio = itDescripio;
        this.itFoto = itFoto;
        this.itNom = itNom;
        this.itStock = itStock;
        this.itTipus = itTipus;
    }

    public Item(String itCodi) {
        this.itCodi = itCodi;
    }
    
        
	public void finalize() throws Throwable {

	}
}//end Item