class Product {
  final String id;
  final String name;
  final Map<String, dynamic> data;

  Product({
    required this.id,
    required this.name,
    required this.data,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      data: json['data'] ?? {},
    );
  }
}
