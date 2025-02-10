class Product 
{
  int? id;
  String name;
  double price;
  String status;

  Product({this.id, required this.name, required this.price, this.status = 'Active'});

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'].toDouble(),
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'status': status,
    };
  }
}