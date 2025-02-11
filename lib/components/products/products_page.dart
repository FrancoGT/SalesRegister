import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesresgistrator/providers/products_provider.dart';
import 'package:salesresgistrator/components/common/sidebar.dart';
import 'package:salesresgistrator/components/products/create_product_page.dart';
import 'package:salesresgistrator/components/products/edit_product_page.dart';
import 'package:salesresgistrator/components/common/searchable_datatable.dart';

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

  void _deleteProduct(int productId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar este producto?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await Provider.of<ProductsProvider>(context, listen: false).deleteProduct(productId);
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
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
                    backgroundColor: const Color(0xFF81C784),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Crear Producto'),
                ),
                provider.products.isEmpty
                    ? const Center(child: Text('No hay productos disponibles.'))
                    : SearchableDataTable(
                  columns: const ['Nombre', 'Precio', 'Estado', 'Acciones'],
                  data: provider.products.map((product) {
                    return {
                      'id': product.id,
                      'Nombre': product.name,
                      'Precio': product.price,
                      'Estado': product.status == 'Active' ? 'Activo' : 'Inactivo',
                      'Acciones': '', // Esta columna no requiere datos, los botones se agregan desde el código
                    };
                  }).toList(),
                  onEdit: _editProduct,
                  onDelete: _deleteProduct, // Función de eliminación
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}