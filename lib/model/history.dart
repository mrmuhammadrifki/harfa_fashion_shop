class History {
  final String id;
  final String name;
  final String category;
  final String description;
  final int quantity;
  final int totalPrice;
  final DateTime dateCreated;

  History({
    required this.name,
    required this.category,
    required this.description,
    required this.quantity,
    required this.totalPrice,
    required this.id,
    required this.dateCreated,
  });

  factory History.fromJson(Map<String, dynamic> map) {
    return History(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      description: map['description'] as String,
      quantity: map['quantity'] as int,
      totalPrice: map['totalPrice'] as int,
      dateCreated: (map['dateCreated']).toDate(),
    );
  }
}
