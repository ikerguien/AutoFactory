<%@ page import="controller.ItemController" %>
<%@ page import="P1_T4_Model.Item" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="P1_T4_Model.Component" %>

<%
    String codigoStr = request.getParameter("codigo");
    if(codigoStr == null){
        out.println("No se recibió el código del item");
        return;
    }
    int codigo = Integer.parseInt(codigoStr);

    ItemController itemController = new ItemController();
    
    // 1. Obtenemos el item base
    Item item = itemController.obtenerItemPorId(codigo);

    // 2. Si es un componente, cargamos sus precios de proveedores
    if ("C".equalsIgnoreCase(item.getItTipus())) {
        P1_T4_Model.Component comp = itemController.obtenerDetalleComponenteCompleto(codigo);
        if (comp != null) item = comp; 
    }

    // Subitems para productos
    List<Item> subitemsActuales = null;
    if("P".equalsIgnoreCase(item.getItTipus())){
        subitemsActuales = itemController.obtenerItemsDelProducto(codigo);
    }

    List<Item> todosItems = itemController.obtenerSubproductos(); 
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Editar Item - Dinámico</title>
        <style>
            body{
                font-family: Arial,sans-serif;
                background:#f4f6f9;
                padding:20px;
            }
            .form-box{
                width:700px;
                margin:auto;
                background:white;
                padding:25px;
                border-radius:12px;
                box-shadow:0 4px 10px rgba(0,0,0,.15);
            }
            h2{
                text-align:center;
                color: #2c3e50;
            }
            label{
                font-weight:bold;
                display:block;
                margin-top:15px;
            }
            input, select{
                width:100%;
                padding:10px;
                margin-top:5px;
                border-radius:6px;
                border:1px solid #ccc;
                box-sizing: border-box;
            }
            .img-container{
                text-align: center;
                margin: 15px 0;
                padding: 10px;
                border: 1px dashed #bbb;
                border-radius: 8px;
            }
            .preview-img{
                max-width: 120px;
                border-radius: 5px;
            }

            /* Estilos para la lista dinámica */
            .config-box {
                border: 1px dashed #3498db;
                padding: 20px;
                margin-top: 20px;
                border-radius: 8px;
                background: #ebf5fb;
            }
            .lista-visual {
                background: white;
                border: 1px solid #ddd;
                padding: 10px;
                border-radius: 5px;
                margin-top: 10px;
            }
            .fila-item {
                display:flex;
                justify-content:space-between;
                align-items:center;
                border-bottom:1px solid #eee;
                padding:8px 0;
            }
            .btn-add {
                background:#1abc9c;
                color:white;
                border:none;
                padding:10px;
                border-radius:5px;
                cursor:pointer;
                font-weight: bold;
            }
            .btn-save {
                background:#2ecc71;
                color:white;
                border:none;
                padding:15px;
                width:100%;
                border-radius:6px;
                cursor:pointer;
                font-weight:bold;
                margin-top:20px;
                font-size: 16px;
            }
            .btn-del {
                color:#e74c3c;
                background:none;
                border:none;
                cursor:pointer;
                font-weight:bold;
            }
        </style>
    </head>
    <body>

        <div class="form-box">
            <h2>Editar: <%= item.getItNom() %></h2>

            <form action="guardarItem.jsp" method="post">
                <input type="hidden" name="id" value="<%= item.getItCodi() %>">
                <input type="hidden" name="tipo" value="<%= item.getItTipus() %>">

                <label>Nombre del Item</label>
                <input type="text" name="nombre" value="<%= item.getItNom() %>" required>

                <label>Descripción</label>
                <input type="text" name="descripcion" value="<%= item.getItDescripio() %>" required>

                <label>Stock Actual</label>
                <input type="number" name="stock" value="<%= item.getItStock() %>" required>

                <label>Imagen Actual</label>
                <div class="img-container">
                    <% if (item.getItFoto() != null && item.getItFoto().length > 0) {
                String base64Image = Base64.getEncoder().encodeToString(item.getItFoto()); %>
                    <img src="data:image/png;base64,<%= base64Image %>" class="preview-img">
                    <% } else { %>
                    <p style="color: #777;">Sin imagen</p>
                    <% } %>
                </div>

                <label>Cambiar imagen (opcional)</label>
                <input type="file" id="fotoInput" accept="image/*" onchange="convertirFoto()">
                <input type="hidden" name="fotoBase64" id="fotoBase64">

                <%-- SECCIÓN DINÁMICA DE SUBITEMS (Solo si es Producto) --%>
                <% if("P".equalsIgnoreCase(item.getItTipus())){ %>
                <div class="config-box">
                    <h3>Composición del Producto</h3>

                    <div style="display: flex; gap: 10px;">
                        <select id="id_select_sub">
                            <option value="">-- Selecciona Item para añadir --</option>
                            <% for (Item t : todosItems) { 
                            if(t.getItCodi() != item.getItCodi()) { %>
                            <option value="<%= t.getItCodi() %>"><%= t.getItNom() %> (<%= t.getItTipus() %>)</option>
                            <% } } %>
                        </select>
                        <input type="number" id="id_cantidad_sub" value="1" min="1" style="width: 80px;">
                        <button type="button" class="btn-add" onclick="agregarSubproductoALista()">+ Añadir</button>
                    </div>

                    <div id="lista_visual" class="lista-visual">
                        <strong>Ítems que componen este producto:</strong>
                        <%-- Cargamos los subitems que ya existen en la base de datos --%>
                        <% if(subitemsActuales != null) {
                        for(Item s : subitemsActuales) { %>
                        <div class="fila-item">
                            <span><%= s.getItNom() %> (x<%= s.getCantidad() %>)</span>
                            <input type="hidden" name="subproductos_ids" value="<%= s.getItCodi() %>">
                            <input type="hidden" name="subproductos_cants" value="<%= s.getCantidad() %>">
                            <button type="button" class="btn-del" onclick="this.parentElement.remove()">Eliminar</button>
                        </div>
                        <% } } %>
                    </div>
                </div>
                <% } %>
                <%-- SECCIÓN DINÁMICA DE PRECIOS (Solo si es Componente) --%>
                <%-- SECCIÓN DINÁMICA DE PRECIOS (Solo si es Componente) --%>
                <% if("C".equalsIgnoreCase(item.getItTipus())){ 
                    P1_T4_Model.Component c = (P1_T4_Model.Component) item;
                %>
                <div class="config-box" style="border-color: #e67e22; background: #fef9f3;">
                    <h3 style="color: #d35400;">Precios y Proveedores (Reparto)</h3>

                    <div style="display: flex; gap: 10px; margin-bottom: 15px;">
                        <input type="text" id="nuevo_prov_nombre" placeholder="Nombre Empresa Reparto/Proveedor" style="flex: 2;">
                        <input type="number" id="nuevo_prov_precio" step="0.01" placeholder="Precio €" style="flex: 1;">
                        <button type="button" class="btn-add" style="background:#e67e22;" onclick="agregarPrecioProveedor()">+ Añadir</button>
                    </div>

                    <div id="lista_precios" class="lista-visual">
                        <strong>Empresas y Precios actuales:</strong>
                        <% 
                        if (c.getCompra() != null && !c.getCompra().isEmpty()) {
                            for (java.util.Map.Entry<P1_T4_Model.Proveidor, java.math.BigDecimal> entry : c.getCompra().entrySet()) { %>
                        <div class="fila-item">
                            <span><strong><%= entry.getKey().getPvRaoSocial() %></strong></span>
                            <div style="display: flex; align-items: center; gap: 5px;">
                                <input type="hidden" name="prov_ids" value="<%= entry.getKey().getPvCodi() %>">
                                <input type="number" name="prov_precios" value="<%= entry.getValue() %>" 
                                       step="0.01" style="width: 100px; text-align: right;">
                                <strong>€</strong>
                                <button type="button" class="btn-del" onclick="this.parentElement.parentElement.remove()">×</button>
                            </div>
                        </div>
                        <% } 
            } %>
                    </div>
                </div>
                <% } %>

                <button type="submit" class="btn-save">GUARDAR TODOS LOS CAMBIOS</button>
            </form>
        </div>

        <script>
            function agregarSubproductoALista() {
                var combo = document.getElementById("id_select_sub");
                var inputCant = document.getElementById("id_cantidad_sub");
                var contenedor = document.getElementById("lista_visual");

                var id = combo.value;
                var nombre = combo.options[combo.selectedIndex].text;
                var cantidad = inputCant.value;

                if (id === "" || cantidad <= 0) {
                    alert("Selecciona un item y cantidad válida");
                    return;
                }

                var nuevaFila = document.createElement("div");
                nuevaFila.className = "fila-item";
                nuevaFila.innerHTML =
                        '<span>' + nombre + ' (x' + cantidad + ')</span>' +
                        '<input type="hidden" name="subproductos_ids" value="' + id + '">' +
                        '<input type="hidden" name="subproductos_cants" value="' + cantidad + '">' +
                        '<button type="button" class="btn-del" onclick="this.parentElement.remove()">Eliminar</button>';

                contenedor.appendChild(nuevaFila);
            }

            function convertirFoto() {
                var file = document.getElementById('fotoInput').files[0];
                var reader = new FileReader();
                reader.onloadend = function () {
                    document.getElementById('fotoBase64').value = reader.result;
                }
                if (file) {
                    reader.readAsDataURL(file);
                }
            }

            function agregarPrecioProveedor() {
                var nombre = document.getElementById("nuevo_prov_nombre").value;
                var precio = document.getElementById("nuevo_prov_precio").value;
                var contenedor = document.getElementById("lista_precios");

                if (nombre === "" || precio === "") {
                    alert("Introduce el nombre de la empresa y el precio");
                    return;
                }

                var nuevaFila = document.createElement("div");
                nuevaFila.className = "fila-item";
                nuevaFila.innerHTML =
                        '<span><strong>' + nombre + '</strong></span>' +
                        '<div style="display: flex; align-items: center; gap: 5px;">' +
                        '<input type="hidden" name="prov_nombres_nuevos" value="' + nombre + '">' +
                        '<input type="number" name="prov_precios" value="' + precio + '" step="0.01" style="width: 100px; text-align: right;">' +
                        '<strong>€</strong>' +
                        '<button type="button" class="btn-del" onclick="this.parentElement.parentElement.remove()">×</button>' +
                        '</div>';

                contenedor.appendChild(nuevaFila);

                // Limpiar campos
                document.getElementById("nuevo_prov_nombre").value = "";
                document.getElementById("nuevo_prov_precio").value = "";
            }
        </script>

    </body>
</html>