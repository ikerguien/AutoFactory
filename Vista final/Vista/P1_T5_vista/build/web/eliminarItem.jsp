<%@ page import="controller.ItemController" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String codigoStr = request.getParameter("codigo");

    if (codigoStr != null) {
        try {
            int codigo = Integer.parseInt(codigoStr);
            ItemController controller = new ItemController();
            
            // ASEGÚRATE que en ItemController el método sea: public int eliminarItem(int id)
            int resultado = controller.eliminarItem(codigo);
            
            if (resultado == 1) {
                // Borrado exitoso
                response.sendRedirect("welcome.jsp");
            } else if (resultado == -1) {
                // Caso de dependencia (FK)
                out.println("<script>alert('No se puede eliminar: el item es parte de otro producto.'); window.location='welcome.jsp';</script>");
            } else {
                // Caso 0 u otros errores
                out.println("<script>alert('No se pudo eliminar el item.'); window.location='welcome.jsp';</script>");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("welcome.jsp");
        } catch (Exception e) {
            out.println("Error grave: " + e.getMessage());
        }
    } else {
        response.sendRedirect("welcome.jsp");
    }
%>