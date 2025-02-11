import 'package:flutter/material.dart';
import 'package:salesresgistrator/models/seller.dart';

class SellersProvider extends ChangeNotifier
{
  List<Seller> _sellers = [];
  bool _isLoading = false;

  List<Seller> get sellers => _sellers;
  bool get isLoading => _isLoading;

  SellersProvider() {
    loadSellers();
  }

  // Cargar los vendedores desde la base de datos
  Future<void> loadSellers() async {
    _isLoading = true;
    notifyListeners();

    final db = await Seller.getDatabase(); // Obtenemos la base de datos
    _sellers = await Seller.getSellers(db); // Usamos el método estático para obtener vendedores
    _isLoading = false;
    notifyListeners();
  }

  // Añadir un nuevo vendedor
  Future<void> addSeller(Seller seller) async {
    final db = await Seller.getDatabase(); // Obtenemos la base de datos
    await Seller.insertSeller(db, seller); // Usamos el método estático de Seller
    loadSellers(); // Recargar la lista de vendedores
  }

  // Obtener un vendedor por su ID
  Future<Seller> getSellerById(int sellerId) async {
    final db = await Seller.getDatabase(); // Obtenemos la base de datos
    return await Seller.getSellerById(db, sellerId); // Usamos el método estático de Seller
  }

  // Actualizar un vendedor
  Future<void> updateSeller(Seller seller) async {
    final db = await Seller.getDatabase(); // Obtenemos la base de datos
    await Seller.updateSeller(db, seller); // Usamos el método estático de Seller
    loadSellers(); // Recargar la lista de vendedores
  }

  // Eliminar un vendedor
  Future<void> deleteSeller(int sellerId) async {
    final db = await Seller.getDatabase(); // Obtenemos la base de datos
    await Seller.deleteSeller(db, sellerId); // Usamos el método estático de Seller
    loadSellers(); // Recargar la lista de vendedores
  }
}