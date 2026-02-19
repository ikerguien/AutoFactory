package P1_T4_Model;

import java.util.HashMap;

/**
 * @author Usuari
 * @version 1.0
 * @created 03-nov.-2025 16:30:20
 */
public class Producte extends Item {

    private int prCodi;
    private HashMap<Item, Integer> subitems = new HashMap<>();

    public Producte() {
        super();
    }

    public int getPrCodi() {
        return prCodi;
    }

    public void setPrCodi(int prCodi) {
        this.prCodi = prCodi;
    }

    public HashMap<Item, Integer> getSubitems() {
        return subitems;
    }

    public void setSubitems(HashMap<Item, Integer> subitems) {
        this.subitems = subitems;
    }
    
    public void addSubitem(Item item, int cantidad) {
        if (this.subitems == null) {
            this.subitems = new HashMap<>();
        }
        this.subitems.put(item, cantidad);
    }

    public void finalize() throws Throwable {

    }
}//end Producte
