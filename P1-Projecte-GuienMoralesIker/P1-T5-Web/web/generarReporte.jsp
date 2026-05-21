<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.type.WhenNoDataTypeEnum" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="p1.t4.dao.Connexio" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    if (session.getAttribute("usuari") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    String checkpoint = "Inicio";
    try {
        // 0. Capturem el codi del producte
        // Acceptem tant "codigo" (el que envia el botó) com "id" (compatibilitat)
        String idParam = request.getParameter("codigo");
        if (idParam == null || idParam.trim().isEmpty()) {
            idParam = request.getParameter("id");
        }
        if (idParam == null || idParam.trim().isEmpty()) {
            idParam = "20000"; // Valor per defecte per proves
        }

        // 1. Connexió a Oracle
        checkpoint = "Connectant a Oracle";
        conn = Connexio.getConnection();
        if (conn == null) throw new Exception("La connexió amb la base de dades ha fallat.");

        // 2. Ruta del fitxer JRXML
        checkpoint = "Localitzant arxiu JRXML";
        String rutaJrxml = getServletContext().getRealPath("/reportes/ReportFicha.jrxml");
        if (rutaJrxml == null) {
            throw new Exception("getRealPath retorna null. Comprova que GlassFish té accés al directori de desplegament.");
        }
        File f = new File(rutaJrxml);
        if (!f.exists()) throw new Exception("No es troba l'arxiu en: " + rutaJrxml);
        // 3. Compilar el JRXML
        checkpoint = "Compilant reporte";
        JasperReport jasperReport = JasperCompileManager.compileReport(rutaJrxml);
        jasperReport.setWhenNoDataType(WhenNoDataTypeEnum.ALL_SECTIONS_NO_DETAIL);

        // 4. Paràmetres
        checkpoint = "Configurant paràmetres amb ID: " + idParam;
        Map<String, Object> parametros = new HashMap<>();
        parametros.put("ID_PRODUCTO_PADRE", new java.math.BigDecimal(idParam));

        // 5. Omplir el reporte
        checkpoint = "Omplint reporte (executant SQL)";
        JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parametros, conn);

        // 6. Generar PDF
        checkpoint = "Generant bytes del PDF";
        byte[] pdfBytes = JasperExportManager.exportReportToPdf(jasperPrint);

        // 7. Enviar al navegador
        checkpoint = "Enviant PDF al client";
        response.reset();
        response.setContentType("application/pdf");
        response.setContentLength(pdfBytes.length);
        response.setHeader("Content-Disposition", "inline; filename=reporte_" + idParam + ".pdf");

        ServletOutputStream outStream = response.getOutputStream();
        outStream.write(pdfBytes);
        outStream.flush();
        outStream.close();

        out.clear();
        out = pageContext.pushBody();

    } catch (Exception e) {
        response.setContentType("text/html;charset=UTF-8");
        out.println("<html><body style='font-family:Arial; padding:20px;'>");
        out.println("<h2 style='color:red;'>❌ Error en el pas: " + checkpoint + "</h2>");
        out.println("<pre style='background:#fdecea; padding:15px; border-radius:5px;'>");
        e.printStackTrace(new java.io.PrintWriter(out));
        out.println("</pre>");
        out.println("<a href='welcome.jsp' style='background:#3498db; color:white; padding:10px 20px; border-radius:5px; text-decoration:none;'>← Tornar</a>");
        out.println("</body></html>");
    } finally {
        if (conn != null) {
            try { Connexio.closeConnection(conn); } catch (Exception ignored) {}
        }
    }
%>