<%@ page import="controller.ProveidorsController" %>
<%@ page import="P1_T4_Model.Proveidor" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Gestión de Proveedores</title>
        <link rel="stylesheet" href="styles.css">
        <style>
            /* Sincronización de Layout con welcome.jsp */
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                display: flex;
                height: 100vh;
                background-color: #f4f4f4;
            }

            .container {
                display: flex;
                width: 100%;
                height: 100%;
            }

            .sidebar {
                width: 250px;
                background-color: #2c3e50;
                color: white;
                padding: 20px;
                box-sizing: border-box;
                flex-shrink: 0;
            }

            .sidebar-menu ul {
                list-style: none;
                padding: 0;
            }
            .sidebar-menu ul li {
                margin: 10px 0;
                padding: 10px;
                background-color: #34495e;
                border-radius: 5px;
            }
            .sidebar-menu ul li a {
                color: white;
                text-decoration: none;
                display: block;
                text-align: center;
            }
            .sidebar-menu ul li:hover {
                background-color: #1abc9c;
            }

            .content {
                flex-grow: 1;
                padding: 30px;
                background-color: white;
                overflow-y: auto;
            }

            /* Estilo de la tabla de proveedores */
            .table-container {
                margin-top: 20px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                border-radius: 8px;
                overflow: hidden;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background: white;
            }
            th {
                background-color: #34495e;
                color: white;
                padding: 15px;
                text-align: left;
            }
            td {
                padding: 12px 15px;
                border-bottom: 1px solid #ddd;
                color: #333;
            }
            tr:hover {
                background-color: #f1f1f1;
            }

            .btn-add {
                background-color: #1abc9c;
                color: white;
                padding: 10px 20px;
                text-decoration: none;
                border-radius: 5px;
                display: inline-block;
                margin-bottom: 20px;
            }

            .btn-action {
                padding: 5px 10px;
                border-radius: 4px;
                text-decoration: none;
                color: white;
                font-size: 13px;
            }
            .edit {
                background-color: #3498db;
            }
            .delete {
                background-color: #e74c3c;
            }

            .btn-logout {
                background-color: #e74c3c;
                color: white;
                border: none;
                padding: 10px;
                width: 100%;
                cursor: pointer;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="sidebar">
                <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo Aplicación" style="width: 150px; height: auto;">
                <form action="login.jsp" method="POST">
                    <button type="submit" class="btn-logout">➜]</button>
                </form>
                <div class="sidebar-menu">
                    <h2>Menú</h2>
                    <ul>
                        <li><a href="welcome.jsp">Inici</a></li>
                        <li><a href="crearItem.jsp">Crear Item</a></li>
                        <li><a href="proveidors.jsp">Proveidors</a></li>
                        <li><a href="compras.jsp">Compres</a></li>
                    </ul>
                </div>
            </div>

            <div class="content">
                <h1>Gestió de Proveïdors</h1>

                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">

                    <div class="search-container">
                        <input type="text" id="buscador" onkeyup="filtrarProveidors()" placeholder="Buscar por nombre, CIF o ciudad..." 
                               style="padding: 10px; width: 300px; border: 1px solid #ccc; border-radius: 5px;">
                    </div>
                </div>

                <div class="table-container">
                    <table id="tablaProveidors"> <thead>
                            <tr>
                                <th>Código</th>
                                <th>CIF/NIF</th>
                                <th>Razón Social</th>
                                <th>Ciudad</th>
                                <th>Teléfono</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                ProveidorsController provController = new ProveidorsController();
                                List<Proveidor> lista = provController.obtenerTodos();
                                if (lista == null || lista.isEmpty()) {
                            %>
                            <tr><td colspan="6" style="text-align:center;">No hay proveedores registrados.</td></tr>
                            <%
                            } else {
                                for (Proveidor p : lista) {
                                    String ciudadNom = provController.obtenerNombreMunicipio(p.getPvCodiMunicipi());
                            %>
                            <tr>
                                <td><%= p.getPvCodi()%></td>
                                <td><%= p.getPvCif()%></td> 
                                <td><strong><%= p.getPvRaoSocial()%></strong></td>
                                <td><%= ciudadNom%></td>
                                <td><%= p.getPvTelefContacte()%></td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <script>
                function filtrarProveidors() {
                    var input = document.getElementById("buscador");
                    var filter = input.value.toLowerCase();
                    var table = document.getElementById("tablaProveidors");
                    var rows = table.getElementsByTagName("tr");

                    // Empezamos en 1 para saltar el <thead>
                    for (var i = 1; i < rows.length; i++) {
                        var cells = rows[i].getElementsByTagName("td");
                        var found = false;

                        // Buscamos en todas las celdas de la fila (Codi, CIF, Nom, Ciutat, Tel)
                        for (var j = 0; j < cells.length - 1; j++) { // -1 para no buscar en la celda de botones
                            var cellText = cells[j].textContent || cells[j].innerText;
                            if (cellText.toLowerCase().indexOf(filter) > -1) {
                                found = true;
                                break;
                            }
                        }

                        rows[i].style.display = found ? "" : "none";
                    }
                }
            </script>
        </div>
    </body>
</html>