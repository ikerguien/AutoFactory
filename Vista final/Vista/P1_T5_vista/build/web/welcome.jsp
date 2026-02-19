<%@ page import="controller.ItemController" %>
<%@ page import="java.util.List" %>
<%@ page import="P1_T4_Model.Item" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Gestión de Componentes y Productos</title>
        <link rel="stylesheet" href="styles.css">
        <script>
            // Función para buscar dinámicamente en la tabla
            function buscarItems() {
                var input = document.getElementById("buscador");  // Obtener el campo de búsqueda
                var filter = input.value.toLowerCase();  // Obtener el texto en minúsculas
                var table = document.getElementById("tablaItems");  // Obtener la tabla
                var rows = table.getElementsByTagName("tr");  // Obtener todas las filas de la tabla

                // Iterar sobre todas las filas de la tabla
                for (var i = 1; i < rows.length; i++) {  // Empezamos desde 1 para evitar la fila de los encabezados
                    var cells = rows[i].getElementsByTagName("td");
                    var found = false;  // Variable para verificar si encontramos coincidencias

                    // Verificar si alguno de los campos (código o nombre) contiene el texto de búsqueda
                    for (var j = 0; j < cells.length; j++) {
                        var cellText = cells[j].textContent || cells[j].innerText;
                        if (cellText.toLowerCase().indexOf(filter) > -1) {
                            found = true;
                            break;  // Si encontramos una coincidencia, no seguimos buscando en las demás celdas
                        }
                    }

                    // Mostrar o esconder la fila dependiendo si hay coincidencias
                    if (found) {
                        rows[i].style.display = "";
                    } else {
                        rows[i].style.display = "none";
                    }
                }
            }
        </script>
    </head>
    <body>
        <div class="container">
            <!-- Menú lateral -->
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

            <!-- Contenido principal -->
            <div class="content">
                <h1>Listado de Componentes y Productos</h1>



                <!-- Filtro por tipo (Producto o Componente) -->
                <form action="welcome.jsp" method="GET" style="margin-bottom: 20px;">
                    <label for="tipo">Filtrar por:</label>
                    <select id="tipo" name="tipo">
                        <option value="">Todos</option>
                        <option value="P" <%= "P".equals(request.getParameter("tipo")) ? "selected" : "" %>>Producto</option>
                        <option value="C" <%= "C".equals(request.getParameter("tipo")) ? "selected" : "" %>>Componente</option>
                    </select>

                    <input type="text" name="search" value="<%= (request.getParameter("search") != null) ? request.getParameter("search") : "" %>" 
                           placeholder="Buscar en todo el catálogo..." style="padding: 8px; width: 250px;">

                    <button type="submit">Buscar</button>
                </form>



                <!-- Lista de Items o Componentes -->
                <div class="highlight-section">
                    <table id="tablaItems" border="1" class="mostrar">
                        <tr>
                            <th>Código</th>
                            <th>Nombre</th>
                            <th>Descripción</th>
                            <th>Tipo</th>
                            <th>Stock</th>
                            <th>Acciones</th>

                        </tr>

                        <% 
     String tipo = request.getParameter("tipo");
     String search = request.getParameter("search"); 
     String pageParam = request.getParameter("p");
     int paginaActual = (pageParam == null) ? 1 : Integer.parseInt(pageParam);
     int itemsPorPagina = 10;

     ItemController controller = new ItemController();
     List<Item> todosLosItems = controller.obtenerItems(tipo); 

     // --- FILTRADO GLOBAL CON BUCLE TRADICIONAL (MÁS COMPATIBLE) ---
     List<Item> listaFiltrada = new java.util.ArrayList<Item>();
    
     if (search != null && !search.trim().isEmpty()) {
         String query = search.toLowerCase();
         for (Item i : todosLosItems) {
             String nombre = (i.getItNom() != null) ? i.getItNom().toLowerCase() : "";
             String codigo = String.valueOf(i.getItCodi());
            
             if (nombre.contains(query) || codigo.contains(query)) {
                 listaFiltrada.add(i);
             }
         }
         todosLosItems = listaFiltrada; // Usamos la lista filtrada
     }
     // --------------------------------------------------------------

     int totalItems = todosLosItems.size();
     int totalPaginas = (int) Math.ceil((double) totalItems / itemsPorPagina);
     int inicio = (paginaActual - 1) * itemsPorPagina;
     int fin = Math.min(inicio + itemsPorPagina, totalItems);

     List<Item> itemsPaginados = (totalItems > 0) ? todosLosItems.subList(inicio, fin) : new java.util.ArrayList<Item>();
    
     for (Item item : itemsPaginados) { 
                        %>
                        <tr>
                            <td><%= item.getItCodi() %></td>
                            <td><%= item.getItNom() %></td>
                            <td><%= item.getItDescripio() %></td>
                            <td><%= item.getItTipus() %></td>
                            <td><%= item.getItStock() %></td>
                            <td>
                                <a href="editarItem.jsp?codigo=<%= item.getItCodi() %>" class="btn-edit">Editar</a>
                                <a href="eliminarItem.jsp?codigo=<%= item.getItCodi() %>" class="btn-delete" onclick="return confirm('¿Seguro?');">Eliminar</a>

                                <%-- BOTÓN DE JASPER SOLO PARA PRODUCTOS (TIPO P) --%>
                                <% if ("P".equalsIgnoreCase(item.getItTipus())) { %>
                                <a href="generarReporte.jsp?codigo=<%= item.getItCodi() %>" target="_blank" style="text-decoration: none;">
                                    <button type="button" style="background-color: #27ae60; padding: 5px 10px; margin-left: 5px;">🖨️ PDF</button>
                                </a>
                                <% } %>
                            </td>
                        </tr>
                        <% 
                            } 
                        %>
                    </table>
                    <div class="pagination">
                        <% 
                            String queryParams = "";
                            if (tipo != null && !tipo.isEmpty()) queryParams += "&tipo=" + tipo;
                            if (search != null && !search.isEmpty()) queryParams += "&search=" + search;
                        %>

                        <% if (paginaActual > 1) { %>
                        <a href="welcome.jsp?p=<%= paginaActual - 1 %><%= queryParams %>">&laquo; Anterior</a>
                        <% } %>

                        <span>Página <%= paginaActual %> de <%= totalPaginas %></span>

                        <% if (paginaActual < totalPaginas) { %>
                        <a href="welcome.jsp?p=<%= paginaActual + 1 %><%= queryParams %>">Siguiente &raquo;</a>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

<style>
    /* Estilos generales */

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

    /* Barra lateral */
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


    .mostrar {
        width: 90%;
        margin-left: 5%;
        height: auto; /* <--- CAMBIA ESTO. Evita que las AQilas se estiren */
    }
    .mostrar td, .mostrar th {
        padding: 12px;
        height: 28px; /* Altura fija para que las filas se vean uniformes */
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
        transition: background-color 0.3s ease;
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

    /* Contenido principal */
    .content {
        width: 100%;
        padding: 20px;
        box-sizing: border-box;
        background-color: white;
    }

    h1 {
        text-align: center;
        font-size: 28px;
        color: #34495e;
    }

    /* Filtro */
    select, button {
        padding: 10px;
        margin-top: 10px;
        font-size: 16px;
        cursor: pointer;
    }

    button {
        background-color: #3498db;
        color: white;
        border: none;
        border-radius: 5px;
        transition: background-color 0.3s ease;
    }

    button:hover {
        background-color: #2980b9;
    }

    /* Sección de resultados convertida en tabla */
    .highlight-section {
        width: 80%;
        height: 70%; /* Mantenemos el tamaño grande que te gusta */
        margin: 20px auto;
        padding: 20px;
        background-color: #f39c12;
        color: white;
        text-align: center;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        overflow-y: auto; /* Permite scroll si hay muchos datos */
    }

    .results-table {
        width: 100%;
        border-collapse: collapse;
        margin: 0 auto;
    }

    .results-table th, .results-table td {
        padding: 10px;
        text-align: center;
        border: 1px solid #ddd;
    }

    .results-table th {
        background-color: #34495e;
        color: white;
        font-size: 16px;
    }

    .results-table td {
        background-color: #ecf0f1;
        font-size: 14px;
    }

    .results-table tr:hover {
        background-color: #f39c12;
        cursor: pointer;
    }

    .results-table td button {
        padding: 5px 10px;
        background-color: #3498db;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    .results-table td button:hover {
        background-color: #2980b9;
    }
    .btn-edit {
        padding: 5px 10px;
        background: #3498db;
        color: white;
        border-radius: 5px;
        text-decoration: none;
        margin-right: 5px;
    }

    .btn-delete {
        padding: 5px 10px;
        background: #e74c3c;
        color: white;
        border-radius: 5px;
        text-decoration: none;
    }

    .btn-logout {
        background-color: #e74c3c;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        text-decoration: none;
        display: inline-block;
        margin: 20px 0;
        cursor: pointer;
    }

    .btn-logout:hover {
        background-color: #c0392b;
    }

</style>
