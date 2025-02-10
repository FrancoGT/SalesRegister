class Seller 
{
  int? id;
  String name;
  String status;

  Seller({this.id, required this.name, this.status = 'Active'});

  factory Seller.fromMap(Map<String, dynamic> map) {
    return Seller(
      id: map['id'],
      name: map['name'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
    };
  }
}