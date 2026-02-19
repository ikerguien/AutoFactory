
package P1_T4_Model;


/**
 * @author Usuari
 * @version 1.0
 * @created 03-nov.-2025 16:30:21
 */
public class Provincia {

	private String codiProvincia;
	private String nom;
	public Municipi m_Municipi;

	public Provincia(){

	}

    public Provincia(String codiProvincia, String nom, Municipi m_Municipi) {
        this.codiProvincia = codiProvincia;
        this.nom = nom;
        this.m_Municipi = m_Municipi;
    }
        

    public String getCodiProvincia() {
        return codiProvincia;
    }

    public void setCodiProvincia(String codiProvincia) {
        this.codiProvincia = codiProvincia;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public Municipi getM_Municipi() {
        return m_Municipi;
    }

    public void setM_Municipi(Municipi m_Municipi) {
        this.m_Municipi = m_Municipi;
    }
        

}//end Provincia