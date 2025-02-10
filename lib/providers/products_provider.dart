import 'package:flutter/material.dart';
import 'package:salesresgistrator/database/databasehelper.dart';
import 'package:salesresgistrator/models/product.dart';

class ProductsProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  ProductsProvider() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    _products = await DatabaseHelper().getProducts();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await DatabaseHelper().insertProduct(product);
    loadProducts();
  }

  Future<Product> getProductById(int productId) async {
    final db = await DatabaseHelper().database;

    final maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
    );

    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    } else {
      throw Exception('Producto no encontrado');
    }
  }

  Future<void> updateProduct(Product product) async {
    await DatabaseHelper().updateProduct(product);
    loadProducts();
  }
}