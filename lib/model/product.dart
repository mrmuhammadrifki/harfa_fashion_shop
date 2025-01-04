class Product {
  final String id;
  final String name;
  final String category;
  final String description;
  final int price;
  final DateTime dateCreated;

  Product({
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.id,
    required this.dateCreated,
  });

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      description: map['description'] as String,
      price: map['price'] as int,
      dateCreated: (map['dateCreated']).toDate(),
    );
  }
}
