package controller;

import P1_T4_DAO.DAO_Component;
import P1_T4_DAO.DAO_Item;
import P1_T4_DAO.DAO_Producte;
import P1_T4_DAO.DAO_Proveidor;
import P1_T4_DAO.DAO_UnitatMesura;
import P1_T4_Model.Component;
import P1_T4_Model.Item;
import P1_T4_Model.Producte;
import P1_T4_Model.Proveidor;
import P1_T4_Model.UnitatMesura;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ItemController {

    private DAO_Item daoItem;
    private DAO_Producte daoProducte;
    private DAO_Component daoComponent;
    private DAO_Proveidor daoProv;
    private DAO_UnitatMesura daoUM;

    public ItemController() {
        // Inicializamos los DAOs
        daoItem = new DAO_Item();
        daoProducte = new DAO_Producte();
        daoComponent = new DAO_Component();
        daoProv = new DAO_Proveidor();
        daoUM = new DAO_UnitatMesura();
    }

    // Método para obtener todos los items (productos o componentes) con filtro opcional
    public List<Item> obtenerItems(String tipo) {
        System.out.println("Tipo recibido en ItemController: '" + tipo + "'");
        List<Item> items;

        if (tipo != null && !tipo.isEmpty()) {
            items = daoItem.MostraPerTipus(tipo);  // Filtramos por tipo (componente o producto)
            System.out.println("Items filtrados: " + items.size());
        } else {
            items = daoItem.MostrarTots();  // Si no hay filtro, obtenemos todos
            System.out.println("Todos los items: " + items.size());
        }

        return items;
    }

    // Método para obtener todos los items sin filtro, útil para añadir subitems
    public List<Item> obtenerTodosItems() {
        return daoItem.MostrarTots();
    }

    // Obtener un item por su ID
    public Item obtenerItemPorId(int id) {
        return daoItem.MostraPerId(id);
    }

    // Actualizar item
public int actualizarItem(Item item) {
    // 1. Actualización básica en la tabla ITEM
    int rows = daoItem.Actualitzar(item);

    if (rows > 0) {
        // CASO A: Es un Producto
        if (item instanceof Producte) {
            Producte p = (Producte) item;
            daoItem.eliminarTodosSubitemsDeProducto(p.getItCodi());
            for (Map.Entry<Item, Integer> entry : p.getSubitems().entrySet()) {
                daoItem.agregarSubitemEnProducto(p.getItCodi(), entry.getKey().getItCodi(), entry.getValue());
            }
        } 
        // CASO B: Es un Componente (NUEVO)
        else if (item instanceof Component) {
            Component c = (Component) item;
            // Borramos precios antiguos para insertar los nuevos editados
            daoComponent.eliminarTodosProveedoresDeComponente(c.getItCodi()); 
            
            if (c.getCompra() != null) {
                for (Map.Entry<Proveidor, java.math.BigDecimal> entry : c.getCompra().entrySet()) {
                    vincularProveedor(c.getItCodi(), entry.getKey().getPvCodi(), entry.getValue().doubleValue());
                }
            }
        }
    }
    return rows;
}

    // Obtener subitems de un producto
    public List<Item> obtenerItemsDelProducto(int codigoProducto) {
        return daoItem.obtenerItemsDeProducto(codigoProducto);
    }

    // Actualizar la cantidad de un item hijo dentro de un producto
    public boolean actualizarCantidadItemHijo(int prodCodi, int itemCodi, int cantidad) {
        return daoItem.actualizarCantidadEnProducto(prodCodi, itemCodi, cantidad) > 0;
    }

    // Agregar un subitem a un producto
    public boolean agregarSubitem(int prodCodi, int subitemCodi, int cantidad) {
        if (prodCodi == subitemCodi || cantidad <= 0) return false;
        return daoItem.agregarSubitemEnProducto(prodCodi, subitemCodi, cantidad) > 0;
    }

    // Eliminar un subitem de un producto
    public boolean eliminarSubitem(int prodCodi, int subitemCodi) {
        return daoItem.eliminarSubitemDeProducto(prodCodi, subitemCodi) > 0;
    }

    // Método para buscar items por nombre o ID
    public List<Item> buscarItems(String busqueda) {
        return daoItem.buscarItems(busqueda);
    }

    // MÉTODO ACTUALIZADO PARA AGREGAR PRODUCTO (Incluye gestión de Foto en DAO_Item)
    // MÉTODO SIMPLIFICADO: El DAO se encarga de la transacción completa
public int agregarProducto(Producte producto) {
    // 1. Llamamos directamente al DAO de Producto.
    // Este DAO ya debe contener la lógica de insertar en ITEM, PRODUCTE y PROD_ITEM
    int nuevoId = daoProducte.Afegir(producto);
    
    if (nuevoId > 0) {
        System.out.println("Producto insertado con éxito. ID: " + nuevoId);
        return nuevoId;
    }
    
    System.err.println("Error al insertar el producto en el DAO");
    return 0;
}

    // MÉTODO ACTUALIZADO PARA AGREGAR COMPONENTE (Incluye gestión de Foto en DAO_Item)
    // MÉTODO ACTUALIZADO: Ahora gestiona también los proveedores del componente
    public int agregarComponente(Component componente) {
        // 1. Insertamos en ITEM (Tabla padre) y recuperamos el ID
        int nuevoId = daoItem.Afegir(componente);
        
        if (nuevoId > 0) {
            componente.setItCodi(nuevoId);
            componente.setCmCodi(nuevoId); 

            // 2. Insertamos en la tabla específica COMPONENT
            int resultado = daoComponent.Afegir(componente);
            
            // 3. NUEVO: Insertamos los proveedores si existen en el HashMap
            if (resultado > 0 && componente.getCompra() != null) {
                for (Map.Entry<Proveidor, java.math.BigDecimal> entry : componente.getCompra().entrySet()) {
                    // Vinculamos cada proveedor del mapa a la base de datos
                    vincularProveedor(nuevoId, entry.getKey().getPvCodi(), entry.getValue().doubleValue());
                }
            }
            
            return (resultado > 0) ? nuevoId : 0;
        }
        return 0;
    }

    // NUEVO MÉTODO: Necesario para que el DAO guarde la relación Proveedor-Componente
    public boolean vincularProveedor(int cmCodi, int pvCodi, double preu) {
        // Este método debe existir en tu DAO_Component o DAO_Proveidor
        // Llamará a un INSERT INTO PROV_COMP (o como se llame tu tabla de unión)
        return daoComponent.vincularProveedor(cmCodi, pvCodi, preu) > 0;
    }
    
    public List<Item> obtenerSubproductos() {
        return daoItem.obtenerSubproductos();
    }

   public int eliminarItem(int id) {
    int resultado = daoItem.Eliminar(id);
    return resultado;
}

    public List<Proveidor> obtenerProveedores() {
        return daoProv.MostrarTots();
    }

    public List<UnitatMesura> obtenerUnidades() {
        return daoUM.MostrarTots();
    }
    // 1. Obtener todos los componentes con sus precios ya cargados
public List<Component> obtenerComponentesCompletos() {
    // 1. Obtenemos la lista base desde el DAO de Componentes
    // Este método ya debe devolver objetos de tipo 'Component' (con el JOIN de ITEM)
    List<Component> lista = daoComponent.MostrarTots();
    
    // 2. Si la lista no es nula, recorremos cada componente para inyectar sus precios
    if (lista != null) {
        for (Component c : lista) {
            try {
                // LLAMADA CRUCIAL: Cargamos el HashMap 'compra' desde la tabla PROV_COMP
                HashMap<Proveidor, java.math.BigDecimal> precios = daoComponent.obtenerPreciosPorProveedor(c.getItCodi());
                
                if (precios != null) {
                    c.setCompra(precios);
                } else {
                    // Si el DAO devuelve null, ponemos un HashMap vacío para evitar errores en el JSP
                    c.setCompra(new java.util.HashMap<>());
                }
            } catch (Exception e) {
                System.err.println("Error cargando precios para componente ID " + c.getItCodi() + ": " + e.getMessage());
                c.setCompra(new java.util.HashMap<>());
            }
        }
    } else {
        // Si la base de datos no devuelve nada, devolvemos una lista vacía (no null)
        lista = new java.util.ArrayList<>();
    }
    
    return lista;
}

// 2. Obtener un único componente con su detalle y precios
public Component obtenerDetalleComponenteCompleto(int id) {
    // 1. Vamos directamente al DAO de Componentes. 
    // Este método (que te pasé antes) ya debe hacer el INNER JOIN con ITEM.
    Component c = daoComponent.MostrarPerId(id);

    // 2. Si el componente existe, le cargamos su mapa de precios/proveedores
    if (c != null) {
        try {
            // Rellenamos el HashMap con la relación de la tabla PROV_COMP
            HashMap<Proveidor, java.math.BigDecimal> precios = daoComponent.obtenerPreciosPorProveedor(id);
            c.setCompra(precios);
        } catch (Exception e) {
            System.err.println("Error al cargar precios para el componente " + id + ": " + e.getMessage());
            // Inicializamos el mapa vacío para evitar NullPointerException en el JSP
            c.setCompra(new java.util.HashMap<>());
        }
        return c;
    }

    // Si llegamos aquí, es que el ID no existía o no era un componente
    System.out.println("DEBUG: No se encontró el componente con ID: " + id);
    return null;
}

public boolean actualizarRelacionProveedores(int itemCodi, String[] provIds, String[] provPrecios) {
    try {
        // 1. Borramos los registros actuales usando el DAO que ya tienes
        daoComponent.eliminarTodosProveedoresDeComponente(itemCodi);
        
        // 2. Si nos han llegado proveedores nuevos, los recorremos e insertamos
        if (provIds != null && provPrecios != null) {
            for (int i = 0; i < provIds.length; i++) {
                int pvCodi = Integer.parseInt(provIds[i]);
                double precio = Double.parseDouble(provPrecios[i]);
                
                // Usamos el método vincularProveedor que ya tienes en el controlador
                vincularProveedor(itemCodi, pvCodi, precio);
            }
        }
        return true;
    } catch (Exception e) {
        System.err.println("Error al actualizar proveedores: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

}