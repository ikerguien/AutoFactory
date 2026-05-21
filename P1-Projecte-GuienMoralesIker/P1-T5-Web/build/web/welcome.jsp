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

    String tipo     = request.getParameter("tipo");
    String busqueda = request.getParameter("busqueda");
    String pageParam = request.getParameter("p");
    int paginaActual = (pageParam == null || pageParam.isEmpty()) ? 1 : Integer.parseInt(pageParam);
    int itemsPorPagina = 10;

    ItemController controller = new ItemController();
    List<Item> todosLosItems;

    // Si hay búsqueda busca en TODOS los items sin paginar
    if (busqueda != null && !busqueda.trim().isEmpty()) {
        todosLosItems = controller.buscarItems(busqueda.trim());
    } else {
        todosLosItems = controller.obtenerItems(tipo);
    }

    int totalItems = todosLosItems.size();
    int totalPaginas = (int) Math.ceil((double) totalItems / itemsPorPagina);
    if (totalPaginas == 0) totalPaginas = 1;

    int inicio = (paginaActual - 1) * itemsPorPagina;
    int fin = Math.min(inicio + itemsPorPagina, totalItems);
    List<Item> itemsPaginados = (totalItems > 0)
        ? todosLosItems.subList(inicio, fin)
        : new ArrayList<Item>();

    // Paràmetres per conservar en els enllaços de paginació
    String tipoParam     = (tipo != null && !tipo.isEmpty()) ? "&tipo=" + tipo : "";
    String busquedaParam = (busqueda != null && !busqueda.isEmpty()) ? "&busqueda=" + busqueda : "";
%>
<!DOCTYPE html>
<html lang="ca">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AutoFactory — Inici</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
<div class="container">
    <div class="sidebar">
        <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo"
             style="mix-blend-mode: multiply;">
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

        <%-- Filtre per tipus + buscador servidor --%>
        <div style="display:flex; gap:15px; align-items:center; margin-bottom:20px; flex-wrap:wrap;">

            <%-- Filtre per tipus --%>
            <form action="welcome.jsp" method="GET" style="display:flex; gap:10px; align-items:center;">
                <label for="tipo">Filtrar per:</label>
                <select id="tipo" name="tipo"
                        style="padding:8px; border-radius:5px; border:1px solid #ccc;">
                    <option value="">Tots</option>
                    <option value="P" <%= "P".equals(tipo) ? "selected" : "" %>>Producte</option>
                    <option value="C" <%= "C".equals(tipo) ? "selected" : "" %>>Component</option>
                </select>
                <button type="submit" class="btn-primary">Filtrar</button>
            </form>

            <%-- Buscador servidor (busca en TOTS els items) --%>
            <form action="welcome.jsp" method="GET"
                  style="display:flex; gap:5px; align-items:center;">
                <input type="hidden" name="tipo" value="<%= tipo != null ? tipo : "" %>">
                <input type="text" name="busqueda"
                       value="<%= busqueda != null ? busqueda : "" %>"
                       placeholder="🔍 Cercar per nom o codi..."
                       style="padding:8px; border-radius:5px; border:1px solid #ccc; width:250px;">
                <button type="submit" class="btn-primary">🔍</button>
                <% if (busqueda != null && !busqueda.isEmpty()) { %>
                    <a href="welcome.jsp" class="btn-danger" style="padding:8px 12px;">✕</a>
                <% } %>
            </form>
        </div>

        <%-- Missatge de resultats de cerca --%>
        <% if (busqueda != null && !busqueda.isEmpty()) { %>
        <p style="color:#3498db; margin-bottom:10px;">
            Resultats per "<strong><%= busqueda %></strong>":
            <strong><%= totalItems %></strong> items trobats.
        </p>
        <% } %>

        <%-- Taula d'items --%>
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
                            <% if (busqueda != null && !busqueda.isEmpty()) { %>
                                No s'han trobat items amb "<%= busqueda %>".
                            <% } else { %>
                                No hi ha items registrats.
                            <% } %>
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
                            <a href="editarItem.jsp?codigo=<%= item.getItCodi() %>" class="btn-edit">Editar</a>
                            <a href="eliminarItem.jsp?codigo=<%= item.getItCodi() %>"
                               class="btn-delete"
                               onclick="return confirm('Segur que vols eliminar <%= item.getItNom() %>?');">
                               Eliminar
                            </a>
                            <% if ("P".equals(item.getItTipus())) { %>
                                <a href="generarReporte.jsp?codigo=<%= item.getItCodi() %>"
                                   class="btn-primary" target="_blank"
                                   style="font-size:13px; padding:5px 10px; margin-left: 10px">
                                   DOM
                                </a>
                            <% } %>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>

        <%-- Paginació (conserva tipus i cerca) --%>
        <div class="pagination">
            <% if (paginaActual > 1) { %>
                <a href="welcome.jsp?p=<%= paginaActual - 1 %><%= tipoParam %><%= busquedaParam %>">
                    &laquo; Anterior
                </a>
            <% } %>
            <span>
                Pàgina <%= paginaActual %> de <%= totalPaginas %> | Total: <%= totalItems %> items
            </span>
            <% if (paginaActual < totalPaginas) { %>
                <a href="welcome.jsp?p=<%= paginaActual + 1 %><%= tipoParam %><%= busquedaParam %>">
                    Següent &raquo;
                </a>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>