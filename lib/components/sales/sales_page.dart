import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesresgistrator/providers/sales_provider.dart';
import 'package:salesresgistrator/components/common/sidebar.dart';
import 'package:salesresgistrator/components/sales/create_sale_page.dart';
import 'package:salesresgistrator/components/sales/edit_sale_page.dart';
import 'package:salesresgistrator/components/common/searchable_datatable.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<SalesProvider>(context, listen: false).loadSales();
  }

  void _editSale(int saleId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSalePage(saleId: saleId),
      ),
    );

    if (result == true) {
      Provider.of<SalesProvider>(context, listen: false).loadSales();
    }
  }

  void _deleteSale(int saleId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar esta venta?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await Provider.of<SalesProvider>(context, listen: false)
                    .deleteSale(saleId);
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
      appBar: AppBar(title: const Text('Ventas')),
      drawer: const Sidebar(currentPage: '/sales'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<SalesProvider>(
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
                      MaterialPageRoute(builder: (
                          context) => const CreateSalePage()),
                    );
                    if (result == true) {
                      provider.loadSales();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF81C784),
                    // Color similar al ejemplo
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Crear Venta'),
                ),
                provider.salesWithDetails.isEmpty
                    ? const Center(child: Text('No hay ventas disponibles.'))
                    : Column(
                  children: [
                    SearchableDataTable(
                      columns: const [
                        'id',
                        'Fecha',
                        'Vendedor',
                        'Cantidad',
                        'Producto',
                        'Subtotal',
                        'Método de Pago',
                        'Acciones'
                      ],
                      data: provider.salesWithDetails.map((sale) {
                        return {
                          'id': sale['sale_id'],
                          'Fecha': sale['date'],
                          'Vendedor': sale['seller_name'],
                          'Cantidad': sale['quantity'].toString(),
                          'Producto': sale['product_name'],
                          'Subtotal': sale['subtotal'].toString(),
                          'Método de Pago': sale['payment_method'],
                          'Acciones': '',
                        };
                      }).toList(),
                      onEdit: _editSale,
                      onDelete: _deleteSale,
                    ),
                    // Mostrar el total debajo de la tabla
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        'Total de ventas: S/ ${provider.totalSales
                            .toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}