class Sale {
  int? id;
  String date;
  int sellerId;
  int quantity;
  int productId;
  double subtotal;
  String paymentMethod;
  String status;

  Sale({
    this.id,
    required this.date,
    required this.sellerId,
    required this.quantity,
    required this.productId,
    required this.subtotal,
    required this.paymentMethod,
    this.status = 'Active',
  });

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      date: map['date'],
      sellerId: map['seller_id'],
      quantity: map['quantity'],
      productId: map['product_id'],
      subtotal: map['subtotal'].toDouble(),
      paymentMethod: map['payment_method'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'seller_id': sellerId,
      'quantity': quantity,
      'product_id': productId,
      'subtotal': subtotal,
      'payment_method': paymentMethod,
      'status': status,
    };
  }
}