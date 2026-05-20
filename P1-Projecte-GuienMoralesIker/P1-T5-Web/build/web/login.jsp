<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="controller.LoginController" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String usuario = request.getParameter("usuario");
    String contrasenya = request.getParameter("contrasenya");
    String errorMsg = null;

    if (usuario != null && contrasenya != null) {
        if (usuario.trim().isEmpty() || contrasenya.trim().isEmpty()) {
            errorMsg = "Els camps usuari i contrasenya són obligatoris.";
        } else if (usuario.length() > 50) {
            errorMsg = "El nom d'usuari no pot superar els 50 caràcters.";
        } else {
            try {
                boolean loginExitoso = LoginController.verificarLogin(usuario.trim(), contrasenya);
                if (loginExitoso) {
                    session.setAttribute("usuari", usuario.trim());
                    response.sendRedirect("welcome.jsp");
                    return;
                } else {
                    errorMsg = "Usuari o contrasenya incorrectes. Torna-ho a intentar.";
                }
            } catch (Exception e) {
                errorMsg = "Error de connexió amb la base de dades. Contacta amb l'administrador.";
                e.printStackTrace();
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="ca">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AutoFactory — Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <style>
        body { display:flex; justify-content:center; align-items:center; height:100vh; background:#f4f4f4; }
    </style>
</head>
<body>
<div class="login-container">
    <h2>🏭 AutoFactory</h2>

    <% if (errorMsg != null) { %>
        <div class="alert-error">⚠️ <%= errorMsg %></div>
    <% } %>

    <form action="login.jsp" method="POST">
        <label for="usuario">Usuari:</label>
        <input type="text" id="usuario" name="usuario" required maxlength="50"
               value="<%= (usuario != null) ? usuario : "" %>"
               placeholder="Nom d'usuari" autofocus>

        <label for="contrasenya">Contrasenya:</label>
        <input type="password" id="contrasenya" name="contrasenya"
               required placeholder="Contrasenya">

        <button type="submit" class="btn-save" style="margin-top:15px;">
            🔐 Iniciar sessió
        </button>
    </form>
</div>
</body>
</html>