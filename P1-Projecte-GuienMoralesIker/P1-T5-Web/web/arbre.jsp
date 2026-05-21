<%--
    Vista en arbre jeràrquic del BOM.
    Mostra tots els productes amb els seus subitems en format d'arbre expandible.
    Permet navegar als subitems fent clic sobre ells.
--%>
<%@ page import="controller.ItemController" %>
<%@ page import="p1.t4.model.Item" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("usuari") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    ItemController controller = new ItemController();
    // Obtenim només els productes (tipus P) per mostrar l'arbre
    List<Item> productes = controller.obtenerItems("P");
%>
<!DOCTYPE html>
<html lang="ca">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AutoFactory — Vista en Arbre</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <style>
        /* ===== ARBRE ===== */
        .arbre-container {
            padding: 10px;
        }

        .arbre-producte {
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        /* Capçalera del producte arrel */
        .arbre-producte-header {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 15px;
            background: #2c3e50;
            color: white;
            cursor: pointer;
            user-select: none;
        }

        .arbre-producte-header:hover {
            background: #34495e;
        }

        .arbre-producte-header .toggle-icon {
            font-size: 18px;
            width: 20px;
            text-align: center;
            transition: transform 0.2s;
        }

        .arbre-producte-header .nom {
            font-weight: bold;
            font-size: 16px;
            flex: 1;
        }

        .arbre-producte-header .codi {
            font-size: 12px;
            opacity: 0.7;
        }

        .arbre-producte-header .btn-editar-arbre {
            background: #3498db;
            color: white;
            padding: 4px 10px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 12px;
        }

        .arbre-producte-header .btn-editar-arbre:hover {
            background: #2980b9;
        }

        /* Cos de l'arbre (fills) */
        .arbre-fills {
            padding: 10px 0;
            background: #f9f9f9;
        }

        /* Fila de cada node de l'arbre */
        .arbre-node {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 15px;
            border-bottom: 1px solid #eee;
            transition: background 0.2s;
        }

        .arbre-node:last-child {
            border-bottom: none;
        }

        .arbre-node:hover {
            background: #ecf0f1;
        }

        /* Indentació per nivells */
        .nivell-1 { padding-left: 30px; }
        .nivell-2 { padding-left: 60px; background: #f0f4f8; }
        .nivell-3 { padding-left: 90px; background: #e8f0f8; }

        /* Connector visual de l'arbre */
        .connector {
            color: #bdc3c7;
            font-size: 16px;
            flex-shrink: 0;
        }

        /* Icona del tipus */
        .icona-tipus {
            flex-shrink: 0;
            font-size: 16px;
        }

        /* Nom del node */
        .node-nom {
            flex: 1;
            font-size: 14px;
        }

        .node-nom a {
            color: #2c3e50;
            text-decoration: none;
            font-weight: bold;
        }

        .node-nom a:hover {
            color: #3498db;
            text-decoration: underline;
        }

        /* Quantitat */
        .node-quantitat {
            background: #ecf0f1;
            color: #555;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 12px;
        }

        /* Missatge buit */
        .buit-msg {
            padding: 15px 20px;
            color: #777;
            font-style: italic;
        }

        /* Producte sense fills */
        .sense-fills {
            padding: 10px 30px;
            color: #aaa;
            font-size: 13px;
            font-style: italic;
        }

        /* Llegenda */
        .llegenda {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
            align-items: center;
        }

        .llegenda-item {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 13px;
            color: #555;
        }

        /* Buscador d'arbre */
        .arbre-buscador {
            padding: 10px;
            width: 300px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        /* Botons expandir/contraure tots */
        .btn-expandir {
            background: #1abc9c;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 13px;
            margin-right: 5px;
        }

        .btn-contraure {
            background: #95a5a6;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 13px;
        }
    </style>
</head>
<body>
<div class="container">

    <%-- Barra lateral --%>
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

    <%-- Contingut principal --%>
    <div class="content">
        <h1>🌳 Vista en Arbre del BOM</h1>

        <%-- Controls --%>
        <div style="display:flex; gap:10px; align-items:center; margin-bottom:15px; flex-wrap:wrap;">
            <input type="text" class="arbre-buscador" id="buscadorArbre"
                   onkeyup="filtrarArbre()"
                   placeholder="🔍 Cercar producte...">
            <button class="btn-expandir" onclick="expandirTots()">▼ Expandir tots</button>
            <button class="btn-contraure" onclick="contraureTots()">▶ Contraure tots</button>
        </div>

        <%-- Llegenda --%>
        <div class="llegenda">
            <span style="font-weight:bold; color:#555;">Llegenda:</span>
            <span class="llegenda-item">📦 <span class="badge-P">Producte</span></span>
            <span class="llegenda-item">🔧 <span class="badge-C">Component</span></span>
            <span class="llegenda-item">
                <span class="node-quantitat">x3</span> Quantitat al BOM
            </span>
        </div>

        <%-- Arbre de productes --%>
        <div class="arbre-container">
            <% if (productes == null || productes.isEmpty()) { %>
                <div class="alert-error">No hi ha productes registrats.</div>
            <% } else {
                for (Item producte : productes) {
                    List<Item> fills = controller.obtenerItemsDelProducto(producte.getItCodi());
            %>

            <%-- Node arrel: Producte --%>
            <div class="arbre-producte" data-nom="<%= producte.getItNom().toLowerCase() %>">
                <div class="arbre-producte-header"
                     onclick="toggleFills(<%= producte.getItCodi() %>)">
                    <span class="toggle-icon" id="icon-<%= producte.getItCodi() %>">▼</span>
                    <span class="icona-tipus">📦</span>
                    <span class="nom"><%= producte.getItNom() %></span>
                    <span class="codi">ID: <%= producte.getItCodi() %></span>
                    <span class="badge-P" style="font-size:11px;">Producte</span>
                    <a href="editarItem.jsp?codigo=<%= producte.getItCodi() %>"
                       class="btn-editar-arbre"
                       onclick="event.stopPropagation()">✏️ Editar</a>
                </div>

                <%-- Fills de nivell 1 --%>
                <div class="arbre-fills" id="fills-<%= producte.getItCodi() %>">
                    <% if (fills == null || fills.isEmpty()) { %>
                        <div class="sense-fills">Aquest producte no té components al BOM.</div>
                    <% } else {
                        for (Item fill : fills) { %>

                    <%-- Node nivell 1 --%>
                    <div class="arbre-node nivell-1">
                        <span class="connector">├─</span>
                        <span class="icona-tipus">
                            <%= "P".equals(fill.getItTipus()) ? "📦" : "🔧" %>
                        </span>
                        <span class="node-nom">
                            <% if ("P".equals(fill.getItTipus())) { %>
                                <%-- Si és producte, es pot navegar al seu BOM --%>
                                <a href="editarItem.jsp?codigo=<%= fill.getItCodi() %>">
                                    <%= fill.getItNom() %>
                                </a>
                            <% } else { %>
                                <%= fill.getItNom() %>
                            <% } %>
                        </span>
                        <% if ("P".equals(fill.getItTipus())) { %>
                            <span class="badge-P" style="font-size:11px;">Producte</span>
                        <% } else { %>
                            <span class="badge-C" style="font-size:11px;">Component</span>
                        <% } %>
                        <span class="node-quantitat">x<%= fill.getCantidad() %></span>
                    </div>

                    <%-- Fills de nivell 2 (si el fill és producte) --%>
                    <% if ("P".equals(fill.getItTipus())) {
                        List<Item> fillsFill = controller.obtenerItemsDelProducto(fill.getItCodi());
                        if (fillsFill != null && !fillsFill.isEmpty()) {
                            for (Item fillFill : fillsFill) { %>
                    <div class="arbre-node nivell-2">
                        <span class="connector">│&nbsp;&nbsp;├─</span>
                        <span class="icona-tipus">
                            <%= "P".equals(fillFill.getItTipus()) ? "📦" : "🔧" %>
                        </span>
                        <span class="node-nom">
                            <% if ("P".equals(fillFill.getItTipus())) { %>
                                <a href="editarItem.jsp?codigo=<%= fillFill.getItCodi() %>">
                                    <%= fillFill.getItNom() %>
                                </a>
                            <% } else { %>
                                <%= fillFill.getItNom() %>
                            <% } %>
                        </span>
                        <% if ("P".equals(fillFill.getItTipus())) { %>
                            <span class="badge-P" style="font-size:11px;">Producte</span>
                        <% } else { %>
                            <span class="badge-C" style="font-size:11px;">Component</span>
                        <% } %>
                        <span class="node-quantitat">x<%= fillFill.getCantidad() %></span>
                    </div>
                    <%      }
                        }
                    } %>

                    <% } %>
                    <% } %>
                </div>
            </div>

            <% } } %>
        </div>
    </div>
</div>

<script>
    /**
     * Expandeix o contrau els fills d'un producte.
     * @param {number} id - ID del producte
     */
    function toggleFills(id) {
        var fills = document.getElementById("fills-" + id);
        var icon  = document.getElementById("icon-" + id);
        if (fills.style.display === "none") {
            fills.style.display = "block";
            icon.textContent = "▼";
        } else {
            fills.style.display = "none";
            icon.textContent = "▶";
        }
    }

    /**
     * Expandeix tots els nodes de l'arbre.
     */
    function expandirTots() {
        document.querySelectorAll(".arbre-fills").forEach(function(el) {
            el.style.display = "block";
        });
        document.querySelectorAll(".toggle-icon").forEach(function(el) {
            el.textContent = "▼";
        });
    }

    /**
     * Contrau tots els nodes de l'arbre.
     */
    function contraureTots() {
        document.querySelectorAll(".arbre-fills").forEach(function(el) {
            el.style.display = "none";
        });
        document.querySelectorAll(".toggle-icon").forEach(function(el) {
            el.textContent = "▶";
        });
    }

    /**
     * Filtra els productes de l'arbre per nom.
     */
    function filtrarArbre() {
        var filter = document.getElementById("buscadorArbre").value.toLowerCase();
        document.querySelectorAll(".arbre-producte").forEach(function(el) {
            var nom = el.getAttribute("data-nom");
            el.style.display = nom.indexOf(filter) > -1 ? "block" : "none";
        });
    }
</script>
</body>
</html>