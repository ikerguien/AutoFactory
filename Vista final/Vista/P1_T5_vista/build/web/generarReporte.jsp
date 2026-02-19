<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page contentType="application/pdf" %> <%-- Esto le dice al navegador: "Soy un PDF" --%>

<%
    Connection conn = null;
    try {
        // 1. Datos de tu conexión (Igual que en tus otros controladores)
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/TU_BASE_DE_DATOS", "root", "tu_password");

        // 2. Ruta de tu archivo .jasper (Asegúrate de que la carpeta y el nombre coincidan)
        String rutaJasper = application.getRealPath("/reportes/mi_reporte.jasper");
        
        // 3. Parámetros
        Map<String, Object> parametros = new HashMap<>();
        String idParam = request.getParameter("codigo"); // Lo pillamos de la URL
        if (idParam != null) {
            parametros.put("ID_ITEM", Integer.parseInt(idParam));
        }

        // 4. Generar el reporte
        // Usamos JasperRunManager para obtener los bytes del PDF
        byte[] pdfBytes = JasperRunManager.runReportToPdf(rutaJasper, parametros, conn);

        // 5. Enviar el PDF al navegador
        response.setContentType("application/pdf");
        response.setContentLength(pdfBytes.length);
        
        ServletOutputStream outStream = response.getOutputStream();
        outStream.write(pdfBytes, 0, pdfBytes.length);
        outStream.flush();
        outStream.close();
        
        // Importante para que no intente escribir nada más en el JSP
        out.clear();
        out = pageContext.pushBody();

    } catch (Exception e) {
        e.printStackTrace();
        response.setContentType("text/html");
        out.println("Error al generar el reporte: " + e.getMessage());
    } finally {
        if (conn != null) conn.close();
    }
%>