package P1_T4_Model;
import java.util.HashMap;



/**
 * @author Usuari
 * @version 1.0
 * @created 03-nov.-2025 16:30:20
 */
public class Producte {

	private Item item;
	private String prCodi;
	private HashMap<Item,Integer> subitems;

	public Producte(){

	}

    public Item getItem() {
        return item;
    }

    public void setItem(Item item) {
        this.item = item;
    }

    public String getPrCodi() {
        return prCodi;
    }

    public void setPrCodi(String prCodi) {
        this.prCodi = prCodi;
    }

    public HashMap<Item, Integer> getSubitems() {
        return subitems;
    }

    public void setSubitems(HashMap<Item, Integer> subitems) {
        this.subitems = subitems;
    }

	public void finalize() throws Throwable {

	}
}//end Producte