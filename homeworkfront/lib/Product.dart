class Product {
  final int productId;
  final String productName;
  final double price;
  final String category;
  final String imageurl;

  Product({
    required this.productId,
    required this.productName,
    required this.price,
    required this.category,
    required this.imageurl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productid'],
      productName: json['productname'],
      price: json['price'],
      category: json['category'],
      imageurl: json['imageurl'],
    );
  }
}
