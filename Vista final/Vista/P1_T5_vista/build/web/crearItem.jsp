<%@ page import="controller.ItemController" %>
<%@ page import="java.util.List" %>
<%@ page import="P1_T4_Model.Item" %>
<%@ page import="P1_T4_Model.Component" %>
<%@ page import="P1_T4_Model.Producte" %>
<%@ page import="P1_T4_Model.UnitatMesura" %>
<%@ page import="P1_T4_Model.Proveidor" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Item</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        /* Sincronización con welcome.jsp */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            height: 100vh;
            background-color: #f4f4f4;
        }

        .container {
            display: flex;
            width: 100%;
            height: 100%;
        }

        /* Barra lateral (Idéntica a welcome) */
        .sidebar {
            width: 250px;
            background-color: #2c3e50;
            color: white;
            padding: 20px;
            box-sizing: border-box;
            flex-shrink: 0; /* Evita que se encoja */
        }

        .sidebar-menu { margin-top: 30px; }
        .sidebar-menu h2 { color: #ecf0f1; text-align: center; margin-bottom: 20px; }
        .sidebar-menu ul { list-style-type: none; padding: 0; }
        .sidebar-menu ul li { margin: 10px 0; padding: 10px; background-color: #34495e; border-radius: 5px; }
        .sidebar-menu ul li a { color: white; text-decoration: none; display: block; text-align: center; }
        .sidebar-menu ul li:hover { background-color: #1abc9c; }

        /* Contenido principal */
        .content {
            flex-grow: 1; /* Ocupa el resto de la pantalla */
            padding: 40px;
            overflow-y: auto;
            background-color: white;
        }

        /* Ajuste del formulario para que no sea gigante */
        .form-wrapper {
            max-width: 800px;
            margin: 0 auto;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        h1 { text-align: center; color: #34495e; }
        label { display: block; margin-top: 10px; font-weight: bold; color: #34495e; }
        input[type="text"], input[type="number"], select {
            width: 100%; padding: 10px; margin: 5px 0 15px 0;
            border-radius: 5px; border: 1px solid #ccc; box-sizing: border-box;
        }

        .btn-save { background-color: #2ecc71; color: white; font-weight: bold; width: 100%; border: none; padding: 15px; cursor: pointer; border-radius: 5px; }
        .btn-logout { background-color: #e74c3c; color: white; border: none; padding: 10px; cursor: pointer; width: 100%; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo Aplicación" style="width: 150px; height: auto;">
            <form action="login.jsp" method="POST">
                <button type="submit" class="btn-logout">➜]</button>
            </form>
            <div class="sidebar-menu">
                <h2>Menú</h2>
                <ul>
                    <li><a href="welcome.jsp">Inici</a></li>
                    <li><a href="crearItem.jsp">Crear Item</a></li>
                    <li><a href="proveidors.jsp">Proveidors</a></li>
                    <li><a href="compras.jsp">Compres</a></li>
                </ul>
            </div>
        </div>

        <div class="content">
            <div class="form-wrapper">
                <h1>Crear Nuevo Item</h1>
                <form action="guardarItem.jsp" method="POST">
                    <label for="tipo">Tipo de Item:</label>
                    <select id="tipo" name="tipo" onchange="mostrarCampos()" required>
                        <option value="">Seleccione...</option>
                        <option value="P">Producto</option>
                        <option value="C">Componente</option>
                    </select>

                    <label for="nombre">Nombre:</label>
                    <input type="text" id="nombre" name="nombre" required>

                    <label for="descripcion">Descripción:</label>
                    <input type="text" id="descripcion" name="descripcion" required>
                    
                    <label for="foto">Foto del Item (Opcional):</label>
                    <input type="file" id="fotoInput" accept="image/*" style="width: 100%; padding: 10px; margin-bottom: 15px;" onchange="convertirFoto()">
                    <input type="hidden" name="fotoBase64" id="fotoBase64">

                    <label for="stock">Stock:</label>
                    <input type="number" id="stock" name="stock" required>

                    <div id="productoFields" style="display:none; border: 1px dashed #3498db; padding: 20px; margin-bottom: 20px; border-radius: 8px;">
                        <h3>Configuración de Producto</h3>
                        <label>Seleccionar Subproducto:</label>
                        <div style="display: flex; gap: 10px; margin-bottom: 10px;">
                            <select id="id_select_sub" style="margin-bottom:0;">
                                <option value="">-- Selecciona --</option>
                                <% 
                                    ItemController controller = new ItemController();
                                    List<Item> subproductos = controller.obtenerSubproductos();
                                    for (Item s : subproductos) { 
                                %>
                                    <option value="<%= s.getItCodi() %>"><%= s.getItNom() %></option>
                                <% } %>
                            </select>
                            <input type="number" id="id_cantidad_sub" value="1" min="1" style="width: 80px; margin-bottom:0;">
                            <button type="button" onclick="agregarSubproductoALista()" style="background:#1abc9c; color:white; border:none; padding:10px; border-radius:5px; cursor:pointer;">+ Agregar</button>
                        </div>
                        <div id="lista_visual" style="background: white; border: 1px solid #ddd; padding: 10px; border-radius: 5px;">
                            <strong>Subproductos añadidos:</strong>
                        </div>
                    </div>

                    <div id="componenteFields" style="display:none; border: 1px dashed #e67e22; padding: 20px; margin-bottom: 20px; border-radius: 8px;">
                        <h3>Configuración de Componente</h3>
                        <label for="cmCodiFabricant">Código de Fabricante:</label>
                        <input type="text" id="cmCodiFabricant" name="cmCodiFabricant">

                        <label for="cmPreuMig">Precio de Compra (€):</label>
                        <input type="number" id="cmPreuMig" name="cmPreuMig" step="0.01">

                        <label for="cmUmCodi">Unidad de Medida:</label>
                        <select id="cmUmCodi" name="cmUmCodi">
                            <option value="">-- Seleccione --</option>
                            <% for (UnitatMesura u : controller.obtenerUnidades()) { %>
                                <option value="<%= u.getCodiMesura() %>"><%= u.getNom() %></option>
                            <% } %>
                        </select>

                        <label for="proveedor">Proveedor Principal:</label>
                        <select id="proveedor" name="proveedor">
                            <option value="">-- Seleccione --</option>
                            <% for (Proveidor p : controller.obtenerProveedores()) { %>
                                <option value="<%= p.getPvCodi() %>"><%= p.getPvRaoSocial() %></option>
                            <% } %>
                        </select>
                    </div>

                    <button type="submit" class="btn-save">GUARDAR ITEM COMPLETO</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        function mostrarCampos() {
            const tipo = document.getElementById('tipo').value;
            document.getElementById('productoFields').style.display = (tipo === 'P') ? 'block' : 'none';
            document.getElementById('componenteFields').style.display = (tipo === 'C') ? 'block' : 'none';
        }

        function agregarSubproductoALista() {
            var combo = document.getElementById("id_select_sub");
            var inputCant = document.getElementById("id_cantidad_sub");
            var contenedor = document.getElementById("lista_visual");

            var id = combo.value;
            var nombre = combo.options[combo.selectedIndex].text;
            var cantidad = inputCant.value;

            if (id === "" || cantidad <= 0) {
                alert("Selecciona un producto y cantidad válida");
                return;
            }

            var nuevaFila = document.createElement("div");
            nuevaFila.style.cssText = "display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid #eee; padding:5px 0;";
            nuevaFila.innerHTML = 
                '<span>' + nombre + ' (x' + cantidad + ')</span>' +
                '<input type="hidden" name="subproductos_ids" value="' + id + '">' +
                '<input type="hidden" name="subproductos_cants" value="' + cantidad + '">' +
                '<button type="button" onclick="this.parentElement.remove()" style="color:red; background:none; border:none; cursor:pointer;">Eliminar</button>';
            
            contenedor.appendChild(nuevaFila);
        }

        // FUNCIÓN PARA CONVERTIR IMAGEN A TEXTO ANTES DE ENVIAR
        function convertirFoto() {
            var file = document.getElementById('fotoInput').files[0];
            var reader = new FileReader();
            reader.onloadend = function() {
                document.getElementById('fotoBase64').value = reader.result;
            }
            if (file) {
                reader.readAsDataURL(file);
            }
        }
    </script>
</body>
</html>