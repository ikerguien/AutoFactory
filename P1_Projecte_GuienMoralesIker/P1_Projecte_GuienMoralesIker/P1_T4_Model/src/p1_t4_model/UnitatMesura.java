package P1_T4_Model;

/**
 * @author Usuari
 * @version 1.0
 * @created 03-nov.-2025 16:30:22
 */
public class UnitatMesura {

	private String codiMesura;
	private String nom;

	public UnitatMesura(){

	}

    public UnitatMesura(String codiMesura) {
        this.codiMesura = codiMesura;
    }

    public UnitatMesura(String codiMesura, String nom) {
        this.codiMesura = codiMesura;
        this.nom = nom;
    }
        

    public String getCodiMesura() {
        return codiMesura;
    }

    public void setCodiMesura(String codiMesura) {
        this.codiMesura = codiMesura;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }
        
	public void finalize() throws Throwable {

	}
        
}//end UnitatMesura