import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';

class User {
  int? id;
  String username;
  String password;
  String name;

  User({this.id, required this.username, required this.password, required this.name});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
    };
  }

  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Métodos para la creación y verificación de usuarios

  static Future<int> createUser(Database db, User user) async {
    String hashedPassword = hashPassword(user.password);
    user.password = hashedPassword;
    return await db.insert('users', user.toMap());
  }

  static Future<User?> getUser(Database db, String username, String password) async {
    String hashedPassword = hashPassword(password);
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
}