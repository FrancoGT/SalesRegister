import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../models/seller.dart';
import '../models/sale.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Crear las tablas
  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price REAL,
        status TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE sellers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        status TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE sales(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        seller_id INTEGER,
        quantity INTEGER,
        product_id INTEGER,
        subtotal REAL,
        payment_method TEXT,
        status TEXT,
        FOREIGN KEY(seller_id) REFERENCES sellers(id),
        FOREIGN KEY(product_id) REFERENCES products(id)
      )
    ''');

    // Insertar usuario "SuperAdmin" con contraseña encriptada y nombre
    String hashedPassword = User.hashPassword("admin");
    await db.insert('users', {'username': 'admin', 'password': hashedPassword, 'name': 'SuperAdmin'});
  }

  // Funciones para insertar, obtener, actualizar y eliminar datos
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUser(String username, String password) async {
    final db = await database;
    String hashedPassword = User.hashPassword(password);
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, hashedPassword],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }




  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('products', product.toMap());
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<Product> getProductById(int productId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
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

  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<int> insertSeller(Seller seller) async {
    final db = await database;
    return await db.insert('sellers', seller.toMap());
  }

  Future<List<Seller>> getSellers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sellers');
    return List.generate(maps.length, (i) {
      return Seller.fromMap(maps[i]);
    });
  }

  Future<int> insertSale(Sale sale) async {
    final db = await database;
    return await db.insert('sales', sale.toMap());
  }

  Future<List<Sale>> getSales() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sales');
    return List.generate(maps.length, (i) {
      return Sale.fromMap(maps[i]);
    });
  }
}