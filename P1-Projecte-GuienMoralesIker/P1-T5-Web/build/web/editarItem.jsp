<%@ page import="controller.ItemController" %>
<%@ page import="p1.t4.model.Item" %>
<%@ page import="p1.t4.model.Component" %>
<%@ page import="p1.t4.model.UnitatMesura" %>
<%@ page import="p1.t4.model.Proveidor" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("usuari") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String codigoStr = request.getParameter("codigo");
    if (codigoStr == null || codigoStr.isEmpty()) {
        response.sendRedirect("welcome.jsp");
        return;
    }

    int codigo = Integer.parseInt(codigoStr);
    ItemController itemController = new ItemController();

    Item item = itemController.obtenerItemPorId(codigo);
    if (item == null) {
        out.println("<script>alert('Item no trobat.'); window.location='welcome.jsp';</script>");
        return;
    }

    List<Item> subitems = null;
    if ("P".equalsIgnoreCase(item.getItTipus())) {
        subitems = itemController.obtenerItemsDelProducto(codigo);
    }

    List<Item> todosItems = itemController.obtenerTodosItems();

    Component component = null;
    List<UnitatMesura> unitats = null;
    List<Proveidor> proveidors = null;
    if ("C".equalsIgnoreCase(item.getItTipus())) {
        component = itemController.obtenerComponentPorId(codigo);
        unitats = itemController.obtenerUnidades();
        proveidors = itemController.obtenerProveedores();
    }
%>
<!DOCTYPE html>
<html lang="ca">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AutoFactory — Editar: <%= item.getItNom() %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <style>
        .bom-nivell-1 { background: #f8f9fa; }
        .bom-nivell-1 td:first-child::before { content: "↳ "; color: #3498db; }
        .bom-header {
            background: #2c3e50;
            color: white;
            padding: 10px 15px;
            border-radius: 5px 5px 0 0;
            margin-top: 20px;
        }
    </style>
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
        <a href="welcome.jsp" style="color:#7f8c8d; text-decoration:none;">← Tornar al llistat</a>

        <div class="form-wrapper" style="margin-top:15px;">
            <h1>✏️ Editar: <%= item.getItNom() %></h1>

            <%-- ===== FORMULARI PRINCIPAL: guardar canvis ===== --%>
            <form action="guardarItem.jsp" method="post">
                <input type="hidden" name="id" value="<%= item.getItCodi() %>">
                <input type="hidden" name="tipo" value="<%= item.getItTipus() %>">
                <input type="hidden" name="accion" value="guardar">

                <label>Codi (no editable)</label>
                <input type="text" value="<%= item.getItCodi() %>" readonly>

                <label>Tipus (no editable)</label>
                <input type="text"
                       value="<%= "P".equals(item.getItTipus()) ? "Producte" : "Component" %>"
                       readonly>

                <label>Nom: *</label>
                <input type="text" name="nombre"
                       value="<%= item.getItNom() %>" required maxlength="30">

                <label>Descripció: *</label>
                <input type="text" name="descripcion"
                       value="<%= item.getItDescripio() %>" required maxlength="50">

                <label>Stock: *</label>
                <input type="number" name="stock"
                       value="<%= item.getItStock() %>" required min="0">

                <%-- Imatge actual --%>
                <label>Imatge actual</label>
                <div class="img-container">
                    <% if (item.getItFoto() != null && item.getItFoto().length > 0) {
                        String base64Image = Base64.getEncoder().encodeToString(item.getItFoto()); %>
                        <img src="data:image/jpeg;base64,<%= base64Image %>"
                             class="preview-img" alt="Foto">
                    <% } else { %>
                        <p style="color:#aaa; font-size:0.9em;">Sense imatge</p>
                    <% } %>
                </div>

                <label>Canviar imatge (opcional)</label>
                <input type="file" id="fileInput" accept="image/*" onchange="processImage()">
                <input type="hidden" name="fotoBase64" id="fotoBase64">

                <%-- CAMPS ESPECÍFICS COMPONENT --%>
                <% if ("C".equalsIgnoreCase(item.getItTipus()) && component != null) { %>
                <div class="section-component" style="margin-top:20px;">
                    <h3>🔧 Dades del Component</h3>

                    <label>Codi Fabricant: *</label>
                    <input type="text" name="cmCodiFabricant"
                           value="<%= component.getCmCodiFabricant() != null
                                      ? component.getCmCodiFabricant() : "" %>"
                           required maxlength="20">

                    <label>Unitat de Mesura:</label>
                    <select name="cmUmCodi">
                        <option value="">-- Selecciona --</option>
                        <% if (unitats != null) { for (UnitatMesura u : unitats) { %>
                        <option value="<%= u.getCodiMesura() %>"
                            <%= (component.getCmUmCodi() == u.getCodiMesura())
                                ? "selected" : "" %>>
                            <%= u.getNom() %>
                        </option>
                        <% } } %>
                    </select>

                    <label>Preu mig (gestionat automàticament):</label>
                    <input type="text" value="<%= component.getCmPreuMig() %> €" readonly>
                    <small style="color:#777;">
                        El preu es recalcula automàticament via trigger de BD.
                    </small>
                </div>
                <% } %>

                <%-- BOM — QUANTITATS (dins el form principal per guardar-les) --%>
                <% if ("P".equalsIgnoreCase(item.getItTipus())) { %>
                <div class="section-producte" style="margin-top:20px;">
                    <div class="bom-header">
                        <h3 style="margin:0; color:white;">⚙️ Composició del Producte (BOM)</h3>
                    </div>

                    <% if (subitems != null && !subitems.isEmpty()) { %>
                    <table style="margin-top:0;">
                        <thead>
                            <tr>
                                <th>Codi</th>
                                <th>Nom</th>
                                <th>Tipus</th>
                                <th>Quantitat</th>
                                <th>Eliminar</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% for (Item s : subitems) { %>
                            <tr>
                                <td><%= s.getItCodi() %></td>
                                <td>
                                    <a href="editarItem.jsp?codigo=<%= s.getItCodi() %>"
                                       style="color:#3498db; text-decoration:none;">
                                        <%= s.getItNom() %>
                                    </a>
                                </td>
                                <td>
                                    <% if ("P".equals(s.getItTipus())) { %>
                                        <span class="badge-P">Producte</span>
                                    <% } else { %>
                                        <span class="badge-C">Component</span>
                                    <% } %>
                                </td>
                                <td>
                                    <%-- Quantitat dins el form principal per guardar-la --%>
                                    <input type="number"
                                           name="cantidad_<%= s.getItCodi() %>"
                                           value="<%= s.getCantidad() %>"
                                           min="1" style="width:70px;">
                                </td>
                                <td>
                                    <%-- FORMULARI PROPI per eliminar subitem del BOM --%>
                                    <form action="guardarItem.jsp" method="post"
                                          style="display:inline;">
                                        <input type="hidden" name="id"
                                               value="<%= item.getItCodi() %>">
                                        <input type="hidden" name="tipo"
                                               value="<%= item.getItTipus() %>">
                                        <input type="hidden" name="eliminar"
                                               value="<%= s.getItCodi() %>">
                                        <button type="submit" class="btn-danger"
                                                style="padding:5px 10px;"
                                                onclick="return confirm('Eliminar <%= s.getItNom() %> del BOM?');">
                                            🗑️
                                        </button>
                                    </form>
                                </td>
                            </tr>

                            <%-- Nivell 2: fills del subproducte --%>
                            <% if ("P".equals(s.getItTipus())) {
                                List<Item> fills = itemController.obtenerItemsDelProducto(s.getItCodi());
                                if (fills != null && !fills.isEmpty()) {
                                    for (Item fill : fills) { %>
                            <tr class="bom-nivell-1">
                                <td><%= fill.getItCodi() %></td>
                                <td><%= fill.getItNom() %></td>
                                <td>
                                    <% if ("P".equals(fill.getItTipus())) { %>
                                        <span class="badge-P">Producte</span>
                                    <% } else { %>
                                        <span class="badge-C">Component</span>
                                    <% } %>
                                </td>
                                <td><%= fill.getCantidad() %></td>
                                <td style="color:#aaa; font-size:0.85em;">
                                    Edita '<%= s.getItNom() %>'
                                </td>
                            </tr>
                            <% } } } %>

                        <% } %>
                        </tbody>
                    </table>
                    <% } else { %>
                    <p style="color:#777; padding:15px;">
                        Aquest producte no té subitems encara.
                    </p>
                    <% } %>
                </div>
                <% } %>

                <div style="display:flex; gap:10px; margin-top:20px; flex-wrap:wrap;">
                    <button type="submit" class="btn-save" style="flex:1;">
                        💾 GUARDAR CANVIS
                    </button>
                    <% if ("P".equalsIgnoreCase(item.getItTipus())) { %>
                        <a href="generarReporte.jsp?codigo=<%= item.getItCodi() %>"
                           class="btn-primary" target="_blank"
                           style="display:flex; align-items:center; padding:10px 10px;
                                  text-decoration:none; border-radius:5px; font-size:16px;">
                            Generar Informe PDF
                        </a>
                    <% } %>
                </div>
            </form>

            <%-- ===== FORMULARI SEPARAT: afegir subitem ===== --%>
            <%-- Separat del principal per evitar que validi nom/stock/etc --%>
            <% if ("P".equalsIgnoreCase(item.getItTipus())) { %>
            <div class="section-producte" style="margin-top:20px;">
                <h4 style="margin-bottom:15px;">➕ Afegir nou subitem al BOM</h4>
                <form action="guardarItem.jsp" method="post"
                      style="display:flex; gap:10px; align-items:flex-end; flex-wrap:wrap;">
                    <input type="hidden" name="id" value="<%= item.getItCodi() %>">
                    <input type="hidden" name="tipo" value="<%= item.getItTipus() %>">
                    <input type="hidden" name="accion" value="añadir">

                    <div style="flex:2;">
                        <label>Item a afegir:</label>
                        <select name="nuevoSubitem" required>
                            <option value="">-- Selecciona --</option>
                            <% for (Item t : todosItems) {
                                boolean yaExiste = (t.getItCodi() == item.getItCodi());
                                if (!yaExiste && subitems != null) {
                                    for (Item s : subitems) {
                                        if (s.getItCodi() == t.getItCodi()) {
                                            yaExiste = true; break;
                                        }
                                    }
                                }
                                if (!yaExiste) { %>
                            <option value="<%= t.getItCodi() %>">
                                <%= t.getItNom() %>
                                (<%= "P".equals(t.getItTipus()) ? "Producte" : "Component" %>)
                            </option>
                            <% } } %>
                        </select>
                    </div>

                    <div style="width:100px;">
                        <label>Quantitat:</label>
                        <input type="number" name="cantidadNuevo"
                               value="1" min="1" required>
                    </div>

                    <button type="submit" class="btn-success"
                            style="height:42px; padding:0 15px;">
                        + Afegir
                    </button>
                </form>
            </div>
            <% } %>

        </div>
    </div>
</div>

<script>
    function processImage() {
        var file = document.getElementById('fileInput').files[0];
        if (!file) return;
        var reader = new FileReader();
        reader.onloadend = function() {
            document.getElementById('fotoBase64').value = reader.result;
        };
        reader.readAsDataURL(file);
    }
</script>
</body>
</html>