<%@ page import="controller.ItemController" %>
<%@ page import="P1_T4_Model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String codStr = request.getParameter("codigo");
    if (codStr == null || codStr.isEmpty()) { 
        response.sendRedirect("lista.jsp"); 
        return; 
    }

    int codigo = Integer.parseInt(codStr);
    ItemController ic = new ItemController();
    
    // Obtenemos el componente (Esto ya carga el HashMap 'compra')
    Component comp = ic.obtenerDetalleComponenteCompleto(codigo);

    if (comp == null) {
        out.println("<h3>Error: El ID " + codigo + " no es un componente válido.</h3>");
        return;
    }
    
    // IMPORTANTE: Usamos el método que ya existe en tu ItemController
    List<Proveidor> todosProv = ic.obtenerProveedores(); 
%>

<!DOCTYPE html>
<html>
<head>
    <title>Editar Precios: <%= comp.getItNom() %></title>
    <style>
        body { font-family: sans-serif; padding: 20px; background: #f4f6f9; }
        .card { background: white; max-width: 800px; margin: auto; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { border-bottom: 2px solid #f39c12; padding-bottom: 10px; color: #2c3e50; }
        
        /* Estilos de Tabla */
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { padding: 12px; border-bottom: 1px solid #ddd; text-align: left; }
        th { background: #2c3e50; color: white; }
        tr:hover { background-color: #f1f1f1; }
        
        /* Inputs y Botones */
        .input-precio { width: 90px; padding: 6px; text-align: right; border: 1px solid #ccc; border-radius: 4px; }
        .btn-del { background: #e74c3c; color: white; border: none; padding: 6px 12px; cursor: pointer; border-radius: 4px; font-weight: bold; }
        .btn-del:hover { background: #c0392b; }
        
        .add-section { background: #ecf0f1; padding: 15px; margin-top: 20px; border-radius: 5px; display: flex; gap: 10px; align-items: center; border: 1px solid #bdc3c7; }
        .btn-add-row { background: #27ae60; color: white; border: none; padding: 8px 15px; cursor: pointer; border-radius: 4px; font-weight: bold; }
        
        .btn-save { background: #3498db; color: white; border: none; padding: 15px; width: 100%; cursor: pointer; margin-top: 20px; font-size: 16px; border-radius: 5px; font-weight: bold; transition: background 0.3s; }
        .btn-save:hover { background: #2980b9; }
        
        select { padding: 8px; border-radius: 4px; border: 1px solid #ccc; }
    </style>
</head>
<body>

<div class="card">
    <a href="lista.jsp" style="text-decoration:none; color:#7f8c8d;">← Volver al listado</a>
    <h2>Gestionar Proveedores: <%= comp.getItNom() %></h2>
    <p><strong>Stock actual:</strong> <%= comp.getItStock() %> unidades</p>
    
    <form action="actualizarPrecios.jsp" method="post">
        <input type="hidden" name="itemCodi" value="<%= comp.getItCodi() %>">

        <table id="tablaProveedores">
            <thead>
                <tr>
                    <th>Proveedor</th>
                    <th>Precio de Compra (€)</th>
                    <th style="width: 100px; text-align: center;">Acción</th>
                </tr>
            </thead>
            <tbody>
                <%-- BUCLE: Pintamos los proveedores que YA tiene asignados --%>
                <% 
                if (comp.getCompra() != null) {
                    for (Map.Entry<Proveidor, BigDecimal> entry : comp.getCompra().entrySet()) { 
                        Proveidor p = entry.getKey();
                %>
                <tr>
                    <td>
                        <%= p.getPvRaoSocial() %>
                        <input type="hidden" name="prov_ids" value="<%= p.getPvCodi() %>">
                    </td>
                    <td>
                        <input type="number" name="prov_precios" value="<%= entry.getValue() %>" step="0.01" class="input-precio" required> €
                    </td>
                    <td style="text-align: center;">
                        <button type="button" class="btn-del" onclick="borrarFila(this)">🗑️</button>
                    </td>
                </tr>
                <%  } } %>
            </tbody>
        </table>

        <%-- SECCIÓN PARA AÑADIR UNO NUEVO --%>
        <div class="add-section">
            <strong style="color: #2c3e50;">Añadir nuevo:</strong>
            <select id="new_prov_select" style="flex: 2;">
                <option value="">-- Selecciona Proveedor --</option>
                <% if(todosProv != null) { 
                    for(Proveidor p : todosProv) { %>
                    <option value="<%= p.getPvCodi() %>"><%= p.getPvRaoSocial() %></option>
                <% } } %>
            </select>
            <input type="number" id="new_prov_precio" placeholder="Precio €" step="0.01" style="width: 100px; padding: 8px;">
            <button type="button" class="btn-add-row" onclick="agregarNuevo()">+ Añadir a la lista</button>
        </div>

        <button type="submit" class="btn-save">💾 GUARDAR CAMBIOS</button>
    </form>
</div>

<script>
    // Función para borrar fila visualmente
    function borrarFila(btn) {
        var row = btn.parentNode.parentNode;
        row.parentNode.removeChild(row);
    }

    // Función para añadir fila desde el select a la tabla
    function agregarNuevo() {
        var select = document.getElementById("new_prov_select");
        var precioInput = document.getElementById("new_prov_precio");
        var tbody = document.querySelector("#tablaProveedores tbody");

        var provId = select.value;
        var provNombre = select.options[select.selectedIndex].text;
        var precio = precioInput.value;

        if(provId === "" || precio === "") {
            alert("Por favor, selecciona un proveedor y escribe un precio.");
            return;
        }

        // Creamos la nueva fila
        var nuevaFila = document.createElement("tr");
        nuevaFila.style.backgroundColor = "#e8f8f5"; // Un colorcito verde suave para indicar que es nuevo
        nuevaFila.innerHTML = 
            '<td>' + provNombre + '<input type="hidden" name="prov_ids" value="' + provId + '"></td>' +
            '<td><input type="number" name="prov_precios" value="' + precio + '" step="0.01" class="input-precio" required> €</td>' +
            '<td style="text-align: center;"><button type="button" class="btn-del" onclick="borrarFila(this)">🗑️</button></td>';
            
        tbody.appendChild(nuevaFila);

        // Limpiamos los campos de añadir
        select.value = "";
        precioInput.value = "";
    }
</script>

</body>
</html>