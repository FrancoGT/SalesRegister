import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesresgistrator/providers/products_provider.dart';
import 'package:salesresgistrator/components/common/sidebar.dart';
import 'package:salesresgistrator/components/common/searchable_datatable.dart';
import 'package:salesresgistrator/components/products/create_product_page.dart';
import 'package:salesresgistrator/components/products/edit_product_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductsProvider>(context, listen: false).loadProducts();
  }

  void _editProduct(int productId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(productId: productId),
      ),
    );

    if (result == true) {
      Provider.of<ProductsProvider>(context, listen: false).loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      drawer: const Sidebar(currentPage: '/products'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ProductsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateProductPage()),
                    );
                    if (result == true) {
                      provider.loadProducts();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF81C784), // Color de fondo
                    foregroundColor: Colors.white, // Color del texto
                  ),
                  child: const Text('Crear Producto'),
                ),
                provider.products.isEmpty
                    ? const Center(child: Text('No hay productos disponibles.'))
                    : SearchableDataTable(
                  columns: const ['Nombre', 'Precio', 'Estado', 'Acciones'],
                  data: provider.products.map((product) {
                    return {
                      'id': product.id, // Incluimos el id en los datos
                      'Nombre': product.name,
                      'Precio': product.price,
                      'Estado': product.status,
                      'Acciones': '', // Esta columna será solo para el botón de editar
                    };
                  }).toList(),
                  onEdit: (productId) {
                    _editProduct(productId); // Llamamos a la función de edición
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}