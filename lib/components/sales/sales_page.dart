import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:salesresgistrator/components/common/sidebar.dart';
import 'package:salesresgistrator/models/Product.dart'; // Asegúrate de importar tu clase Product

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  List<Map<String, dynamic>> _products = [];
  int? _selectedProductId;

  @override
  void initState() {
    super.initState();
    _loadActiveProducts();
  }

  Future<void> _loadActiveProducts() async {
    Database db = await Product.getDatabase();
    List<Map<String, dynamic>> products = await Product.getActiveProducts(db);
    setState(() {
      _products = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas'),
      ),
      drawer: const Sidebar(currentPage: '/sales'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seleccionar Producto:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: _selectedProductId,
              items: _products.map((product) {
                return DropdownMenuItem<int>(
                  value: product['id'],
                  child: Text(product['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProductId = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}