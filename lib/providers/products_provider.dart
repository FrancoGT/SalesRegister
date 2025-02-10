import 'package:flutter/material.dart';
import 'package:salesresgistrator/models/product.dart';

class ProductsProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  ProductsProvider() {
    loadProducts();
  }

  // Cargar los productos desde la base de datos
  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    final db = await Product.getDatabase(); // Obtenemos la base de datos
    _products = await Product.getProducts(db); // Usamos el método estático para obtener productos
    _isLoading = false;
    notifyListeners();
  }

  // Añadir un nuevo producto
  Future<void> addProduct(Product product) async {
    final db = await Product.getDatabase(); // Obtenemos la base de datos
    await Product.insertProduct(db, product); // Usamos el método estático de Product
    loadProducts(); // Recargar la lista de productos
  }

  // Obtener un producto por su ID
  Future<Product> getProductById(int productId) async {
    final db = await Product.getDatabase(); // Obtenemos la base de datos
    return await Product.getProductById(db, productId); // Usamos el método estático de Product
  }

  // Actualizar un producto
  Future<void> updateProduct(Product product) async {
    final db = await Product.getDatabase(); // Obtenemos la base de datos
    await Product.updateProduct(db, product); // Usamos el método estático de Product
    loadProducts(); // Recargar la lista de productos
  }
}