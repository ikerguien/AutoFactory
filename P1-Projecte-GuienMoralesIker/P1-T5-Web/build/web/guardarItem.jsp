<%@ page import="controller.ItemController" %>
<%@ page import="p1.t4.model.Item" %>
<%@ page import="p1.t4.model.Component" %>
<%@ page import="p1.t4.model.Producte" %>
<%@ page import="java.util.Base64" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("usuari") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String idStr       = request.getParameter("id");
    String tipo        = request.getParameter("tipo");
    String nombre      = request.getParameter("nombre");
    String descripcion = request.getParameter("descripcion");
    String stockStr    = request.getParameter("stock");
    String accion      = request.getParameter("accion");
    String eliminarStr = request.getParameter("eliminar");

    int idExistente = (idStr != null && !idStr.isEmpty()) ? Integer.parseInt(idStr) : 0;

    // ===== ELIMINAR SUBITEM =====
    if (eliminarStr != null && !eliminarStr.isEmpty() && idExistente > 0) {
        try {
            int subitemEliminar = Integer.parseInt(eliminarStr);
            ItemController ctrl = new ItemController();
            ctrl.eliminarSubitem(idExistente, subitemEliminar);
        } catch (Exception e) {
            System.err.println("Error eliminant subitem: " + e.getMessage());
        }
        response.sendRedirect("editarItem.jsp?codigo=" + idExistente);
        return;
    }

    // ===== AFEGIR SUBITEM =====
    if ("añadir".equals(accion) && idExistente > 0) {
        String nuevoSubStr  = request.getParameter("nuevoSubitem");
        String cantNuevoStr = request.getParameter("cantidadNuevo");
        if (nuevoSubStr != null && !nuevoSubStr.isEmpty()) {
            try {
                int nuevoSub  = Integer.parseInt(nuevoSubStr);
                int cantNuevo = (cantNuevoStr != null && !cantNuevoStr.isEmpty())
                    ? Integer.parseInt(cantNuevoStr) : 1;
                ItemController ctrl = new ItemController();
                ctrl.agregarSubitem(idExistente, nuevoSub, cantNuevo);
            } catch (Exception e) {
                System.err.println("Error afegint subitem: " + e.getMessage());
            }
        }
        response.sendRedirect("editarItem.jsp?codigo=" + idExistente);
        return;
    }

    // ===== VALIDACIÓ =====
    String errorValidacio = null;
    if (tipo == null || tipo.isEmpty()) {
        errorValidacio = "El tipus d'item és obligatori.";
    } else if (nombre == null || nombre.trim().isEmpty()) {
        errorValidacio = "El nom de l'item és obligatori.";
    } else if (descripcion == null || descripcion.trim().isEmpty()) {
        errorValidacio = "La descripció és obligatòria.";
    } else if (stockStr == null || stockStr.isEmpty()) {
        errorValidacio = "El stock és obligatori.";
    }

    if (errorValidacio != null) {
        String backUrl = (idExistente > 0)
            ? "editarItem.jsp?codigo=" + idExistente : "crearItem.jsp";
%>
<!DOCTYPE html>
<html lang="ca">
<head>
    <meta charset="UTF-8">
    <title>AutoFactory — Error</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <style>
        body { display:flex; justify-content:center; align-items:center; height:100vh; background:#f4f4f4; }
        .result-box { background:white; padding:40px; border-radius:12px; box-shadow:0 4px 10px rgba(0,0,0,0.1); text-align:center; max-width:450px; }
    </style>
</head>
<body>
<div class="result-box">
    <h2 style="color:#c0392b;">⚠️ Error de validació</h2>
    <p class="alert-error"><%= errorValidacio %></p>
    <a href="<%= backUrl %>" class="btn-edit" style="display:inline-block; margin-top:15px;">← Tornar</a>
</div>
</body>
</html>
<%
        return;
    }

    // ===== FOTO =====
    String fotoBase64 = request.getParameter("fotoBase64");
    byte[] fotoBytes = null;
    if (fotoBase64 != null && fotoBase64.contains(",")) {
        try {
            String base64Data = fotoBase64.split(",")[1];
            fotoBytes = Base64.getDecoder().decode(base64Data);
        } catch (Exception e) {
            System.err.println("Error decodificant foto: " + e.getMessage());
        }
    }

    int stock = Integer.parseInt(stockStr.trim());
    ItemController ctrl = new ItemController();
    int resultadoId = 0;

    // ===== PRODUCTE =====
    if ("P".equals(tipo)) {
        Producte p = new Producte();
        p.setItCodi(idExistente);
        p.setPrCodi(idExistente);
        p.setItNom(nombre.trim());
        p.setItDescripio(descripcion.trim());
        p.setItStock(stock);
        p.setItTipus("P");
        p.setItFoto(fotoBytes);

        if (idExistente > 0) {
            // Edició: actualitzem ITEM
            resultadoId = (ctrl.actualizarItem(p) > 0) ? idExistente : 0;

            // Actualitzem quantitats dels subitems del BOM
            if (resultadoId > 0) {
                java.util.Enumeration<String> params = request.getParameterNames();
                while (params.hasMoreElements()) {
                    String param = params.nextElement();
                    if (param.startsWith("cantidad_")) {
                        try {
                            int subitemId = Integer.parseInt(param.replace("cantidad_", ""));
                            int cantidad  = Integer.parseInt(request.getParameter(param));
                            ctrl.actualizarCantidadItemHijo(idExistente, subitemId, cantidad);
                        } catch (NumberFormatException nfe) {
                            // Ignorem paràmetres malformats
                        }
                    }
                }
            }
        } else {
            // Alta nova: inserim producte amb subitems
            String[] idsSubitems   = request.getParameterValues("subitem_id[]");
            String[] cantsSubitems = request.getParameterValues("subitem_cantidad[]");

            if (idsSubitems != null && cantsSubitems != null) {
                for (int i = 0; i < idsSubitems.length; i++) {
                    if (!idsSubitems[i].isEmpty()) {
                        Item hijo = new Item();
                        hijo.setItCodi(Integer.parseInt(idsSubitems[i]));
                        p.addSubitem(hijo, Integer.parseInt(cantsSubitems[i]));
                    }
                }
            }
            resultadoId = ctrl.agregarProducto(p);
        }

    // ===== COMPONENT =====
    } else if ("C".equals(tipo)) {
        Component c = new Component();
        c.setItCodi(idExistente);
        c.setCmCodi(idExistente);
        c.setItNom(nombre.trim());
        c.setItDescripio(descripcion.trim());
        c.setItStock(stock);
        c.setItTipus("C");
        c.setItFoto(fotoBytes);
        c.setCmCodiFabricant(request.getParameter("cmCodiFabricant"));

        String umStr = request.getParameter("cmUmCodi");
        if (umStr != null && !umStr.isEmpty()) {
            c.setCmUmCodi(Integer.parseInt(umStr));
        }

        String preuStr = request.getParameter("cmPreuMig");
        double preu = (preuStr != null && !preuStr.isEmpty()) ? Double.parseDouble(preuStr) : 0;
        c.setCmPreuMig(preu);

        if (idExistente > 0) {
            resultadoId = (ctrl.actualizarItem(c) > 0) ? idExistente : 0;
        } else {
            resultadoId = ctrl.agregarComponente(c);
            String provId = request.getParameter("proveedor");
            if (resultadoId > 0 && provId != null && !provId.isEmpty()) {
                ctrl.vincularProveedor(resultadoId, Integer.parseInt(provId), preu);
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="ca">
<head>
    <meta charset="UTF-8">
    <title>AutoFactory — Resultat</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <style>
        body { display:flex; justify-content:center; align-items:center; height:100vh; background:#f4f4f4; }
        .result-box { background:white; padding:40px; border-radius:12px; box-shadow:0 4px 10px rgba(0,0,0,0.1); text-align:center; max-width:450px; }
        .actions { display:flex; gap:10px; justify-content:center; flex-wrap:wrap; margin-top:20px; }
    </style>
</head>
<body>
<div class="result-box">
    <% if (resultadoId > 0) { %>
        <h2 style="color:#27ae60;">✅ Item guardat correctament</h2>
        <p>ID: <strong><%= resultadoId %></strong></p>
        <div class="actions">
            <a href="welcome.jsp" class="btn-edit">🏠 Inici</a>
            <a href="editarItem.jsp?codigo=<%= resultadoId %>" class="btn-primary">✏️ Editar</a>
        </div>
    <% } else { %>
        <h2 style="color:#c0392b;">❌ Error en guardar</h2>
        <p>No s'ha pogut guardar l'item. Comprova els camps i torna-ho a intentar.</p>
        <div class="actions">
            <a href="<%= (idExistente > 0) ? "editarItem.jsp?codigo=" + idExistente : "crearItem.jsp" %>"
               class="btn-danger">← Tornar</a>
            <a href="welcome.jsp" class="btn-edit">🏠 Inici</a>
        </div>
    <% } %>
</div>
</body>
</html>