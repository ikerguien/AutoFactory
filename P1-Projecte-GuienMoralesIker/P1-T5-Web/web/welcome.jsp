<%@ page import="controller.ItemController" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="p1.t4.model.Item" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("usuari") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String tipo = request.getParameter("tipo");
    String pageParam = request.getParameter("p");
    int paginaActual = (pageParam == null || pageParam.isEmpty()) ? 1 : Integer.parseInt(pageParam);
    int itemsPorPagina = 10;

    ItemController controller = new ItemController();
    List<Item> todosLosItems = controller.obtenerItems(tipo);

    int totalItems = todosLosItems.size();
    int totalPaginas = (int) Math.ceil((double) totalItems / itemsPorPagina);
    if (totalPaginas == 0) totalPaginas = 1;

    int inicio = (paginaActual - 1) * itemsPorPagina;
    int fin = Math.min(inicio + itemsPorPagina, totalItems);
    List<Item> itemsPaginados = (totalItems > 0)
        ? todosLosItems.subList(inicio, fin)
        : new ArrayList<Item>();

    String tipoParam = (tipo != null && !tipo.isEmpty()) ? "&tipo=" + tipo : "";
%>
<!DOCTYPE html>
<html lang="ca">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AutoFactory — Inici</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <script>
        function buscarItems() {
            var input = document.getElementById("buscador");
            var filter = input.value.toLowerCase();
            var table = document.getElementById("tablaItems");
            var rows = table.getElementsByTagName("tr");
            for (var i = 1; i < rows.length; i++) {
                var cells = rows[i].getElementsByTagName("td");
                var found = false;
                for (var j = 0; j < cells.length; j++) {
                    if (cells[j].textContent.toLowerCase().indexOf(filter) > -1) {
                        found = true; break;
                    }
                }
                rows[i].style.display = found ? "" : "none";
            }
        }
    </script>
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
        <h1>Llistat de Components i Productes</h1>

        <div style="display:flex; gap:15px; align-items:center; margin-bottom:20px; flex-wrap:wrap;">
            <form action="welcome.jsp" method="GET" style="display:flex; gap:10px; align-items:center;">
                <label for="tipo">Filtrar per:</label>
                <select id="tipo" name="tipo" style="padding:8px; border-radius:5px; border:1px solid #ccc;">
                    <option value="">Tots</option>
                    <option value="P" <%= "P".equals(tipo) ? "selected" : "" %>>Producte</option>
                    <option value="C" <%= "C".equals(tipo) ? "selected" : "" %>>Component</option>
                </select>
                <button type="submit" class="btn-primary">🔍 Filtrar</button>
            </form>
            <input type="text" id="buscador" onkeyup="buscarItems()"
                   placeholder="Cercar per nom o codi..."
                   style="padding:8px; border-radius:5px; border:1px solid #ccc; width:250px;">
        </div>

        <div class="table-container">
            <table id="tablaItems">
                <thead>
                    <tr>
                        <th>Codi</th>
                        <th>Nom</th>
                        <th>Descripció</th>
                        <th>Tipus</th>
                        <th>Stock</th>
                        <th>Accions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (itemsPaginados.isEmpty()) { %>
                    <tr>
                        <td colspan="6" style="text-align:center; color:#777; padding:20px;">
                            No hi ha items registrats.
                        </td>
                    </tr>
                    <% } else { for (Item item : itemsPaginados) { %>
                    <tr>
                        <td><%= item.getItCodi() %></td>
                        <td><strong><%= item.getItNom() %></strong></td>
                        <td><%= item.getItDescripio() %></td>
                        <td>
                            <% if ("P".equals(item.getItTipus())) { %>
                                <span class="badge-P">Producte</span>
                            <% } else { %>
                                <span class="badge-C">Component</span>
                            <% } %>
                        </td>
                        <td><%= item.getItStock() %></td>
                        <td>
                            <a href="editarItem.jsp?codigo=<%= item.getItCodi() %>" class="btn-edit">✏️ Editar</a>
                            <a href="eliminarItem.jsp?codigo=<%= item.getItCodi() %>"
                               class="btn-delete"
                               onclick="return confirm('Segur que vols eliminar <%= item.getItNom() %>?');">
                               🗑️ Eliminar
                            </a>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>

        <div class="pagination">
            <% if (paginaActual > 1) { %>
                <a href="welcome.jsp?p=<%= paginaActual - 1 %><%= tipoParam %>">&laquo; Anterior</a>
            <% } %>
            <span>Pàgina <%= paginaActual %> de <%= totalPaginas %> | Total: <%= totalItems %> items</span>
            <% if (paginaActual < totalPaginas) { %>
                <a href="welcome.jsp?p=<%= paginaActual + 1 %><%= tipoParam %>">Següent &raquo;</a>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>