import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Seller
{
  int? id;
  String name;
  String status;

  Seller({this.id, required this.name, this.status = 'Active'});

  // Método estático para obtener la base de datos
  static Future<Database> getDatabase() async {
    // Abre o crea la base de datos
    String path = join(await getDatabasesPath(), 'app_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE sellers(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            status TEXT
          )
        ''');
      },
    );
  }

  // Método para insertar un vendedor
  static Future<int> insertSeller(Database db, Seller seller) async {
    return await db.insert('sellers', seller.toMap());
  }

  // Método para obtener todos los vendedores
  static Future<List<Seller>> getSellers(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('sellers');
    return List.generate(maps.length, (i) {
      return Seller.fromMap(maps[i]);
    });
  }

  // Método para obtener un vendedor por ID
  static Future<Seller> getSellerById(Database db, int id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'sellers',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Seller.fromMap(maps.first);
    } else {
      throw Exception('Vendedor no encontrado');
    }
  }

  // Método para actualizar un vendedor
  static Future<void> updateSeller(Database db, Seller seller) async {
    await db.update(
      'sellers',
      seller.toMap(),
      where: 'id = ?',
      whereArgs: [seller.id],
    );
  }

  // Método para eliminar un vendedor
  static Future<void> deleteSeller(Database db, int id) async {
    await db.delete(
      'sellers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Convertir el vendedor a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
    };
  }

  // Crear un vendedor desde un mapa
  factory Seller.fromMap(Map<String, dynamic> map) {
    return Seller(
      id: map['id'],
      name: map['name'],
      status: map['status'],
    );
  }

  // Método para obtener vendedores activos con id y nombre
  static Future<List<Map<String, dynamic>>> getActiveSellers(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'sellers',
      columns: ['id', 'name'],
      where: 'status = ?',
      whereArgs: ['Active'],
    );
    return maps;
  }

}