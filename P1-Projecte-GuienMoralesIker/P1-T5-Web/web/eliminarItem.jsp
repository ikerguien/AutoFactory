<%@ page import="controller.ItemController" %>
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

    try {
        int codigo = Integer.parseInt(codigoStr);
        ItemController controller = new ItemController();
        boolean ok = controller.eliminarItem(codigo);

        if (ok) {
            response.sendRedirect("welcome.jsp");
        } else {
%>
<!DOCTYPE html>
<html lang="ca">
<head>
    <meta charset="UTF-8">
    <title>AutoFactory — Error eliminació</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <style>
        body { display:flex; justify-content:center; align-items:center; height:100vh; background:#f4f4f4; }
        .result-box { background:white; padding:40px; border-radius:12px; box-shadow:0 4px 10px rgba(0,0,0,0.1); text-align:center; max-width:450px; }
    </style>
</head>
<body>
<div class="result-box">
    <h2 style="color:#c0392b;">⚠️ No es pot eliminar</h2>
    <p>L'item amb codi <strong><%= codigoStr %></strong> no s'ha pogut eliminar perquè:</p>
    <ul style="text-align:left; margin:15px 0; color:#555;">
        <li>Forma part del BOM d'un altre producte, o</li>
        <li>Té subitems associats que s'han d'eliminar primer.</li>
    </ul>
    <p style="color:#777; font-size:0.9em;">Edita el producte que el conté i elimina'l del BOM primer.</p>
    <a href="welcome.jsp" class="btn-edit" style="display:inline-block; margin-top:15px;">← Tornar al llistat</a>
</div>
</body>
</html>
<%
        }
    } catch (NumberFormatException e) {
        response.sendRedirect("welcome.jsp");
    } catch (Exception e) {
        out.println("<script>alert('Error inesperat.'); window.location='welcome.jsp';</script>");
        e.printStackTrace();
    }
%>