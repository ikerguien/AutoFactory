package p1.t4.model;

/**
 * @author Usuari
 * @version 1.0
 * @created 03-nov.-2025 16:30:19
 */
public class Municipi {

	private int codi_municipi;
	private int codi_provincia;
	private String nom;
	public Proveidor m_Proveidor;

	public Municipi(){

	}

    public int getCodi_municipi() {
        return codi_municipi;
    }

    public void setCodi_municipi(int codi_municipi) {
        this.codi_municipi = codi_municipi;
    }

    public int getCodi_provincia() {
        return codi_provincia;
    }

    public void setCodi_provincia(int codi_provincia) {
        this.codi_provincia = codi_provincia;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public Proveidor getM_Proveidor() {
        return m_Proveidor;
    }

    public void setM_Proveidor(Proveidor m_Proveidor) {
        this.m_Proveidor = m_Proveidor;
    }

    public Municipi(int codi_municipi, int codi_provincia, String nom, Proveidor m_Proveidor) {
        this.codi_municipi = codi_municipi;
        this.codi_provincia = codi_provincia;
        this.nom = nom;
        this.m_Proveidor = m_Proveidor;
    }
    
        
	public void finalize() throws Throwable {

	}
}//end Municipi