import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesresgistrator/providers/sellers_provider.dart';
import 'package:salesresgistrator/components/common/sidebar.dart';
import 'package:salesresgistrator/components/sellers/create_seller_page.dart';
import 'package:salesresgistrator/components/sellers/edit_seller_page.dart';
import 'package:salesresgistrator/components/common/searchable_datatable.dart';

class SellersPage extends StatefulWidget {
  const SellersPage({super.key});

  @override
  _SellersPageState createState() => _SellersPageState();
}

class _SellersPageState extends State<SellersPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<SellersProvider>(context, listen: false).loadSellers();
  }

  void _editSeller(int sellerId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSellerPage(sellerId: sellerId),
      ),
    );

    if (result == true) {
      Provider.of<SellersProvider>(context, listen: false).loadSellers();
    }
  }

  void _deleteSeller(int sellerId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar este vendedor?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await Provider.of<SellersProvider>(context, listen: false).deleteSeller(sellerId);
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
      appBar: AppBar(title: const Text('Vendedores')),
      drawer: const Sidebar(currentPage: '/sellers'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<SellersProvider>(
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
                      MaterialPageRoute(builder: (context) => const CreateSellerPage()),
                    );
                    if (result == true) {
                      provider.loadSellers();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF81C784),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Crear Vendedor'),
                ),
                provider.sellers.isEmpty
                    ? const Center(child: Text('No hay vendedores disponibles.'))
                    : SearchableDataTable(
                  columns: const ['Nombre', 'Estado', 'Acciones'],
                  data: provider.sellers.map((seller) {
                    return {
                      'id': seller.id,
                      'Nombre': seller.name,
                      'Estado': seller.status == 'Active' ? 'Activo' : 'Inactivo',
                      'Acciones': '',
                    };
                  }).toList(),
                  onEdit: _editSeller,
                  onDelete: _deleteSeller,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}