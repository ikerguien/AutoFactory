<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="controller.LoginController" %>  <!-- Importamos el controlador -->
<%@ page import="controller.GestionController" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .login-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            width: 300px;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        input {
            width: 90%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .error {
            color: red;
            font-size: 0.9em;
            text-align: center;
        }
    </style>
</head>
<body>

    <div class="login-container">
        <h2>Iniciar sesión</h2>
        
        <!-- Mostrar mensaje de error si hay uno -->
        <c:if test="${not empty errorMessage}">
            <div class="error">${errorMessage}</div>
        </c:if>

        <!-- Formulario de login -->
        <form action="login.jsp" method="POST">
            <label for="usuario">Usuario:</label>
            <input type="text" id="usuario" name="usuario" required value="${param.usuario}" />

            <label for="contrasenya">Contraseña:</label>
            <input type="password" id="contrasenya" name="contrasenya" required />

            <button type="submit">Iniciar sesión</button>
        </form>
    </div>

    <%
        // Recoger los parámetros del formulario
        String usuario = request.getParameter("usuario");
        String contrasenya = request.getParameter("contrasenya");

        // Verificar si se ha enviado el formulario
        if (usuario != null && contrasenya != null) {
            // Usar el controlador para verificar el login
            boolean loginExitoso = false;
            try {
                // Llamamos al controlador para verificar las credenciales
                loginExitoso = LoginController.verificarLogin(usuario, contrasenya);

                // Si el login es exitoso, redirigir a la página de bienvenida
                if (loginExitoso) {
                    response.sendRedirect("welcome.jsp");
                } else {
                    // Si el login falla, mostrar mensaje de error
                    request.setAttribute("errorMessage", "Usuario o contraseña incorrectos.");
                }
            } catch (Exception e) {
                // Si ocurre un error de conexión a la base de datos
                request.setAttribute("errorMessage", "Error al conectar con la base de datos.");
                e.printStackTrace(); // Imprimir el stacktrace en los logs para depuración
            }
        }
    %>

</body>
</html>
