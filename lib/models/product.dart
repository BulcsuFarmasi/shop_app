class Product {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({required this.id, this.title, this.description, this.imageUrl, this.price, this.isFavorite});
}