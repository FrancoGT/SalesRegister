import 'package:flutter/material.dart';
import 'package:salesresgistrator/models/sale.dart';

class SalesProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _salesWithDetails = [];
  bool _isLoading = false;
  double _totalSales = 0.0; // Variable para almacenar el total

  List<Map<String, dynamic>> get salesWithDetails => _salesWithDetails;
  bool get isLoading => _isLoading;
  double get totalSales => _totalSales; // Getter para acceder al total de ventas

  SalesProvider() {
    loadSales();
  }

  // Cargar las ventas con los detalles de los productos y vendedores
  Future<void> loadSales() async {
    _isLoading = true;
    notifyListeners();

    final db = await Sale.getDatabase(); // Obtenemos la base de datos
    _salesWithDetails = await Sale.getSalesWithDetails(db); // Usamos el método estático para obtener ventas con detalles

    // Calculamos el total de las ventas
    _totalSales = await Sale.calculateTotal(db);

    _isLoading = false;
    notifyListeners();
  }

  // Añadir una nueva venta
  Future<void> addSale(Sale sale) async {
    final db = await Sale.getDatabase(); // Obtenemos la base de datos
    await Sale.insertSale(db, sale); // Usamos el método estático de Sale
    loadSales(); // Recargar la lista de ventas
  }

  // Obtener una venta por su ID
  Future<Sale> getSaleById(int saleId) async {
    final db = await Sale.getDatabase(); // Obtenemos la base de datos
    return await Sale.getSaleById(db, saleId); // Usamos el método estático de Sale
  }

  // Actualizar una venta
  Future<void> updateSale(Sale sale) async {
    final db = await Sale.getDatabase(); // Obtenemos la base de datos
    await Sale.updateSale(db, sale); // Usamos el método estático de Sale
    loadSales(); // Recargar la lista de ventas
  }

  // Eliminar una venta
  Future<void> deleteSale(int saleId) async {
    final db = await Sale.getDatabase(); // Obtenemos la base de datos
    await Sale.deleteSale(db, saleId); // Usamos el método estático de Sale
    loadSales(); // Recargar la lista de ventas
  }
}