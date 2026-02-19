/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import P1_T4_DAO.DAO_Usuari;
import java.io.IOException;

public class LoginController {
    
    public static boolean verificarLogin(String usuario, String contrasenya) {
        // Crear una instancia del DAO_Usuari
        DAO_Usuari dao = new DAO_Usuari();
        
        // Verificar las credenciales usando el DAO
        return dao.login(usuario, contrasenya);
    }
}