<%@ page import="controller.ItemController" %>
<%@ page import="java.util.List" %>
<%@ page import="p1.t4.model.Item" %>
<%@ page import="p1.t4.model.UnitatMesura" %>
<%@ page import="p1.t4.model.Proveidor" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("usuari") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    ItemController controller = new ItemController();
    List<Item> subproductos = controller.obtenerSubproductos();
    List<UnitatMesura> unitats = controller.obtenerUnidades();
    List<Proveidor> proveidors = controller.obtenerProveedores();
%>
<!DOCTYPE html>
<html lang="ca">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AutoFactory — Crear Item</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
<div class="container">
    <div class="sidebar">
        <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo">
        <form action="login.jsp" method="POST">
            <button type="submit" class="btn-logout">➜ Logout</button>
        </form>
        <div class="sidebar-menu">
            <h2>Menú</h2>
            <ul>
                <li><a href="welcome.jsp">🏠 Inici</a></li>
                <li><a href="crearItem.jsp">➕ Crear Item</a></li>
                <li><a href="proveidors.jsp">🏭 Proveïdors</a></li>
                <li><a href="arbre.jsp">🌳 Vista en Arbre</a></li>
            </ul>
        </div>
    </div>

    <div class="content">
        <div class="form-wrapper">
            <h1>➕ Crear Nou Item</h1>

            <form action="guardarItem.jsp" method="POST" id="formCrear" onsubmit="return validarFormulari()">

                <label for="tipo">Tipus d'Item: *</label>
                <select id="tipo" name="tipo" onchange="mostrarCampos()" required>
                    <option value="">-- Selecciona el tipus --</option>
                    <option value="P">📦 Producte</option>
                    <option value="C">🔧 Component</option>
                </select>

                <label for="nombre">Nom: *</label>
                <input type="text" id="nombre" name="nombre" required maxlength="30"
                       placeholder="Nom de l'item">

                <label for="descripcion">Descripció: *</label>
                <input type="text" id="descripcion" name="descripcion" required maxlength="50"
                       placeholder="Descripció breu de l'item">

                <label for="fotoInput">Foto (opcional):</label>
                <input type="file" id="fotoInput" accept="image/*" onchange="convertirFoto()">
                <input type="hidden" name="fotoBase64" id="fotoBase64">

                <label for="stock">Stock: *</label>
                <input type="number" id="stock" name="stock" required min="0" value="0">

                <%-- Secció PRODUCTE --%>
                <div id="productoFields" class="section-producte" style="display:none;">
                    <h3>⚙️ Composició del Producte (BOM)</h3>
                    <div style="display:flex; gap:10px; margin:10px 0; align-items:flex-end;">
                        <div style="flex:2;">
                            <label>Seleccionar subitem:</label>
                            <select id="id_select_sub">
                                <option value="">-- Selecciona un item --</option>
                                <% for (Item s : subproductos) { %>
                                <option value="<%= s.getItCodi() %>">
                                    <%= s.getItNom() %>
                                    (<%= "P".equals(s.getItTipus()) ? "Producte" : "Component" %>)
                                </option>
                                <% } %>
                            </select>
                        </div>
                        <div style="width:90px;">
                            <label>Quantitat:</label>
                            <input type="number" id="id_cantidad_sub" value="1" min="1">
                        </div>
                        <button type="button" class="btn-success"
                                onclick="agregarSubproductoALista()"
                                style="height:40px;">+ Afegir</button>
                    </div>
                    <div id="lista_visual" class="lista-visual">
                        <strong>Subitems afegits:</strong>
                        <p id="msg_buit" style="color:#aaa; font-size:0.9em;">
                            Encara no has afegit cap subitem.
                        </p>
                    </div>
                </div>

                <%-- Secció COMPONENT --%>
                <div id="componenteFields" class="section-component" style="display:none;">
                    <h3>🔧 Configuració del Component</h3>

                    <label for="cmCodiFabricant">Codi Fabricant: *</label>
                    <input type="text" id="cmCodiFabricant" name="cmCodiFabricant"
                           maxlength="20" placeholder="Codi del fabricant">

                    <label for="cmUmCodi">Unitat de Mesura:</label>
                    <select id="cmUmCodi" name="cmUmCodi">
                        <option value="">-- Selecciona --</option>
                        <% for (UnitatMesura u : unitats) { %>
                        <option value="<%= u.getCodiMesura() %>"><%= u.getNom() %></option>
                        <% } %>
                    </select>

                    <label for="proveedor">Proveïdor Principal:</label>
                    <select id="proveedor" name="proveedor">
                        <option value="">-- Selecciona --</option>
                        <% for (Proveidor p : proveidors) { %>
                        <option value="<%= p.getPvCodi() %>"><%= p.getPvRaoSocial() %></option>
                        <% } %>
                    </select>

                    <label for="cmPreuMig">Preu de Compra (€):</label>
                    <input type="number" id="cmPreuMig" name="cmPreuMig"
                           step="0.01" min="0" value="0.00">
                </div>

                <button type="submit" class="btn-save">💾 GUARDAR ITEM</button>
            </form>
        </div>
    </div>
</div>

<script>
    function mostrarCampos() {
        var tipo = document.getElementById('tipo').value;
        document.getElementById('productoFields').style.display = (tipo === 'P') ? 'block' : 'none';
        document.getElementById('componenteFields').style.display = (tipo === 'C') ? 'block' : 'none';
    }

    function validarFormulari() {
        var tipo = document.getElementById('tipo').value;
        var nombre = document.getElementById('nombre').value.trim();
        var stock = document.getElementById('stock').value;

        if (!tipo) { alert("Selecciona el tipus d'item."); return false; }
        if (!nombre) { alert("El nom és obligatori."); return false; }
        if (stock === '' || parseInt(stock) < 0) { alert("El stock ha de ser positiu o zero."); return false; }
        if (tipo === 'C') {
            var codiFab = document.getElementById('cmCodiFabricant').value.trim();
            if (!codiFab) { alert("El codi de fabricant és obligatori per als components."); return false; }
        }
        return true;
    }

    function agregarSubproductoALista() {
        var combo = document.getElementById("id_select_sub");
        var inputCant = document.getElementById("id_cantidad_sub");
        var contenedor = document.getElementById("lista_visual");
        var msgBuit = document.getElementById("msg_buit");

        var id = combo.value;
        var nombre = combo.options[combo.selectedIndex].text;
        var cantidad = parseInt(inputCant.value);

        if (!id) { alert("Selecciona un item de la llista."); return; }
        if (isNaN(cantidad) || cantidad <= 0) { alert("La quantitat ha de ser positiva."); return; }

        // ===== COMPROVACIÓ DE DUPLICAT =====
        var existents = document.querySelectorAll('.fila-subitem input[type="hidden"][name="subitem_id[]"]');
        for (var i = 0; i < existents.length; i++) {
            if (existents[i].value === id) {
                // Si ja existeix, sumem la quantitat
                var fila = existents[i].parentElement;
                var inputCantExistent = fila.querySelector('input[name="subitem_cantidad[]"]');
                var cantActual = parseInt(inputCantExistent.value);
                var novaCant = cantActual + cantidad;
                inputCantExistent.value = novaCant;
                // Actualitzem el text visible
                var span = fila.querySelector('span');
                var nomBase = span.textContent.split(' — ')[0];
                span.innerHTML = nomBase + ' — <strong>x' + novaCant + '</strong>';
                combo.value = "";
                inputCant.value = 1;
                return;
            }
        }

        if (msgBuit) msgBuit.style.display = 'none';

        var nuevaFila = document.createElement("div");
        nuevaFila.className = "fila-subitem";
        nuevaFila.innerHTML =
            '<span>📦 ' + nombre + ' — <strong>x' + cantidad + '</strong></span>' +
            '<input type="hidden" name="subitem_id[]" value="' + id + '">' +
            '<input type="hidden" name="subitem_cantidad[]" value="' + cantidad + '">' +
            '<button type="button" class="btn-eliminar-sub" ' +
            'onclick="this.parentElement.remove(); comprovarBuit()">✕</button>';

        contenedor.appendChild(nuevaFila);
        combo.value = "";
        inputCant.value = 1;
    }
    function comprovarBuit() {
        var files = document.querySelectorAll('.fila-subitem');
        var msgBuit = document.getElementById('msg_buit');
        if (files.length === 0 && msgBuit) msgBuit.style.display = 'block';
    }

    function convertirFoto() {
        var file = document.getElementById('fotoInput').files[0];
        if (!file) return;
        var reader = new FileReader();
        reader.onloadend = function() {
            document.getElementById('fotoBase64').value = reader.result;
        };
        reader.readAsDataURL(file);
    }
</script>
</body>
</html>