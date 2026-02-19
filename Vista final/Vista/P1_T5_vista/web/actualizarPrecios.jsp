<%@ page import="controller.ItemController, java.math.BigDecimal" contentType="text/html;charset=UTF-8" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Recogemos los datos del formulario
    String itemCodiStr = request.getParameter("itemCodi");
    String[] provIds = request.getParameterValues("prov_ids");
    String[] provPrecios = request.getParameterValues("prov_precios");

    if (itemCodiStr != null) {
        try {
            int itemCodi = Integer.parseInt(itemCodiStr);
            ItemController ic = new ItemController();

            // Llamamos al método que acabamos de crear
            boolean ok = ic.actualizarRelacionProveedores(itemCodi, provIds, provPrecios);

            if (ok) {
                // Redirigimos a la lista o al detalle con éxito
                response.sendRedirect("compras.jsp?msg=update_ok");
            } else {
                out.println("<h3>Error al guardar los cambios en la base de datos.</h3>");
            }
        } catch (Exception e) {
            out.println("<h3>Error en el proceso: " + e.getMessage() + "</h3>");
        }
    } else {
        out.println("<h3>Error: No se recibió el código del componente.</h3>");
    }
%>