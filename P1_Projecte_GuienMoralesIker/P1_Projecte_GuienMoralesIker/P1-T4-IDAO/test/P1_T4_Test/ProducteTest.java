/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package P1_T4_Test;

import P1_T4_Model.Item;
import P1_T4_Model.Producte;
/**
 *
 * @author Usuari
 */import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.util.HashMap;

class ProducteTest {

    private Producte producte;
    private Item item; // Esto simula un "Item" relacionado con el Producto.

    @BeforeEach
    void setUp() {
        // Crear un producto antes de cada prueba.
        producte = new Producte();
        item = new Item();
        
        // Asignamos un código y un nombre al Item de prueba
        item.setItCodi(1);
        item.setItNom("Test Item");
        
        // Simulamos un producto
        producte.setPrCodi(1001);
        
        // Inicializamos subitems (simulamos que el producto tiene subproductos).
        HashMap<Item, Integer> subitems = new HashMap<>();
        subitems.put(item, 2); // 2 unidades del "Item" como subproducto.
        producte.setSubitems(subitems);
    }

    // Test 1: Verificar la creación del objeto Producte
    @Test
    void testCreateProducte() {
        assertNotNull(producte, "El producto no debe ser nulo.");
        assertEquals(1001, producte.getPrCodi(), "El código del producto no es el esperado.");
        assertEquals(1, producte.getItCodi(), "El código del item asociado no es el esperado.");
        assertEquals("Test Item", producte.getItNom(), "El nombre del item asociado no es el esperado.");
    }

    // Test 2: Verificar setter y getter de prCodi
    @Test
    void testSetGetPrCodi() {
        producte.setPrCodi(2002);
        assertEquals(2002, producte.getPrCodi(), "El código del producto no se ha actualizado correctamente.");
    }

    // Test 3: Verificar los subitems del producto
    @Test
    void testSetGetSubitems() {
        HashMap<Item, Integer> subitems = producte.getSubitems();
        assertNotNull(subitems, "El mapa de subitems no debe ser nulo.");
        assertEquals(1, subitems.size(), "Debe haber un subitem asociado al producto.");
        assertTrue(subitems.containsKey(item), "El subitem no contiene el item esperado.");
        assertEquals(2, subitems.get(item), "La cantidad del subitem debe ser 2.");
    }

    // Test 4: Verificar agregar un subitem adicional
    @Test
    void testAddSubitem() {
        Item anotherItem = new Item();
        anotherItem.setItCodi(2);
        anotherItem.setItNom("Another Item");
        
        // Agregar un nuevo subitem
        producte.getSubitems().put(anotherItem, 5);
        
        // Verificar que el subitem se ha agregado correctamente
        assertEquals(2, producte.getSubitems().size(), "Debería haber dos subitems.");
        assertTrue(producte.getSubitems().containsKey(anotherItem), "El subitem adicional no se ha agregado.");
        assertEquals(5, producte.getSubitems().get(anotherItem), "La cantidad del nuevo subitem no es la correcta.");
    }

    // Test 5: Verificar que el código de item no sea nulo
    @Test
    void testItemCodiNotNull() {
        assertNotNull(producte.getItCodi(), "El código del item no debe ser nulo.");
    }
}
