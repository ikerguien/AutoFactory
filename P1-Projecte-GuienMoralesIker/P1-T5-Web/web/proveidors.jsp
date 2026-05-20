<%@ page import="controller.ProveidorsController" %>
<%@ page import="p1.t4.model.Proveidor" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("usuari") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    ProveidorsController provController = new ProveidorsController();
    List<Proveidor> lista = provController.obtenerTodos();
%>
<!DOCTYPE html>
<html lang="ca">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AutoFactory — Proveïdors</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
<div class="container">

    <div class="sidebar">
        <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo">
        <form action="login.jsp" method="POST">
            <button type="submit" class="btn-logout">➜ Logout</button>
        </form>
        <div class="sidebar-menu">
            <h2>Menú</h2>
            <ul>
                <li><a href="welcome.jsp">🏠 Inici</a></li>
                <li><a href="crearItem.jsp">➕ Crear Item</a></li>
                <li><a href="proveidors.jsp">🏭 Proveïdors</a></li>
                <li><a href="arbre.jsp">🌳 Vista en Arbre</a></li>
            </ul>
        </div>
    </div>

    <div class="content">
        <h1>🏭 Gestió de Proveïdors</h1>
        <p style="color:#777; margin-bottom:20px;">
            Total proveïdors: <strong><%= (lista != null) ? lista.size() : 0 %></strong>
        </p>

        <input type="text" id="buscador"
               onkeyup="filtrarProveidors()"
               placeholder="🔍 Cercar per nom, CIF o municipi..."
               style="padding:10px; width:350px; border:1px solid #ccc;
                      border-radius:5px; margin-bottom:20px;">

        <div class="table-container">
            <table id="tablaProveidors">
                <thead>
                    <tr>
                        <th>Codi</th>
                        <th>CIF/NIF</th>
                        <th>Raó Social</th>
                        <th>Municipi</th>
                        <th>Telèfon</th>
                        <th>Persona Contacte</th>
                        <th>Adreça</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (lista == null || lista.isEmpty()) { %>
                    <tr>
                        <td colspan="7" style="text-align:center; color:#777; padding:25px;">
                            ℹ️ No hi ha proveïdors registrats.
                        </td>
                    </tr>
                    <% } else {
                        for (Proveidor p : lista) {
                            String ciutatNom = provController.obtenerNombreMunicipio(
                                p.getPvCodiMunicipi()
                            );
                    %>
                    <tr>
                        <td><strong><%= p.getPvCodi() %></strong></td>
                        <td><code><%= p.getPvCif() %></code></td>
                        <td><strong><%= p.getPvRaoSocial() %></strong></td>
                        <td><%= ciutatNom %></td>
                        <td><%= p.getPvTelefContacte() != null ? p.getPvTelefContacte() : "—" %></td>
                        <td><%= p.getPvPersonaContacte() != null ? p.getPvPersonaContacte() : "—" %></td>
                        <td><%= p.getPvLinAdreFac() != null ? p.getPvLinAdreFac() : "—" %></td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    function filtrarProveidors() {
        var input = document.getElementById("buscador");
        var filter = input.value.toLowerCase();
        var table = document.getElementById("tablaProveidors");
        var rows = table.getElementsByTagName("tr");

        for (var i = 1; i < rows.length; i++) {
            var cells = rows[i].getElementsByTagName("td");
            var found = false;
            for (var j = 0; j < cells.length; j++) {
                if (cells[j].textContent.toLowerCase().indexOf(filter) > -1) {
                    found = true;
                    break;
                }
            }
            rows[i].style.display = found ? "" : "none";
        }
    }
</script>
</body>
</html>