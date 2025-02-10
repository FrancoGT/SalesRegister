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
    User superAdmin = User(username: 'admin', password: 'admin', name: 'SuperAdmin');
    await User.createUser(db, superAdmin);
  }
}