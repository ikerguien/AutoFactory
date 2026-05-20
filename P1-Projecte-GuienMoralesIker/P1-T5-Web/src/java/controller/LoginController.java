package controller;

import p1.t4.dao.DAOFactory;
import p1.t4.IDAO.IDAO_Usuari;

/**
 * Controlador d'autenticació d'usuaris.
 * Gestiona la verificació de credencials mitjançant BCrypt.
 */
public class LoginController {

    /**
     * Verifica les credencials d'un usuari contra la base de dades.
     * La contrasenya es compara amb el hash BCrypt emmagatzemat.
     * @param usuario Nom d'usuari
     * @param contrasenya Contrasenya en text pla
     * @return true si les credencials són correctes, false en cas contrari
     */
    public static boolean verificarLogin(String usuario, String contrasenya) {
        IDAO_Usuari dao = DAOFactory.getDAOUsuari();
        return dao.login(usuario, contrasenya);
    }
}