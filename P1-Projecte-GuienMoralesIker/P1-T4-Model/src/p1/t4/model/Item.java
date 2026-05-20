package p1.t4.model;

public class Item {

    private int itCodi;        // Código del item
    private String itDescripio;   // Descripción del item
    private byte[] itFoto;        // Foto del item (almacenada como un arreglo de bytes)
    private String itNom;         // Nombre del item
    private int itStock;          // Cantidad en stock
    private String itTipus;       // Tipo de item (puede ser "componente", "producto", etc.)

    // NUEVO: cantidad para subitems / productos relacionados
    private int cantidad;

    // Constructor vacío
    public Item() {}

    // Constructor completo
    public Item(int itCodi, String itDescripio, byte[] itFoto, String itNom, int itStock, String itTipus) {
        this.itCodi = itCodi;
        this.itDescripio = itDescripio;
        this.itFoto = itFoto;
        this.itNom = itNom;
        this.itStock = itStock;
        this.itTipus = itTipus;
    }

    // Getters y setters existentes
    public int getItCodi() { return itCodi; }
    public void setItCodi(int itCodi) { this.itCodi = itCodi; }

    public String getItDescripio() { return itDescripio; }
    public void setItDescripio(String itDescripio) { this.itDescripio = itDescripio; }

    public byte[] getItFoto() { return itFoto; }
    public void setItFoto(byte[] itFoto) { this.itFoto = itFoto; }

    public String getItNom() { return itNom; }
    public void setItNom(String itNom) { this.itNom = itNom; }

    public int getItStock() { return itStock; }
    public void setItStock(int itStock) { this.itStock = itStock; }

    public String getItTipus() {
    System.out.println("Valor de IT_TIPUS en getItTipus(): " + this.itTipus); // Depuración del valor
    return this.itTipus;
}
    public void setItTipus(String itTipus) { this.itTipus = itTipus; }

    // NUEVO: getter y setter para cantidad
    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }
    
    
}

