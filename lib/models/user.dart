import 'dart:convert';
import 'package:crypto/crypto.dart';

class User {
  int? id;
  String username;
  String password;
  String name;  // Agregamos el campo "name"

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
      'name': name,  // Añadimos el campo "name"
    };
  }

  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }
}