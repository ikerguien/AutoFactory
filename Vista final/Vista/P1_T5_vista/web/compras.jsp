<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="controller.ItemController" %>
<%@ page import="P1_T4_Model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>

<%
    ItemController controller = new ItemController();
    List<Component> listaComponentes = null;
    
    try {
        // Obtenemos los componentes con sus precios ya cargados
        listaComponentes = controller.obtenerComponentesCompletos();
    } catch (Exception e) {
        out.println("<div style='color:red;'>Error al cargar componentes: " + e.getMessage() + "</div>");
    }
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Gestión de Compras - Panel de Suministros</title>

        <script>
            // Función de búsqueda dinámica adaptada a la estructura de las tarjetas/filas
            function buscarItems() {
                var input = document.getElementById("buscador");
                var filter = input.value.toLowerCase();
                var cards = document.getElementsByClassName("component-card");

                for (var i = 0; i < cards.length; i++) {
                    var text = cards[i].innerText || cards[i].textContent;
                    if (text.toLowerCase().indexOf(filter) > -1) {
                        cards[i].style.display = "";
                    } else {
                        cards[i].style.display = "none";
                    }
                }
            }
        </script>

        <style>
            /* CSS Unificado con tu estilo de welcome.jsp */
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

            /* Barra lateral (Idéntica a la tuya) */
            .sidebar {
                width: 250px;
                background-color: #2c3e50;
                color: white;
                padding: 20px;
                box-sizing: border-box;
            }
            .sidebar-menu {
                margin-top: 30px;
            }
            .sidebar-menu h2 {
                color: #ecf0f1;
                font-size: 22px;
                text-align: center;
                margin-bottom: 20px;
            }
            .sidebar-menu ul {
                list-style-type: none;
                padding: 0;
                margin: 0;
            }
            .sidebar-menu ul li {
                margin: 10px 0;
                padding: 10px;
                background-color: #34495e;
                border-radius: 5px;
                transition: 0.3s;
            }
            .sidebar-menu ul li:hover {
                background-color: #1abc9c;
            }
            .sidebar-menu ul li a {
                color: white;
                text-decoration: none;
                display: block;
                text-align: center;
            }
            .btn-logout {
                background-color: #e74c3c;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                margin: 20px 0;
            }

            /* Contenido principal */
            .content {
                width: 100%;
                padding: 20px;
                box-sizing: border-box;
                background-color: white;
                overflow-y: auto;
            }
            h1 {
                text-align: center;
                font-size: 28px;
                color: #34495e;
            }

            /* Buscador */
            #buscador {
                width: 100%;
                padding: 12px;
                margin: 20px 0;
                border: 1px solid #ddd;
                border-radius: 5px;
                box-sizing: border-box;
            }

            /* Estilo de Tarjetas de Compra (Basado en tu highlight-section pero adaptado) */
            .component-card {
                background-color: #ffffff;
                color: #333;
                margin: 20px auto;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                border-left: 5px solid #f39c12; /* Color naranja de tu diseño */
            }

            .card-header {
                border-bottom: 2px solid #f39c12;
                margin-bottom: 15px;
                padding-bottom: 10px;
            }
            .card-header h2 {
                margin: 0;
                color: #2c3e50;
            }

            /* Tabla de Proveedores (Estilo similar a results-table) */
            .prov-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }
            .prov-table th {
                background-color: #34495e;
                color: white;
                padding: 10px;
            }
            .prov-table td {
                background-color: #ecf0f1;
                padding: 10px;
                text-align: center;
                border: 1px solid #ddd;
            }
            .price {
                font-weight: bold;
                color: #27ae60;
            }
            .no-data {
                color: #e67e22;
                font-style: italic;
                font-weight: bold;
            }

            .btn-detalle {
                background-color: #3498db;
                color: white;
                padding: 5px 10px;
                text-decoration: none;
                border-radius: 5px;
                font-size: 14px;
            }
        </style>
    </head>
    <body>

        <div class="container">
            <div class="sidebar">
                <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo" style="width: 150px; height: auto; display:block; margin:auto;">
                <form action="login.jsp" method="POST">
                    <button type="submit" class="btn-logout">➜ Logout</button>
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
                <h1>📦 Panel de Compras y Suministros</h1>

                <input type="text" id="buscador" onkeyup="buscarItems()" placeholder="Buscar componente por nombre o descripción..." title="Escribe para filtrar">

                <% if (listaComponentes != null && !listaComponentes.isEmpty()) { 
                    for (Component comp : listaComponentes) { 
                %>
                <div class="component-card">
                    <div class="card-header">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <h2><%= comp.getItNom() %></h2>
                            <%-- Por esto --%>
                            <a href="verDetalle.jsp?codigo=<%= comp.getItCodi() %>" class="btn-detalle">Ver Detalle</a>
                        </div>
                        <small>REF: <%= (comp.getCmCodiFabricant() != null) ? comp.getCmCodiFabricant() : "N/A" %></small>
                    </div>

                    <p><strong>Descripción:</strong> <%= (comp.getItDescripio() != null) ? comp.getItDescripio() : "Sin descripción." %></p>
                    <p>
                        <strong>Stock:</strong> <%= comp.getItStock() %> | 
                        <strong>Precio Medio:</strong> <span class="price"><%= comp.getCmPreuMig() %> €</span>
                    </p>

                    <h3>Ofertas de Proveedores:</h3>
                    <% 
                    Map<Proveidor, BigDecimal> compras = comp.getCompra();
                    if (compras != null && !compras.isEmpty()) { 
                    %>
                    <table class="prov-table">
                        <thead>
                            <tr>
                                <th>Proveedor</th>
                                <th>CIF</th>
                                <th>Precio Ofertado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map.Entry<Proveidor, BigDecimal> entry : compras.entrySet()) { %>
                            <tr>
                                <td><%= entry.getKey().getPvRaoSocial() %></td>
                                <td><code><%= entry.getKey().getPvCif() %></code></td>
                                <td class="price"><%= entry.getValue() %> €</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <% } else { %>
                    <p class="no-data">⚠️ Sin registros en PROV_COMP.</p>
                    <% } %>
                </div>
                <% 
                    } 
                } else { 
                %>
                <div class="component-card" style="text-align:center;">
                    <p>No se han encontrado componentes registrados.</p>
                </div>
                <% } %>
            </div>
        </div>

    </body>
</html>