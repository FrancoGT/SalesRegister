import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Product {
  int? id;
  String name;
  double price;
  String status;

  Product({this.id, required this.name, required this.price, this.status = 'Active'});

  // Método estático para obtener la base de datos
  static Future<Database> getDatabase() async {
    // Abre o crea la base de datos
    String path = join(await getDatabasesPath(), 'app_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            price REAL,
            status TEXT
          )
        ''');
      },
    );
  }

  // Método para insertar un producto
  static Future<int> insertProduct(Database db, Product product) async {
    return await db.insert('products', product.toMap());
  }

  // Método para obtener todos los productos
  static Future<List<Product>> getProducts(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Método para obtener un producto por ID
  static Future<Product> getProductById(Database db, int id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    } else {
      throw Exception('Producto no encontrado');
    }
  }

  // Método para actualizar un producto
  static Future<void> updateProduct(Database db, Product product) async {
    await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Convertir el producto a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'status': status,
    };
  }

  // Crear un producto desde un mapa
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'].toDouble(),
      status: map['status'],
    );
  }
}