import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'product.dart';
import 'seller.dart';

class Sale
{
  int? id;
  String date;
  int sellerId;
  int quantity;
  int productId;
  String paymentMethod;

  // Constructor
  Sale({
    this.id,
    required this.date,
    required this.sellerId,
    required this.quantity,
    required this.productId,
    required this.paymentMethod,
  });

  // Método estático para obtener la base de datos
  static Future<Database> getDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sales(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            seller_id INTEGER,
            quantity INTEGER,
            product_id INTEGER,
            payment_method TEXT,
            FOREIGN KEY(seller_id) REFERENCES sellers(id),
            FOREIGN KEY(product_id) REFERENCES products(id)
          )
        ''');
      },
    );
  }


  // Método para insertar una venta
  static Future<int> insertSale(Database db, Sale sale) async {
    return await db.insert('sales', sale.toMap());
  }

  // Método para obtener todas las ventas
  static Future<List<Sale>> getSales(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('sales');

    // Usamos List.generate para convertir cada registro en una instancia de Sale
    return List.generate(maps.length, (i) {
      return Sale.fromMap(maps[i]);
    });
  }

  // Obtener una venta por ID
  static Future<Sale> getSaleById(Database db, int id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'sales',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Sale.fromMap(maps.first);
    } else {
      throw Exception('Venta no encontrada');
    }
  }

  // Convertir la venta a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'seller_id': sellerId,
      'quantity': quantity,
      'product_id': productId,
      'payment_method': paymentMethod,
    };
  }

  // Crear una venta desde un mapa
  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      date: map['date'],
      sellerId: map['seller_id'],
      quantity: map['quantity'],
      productId: map['product_id'],
      paymentMethod: map['payment_method'],
    );
  }

  get productName => null;

  get sellerName => null;

  get subtotal => null;

  // Obtener el nombre del vendedor vinculado
  Future<String> getSellerName(Database db) async {
    Seller seller = await Seller.getSellerById(db, sellerId);
    return seller.name;
  }

  // Obtener el nombre del producto vinculado
  Future<String> getProductName(Database db) async {
    Product product = await Product.getProductById(db, productId);
    return product.name;
  }

  // Método auxiliar para calcular el subtotal (quantity * price del producto)
  Future<double> calculateSubtotal(Database db) async {
    Product product = await Product.getProductById(db, productId);
    return quantity * product.price;
  }

  // Método para obtener todas las ventas con el nombre del vendedor, el producto y el subtotal
  static Future<List<Map<String, dynamic>>> getSalesWithDetails(Database db) async {
    final List<Map<String, dynamic>> sales = await db.rawQuery('''
      SELECT 
        sales.id AS sale_id,
        sales.date,
        sellers.name AS seller_name,
        products.name AS product_name,
        sales.quantity,
        products.price,  -- Asegúrate de que el producto tenga un campo "price"
        sales.payment_method,
        (sales.quantity * products.price) AS subtotal  -- Cálculo del subtotal directamente en la consulta
      FROM sales
      INNER JOIN sellers ON sales.seller_id = sellers.id
      INNER JOIN products ON sales.product_id = products.id
      ''');

    return sales;
  }


  // Método para calcular la suma de todos los subtotales
  static Future<double> calculateTotal(Database db) async
  {
    // Recuperamos todas las ventas con sus detalles
    final List<Map<String, dynamic>> sales = await db.rawQuery('''
    SELECT s.id, s.quantity, p.price
    FROM sales s
    JOIN products p ON s.product_id = p.id
  ''');

    double total = 0.0;

    // Sumamos los subtotales (quantity * price) de todas las ventas
    for (var sale in sales)
    {
      double subtotal = sale['quantity'] * sale['price'];
      total += subtotal;
    }

    return total;
  }

  // Método para actualizar una venta
  static Future<int> updateSale(Database db, Sale sale) async {
    return await db.update(
      'sales',
      sale.toMap(),
      where: 'id = ?',
      whereArgs: [sale.id],
    );
  }

  // Método para eliminar una venta
  static Future<int> deleteSale(Database db, int saleId) async {
    return await db.delete(
      'sales',
      where: 'id = ?',
      whereArgs: [saleId],
    );
  }
}