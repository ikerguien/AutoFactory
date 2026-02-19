<%@ page import="controller.ItemController" %>
<%@ page import="P1_T4_Model.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // 1. RECOGIDA DE DATOS BÁSICOS
    String idStr = request.getParameter("id"); 
    int idExistente = (idStr != null && !idStr.isEmpty()) ? Integer.parseInt(idStr) : 0;
    
    String tipo = request.getParameter("tipo");
    String nombre = request.getParameter("nombre");
    String descripcion = request.getParameter("descripcion");
    String stockStr = request.getParameter("stock");
    
    // TRATAMIENTO DE LA FOTO
    String fotoBase64 = request.getParameter("fotoBase64");
    byte[] fotoBytes = null;
    if (fotoBase64 != null && fotoBase64.contains(",")) {
        try {
            String base64Data = fotoBase64.split(",")[1];
            fotoBytes = Base64.getDecoder().decode(base64Data);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    int stock = (stockStr != null && !stockStr.isEmpty()) ? Integer.parseInt(stockStr) : 0;
    ItemController ctrl = new ItemController();
    int resultadoId = 0;

    // 2. PROCESAR SEGÚN TIPO
    if ("P".equals(tipo)) {
        Producte p = new Producte();
        p.setItCodi(idExistente);
        p.setItNom(nombre);
        p.setItDescripio(descripcion);
        p.setItStock(stock);
        p.setItTipus("P");
        p.setItFoto(fotoBytes);

        // --- CORRECCIÓN AQUÍ: Captura limpia de subproductos ---
        String[] ids = request.getParameterValues("subproductos_ids");
        String[] cants = request.getParameterValues("subproductos_cants");

        if (ids != null && cants != null) {
            for (int i = 0; i < ids.length; i++) {
                if (!ids[i].isEmpty()) {
                    Item itemHijo = new Item();
                    itemHijo.setItCodi(Integer.parseInt(ids[i]));
                    int cantidad = Integer.parseInt(cants[i]);
                    
                    // Debug en consola del servidor
                    System.out.println("DEBUG JSP: Añadiendo hijo ID " + ids[i] + " Cantidad: " + cantidad);
                    
                    p.addSubitem(itemHijo, cantidad);
                }
            }
        }

        if (idExistente > 0) {
            if(ctrl.actualizarItem(p) > 0) resultadoId = idExistente;
        } else {
            // Este es el método que llama a tu DAO Afegir con debug
            resultadoId = ctrl.agregarProducto(p);
        }

    } else if ("C".equals(tipo)) {
        Component c = new Component();
        c.setItCodi(idExistente);
        c.setItNom(nombre);
        c.setItDescripio(descripcion);
        c.setItStock(stock);
        c.setItTipus("C");
        c.setItFoto(fotoBytes);
        c.setCmCodiFabricant(request.getParameter("cmCodiFabricant"));
        
        String preuStr = request.getParameter("cmPreuMig");
        double precioNum = 0;
        if(preuStr != null && !preuStr.isEmpty()) {
            precioNum = Double.parseDouble(preuStr);
            c.setCmPreuMig(precioNum);
        }
        
        String umCodiStr = request.getParameter("cmUmCodi");
        if(umCodiStr != null && !umCodiStr.isEmpty()) {
            c.setCmUmCodi(Integer.parseInt(umCodiStr));
        }

        // --- NUEVA LÓGICA: Captura de precios por proveedor ---
        String[] provIds = request.getParameterValues("prov_ids");
        String[] provPrecios = request.getParameterValues("prov_precios");

        if (provIds != null && provPrecios != null) {
            HashMap<Proveidor, java.math.BigDecimal> mapaPrecios = new HashMap<>();
            for (int i = 0; i < provIds.length; i++) {
                if (!provIds[i].isEmpty()) {
                    Proveidor pProv = new Proveidor();
                    pProv.setPvCodi(Integer.parseInt(provIds[i]));
                    // Convertimos el precio del input a BigDecimal
                    java.math.BigDecimal precioBD = new java.math.BigDecimal(provPrecios[i]);
                    mapaPrecios.put(pProv, precioBD);
                }
            }
            c.setCompra(mapaPrecios); // Inyectamos el mapa en el objeto Componente
        }

        // --- GUARDADO ---
        if (idExistente > 0) {
            // actualizarItem ahora se encargará de borrar y reinsertar los precios
            if(ctrl.actualizarItem(c) > 0) resultadoId = idExistente;
        } else {
            resultadoId = ctrl.agregarComponente(c);
            
            // Si es nuevo y usaste el selector simple de proveedor de "Crear"
            String provIdSimple = request.getParameter("proveedor");
            if (resultadoId > 0 && provIdSimple != null && !provIdSimple.isEmpty()) {
                ctrl.vincularProveedor(resultadoId, Integer.parseInt(provIdSimple), precioNum);
            }
        }
    }

    // 3. RESPUESTA HTML
    if (resultadoId > 0) {
%>
<div style="text-align:center; margin-top:50px; font-family:Arial;">
    <h2 style="color: #27ae60;">✔ Item procesado con éxito</h2>
    <p>ID generado/actualizado: <strong><%= resultadoId %></strong></p>
    <a href="welcome.jsp" style="text-decoration:none; background:#3498db; color:white; padding:10px 20px; border-radius:5px;">Volver al inicio</a>
</div>
<%
    } else {
%>
<div style="text-align:center; margin-top:50px; font-family:Arial;">
    <h2 style="color: #c0392b;">✘ Error al procesar el Item</h2>
    <p>Consulta los logs de GlassFish para ver el error de SQL.</p>
    <a href="crearItem.jsp" style="text-decoration:none; background:#e67e22; color:white; padding:10px 20px; border-radius:5px;">Reintentar</a>
</div>
<%
    }
%>