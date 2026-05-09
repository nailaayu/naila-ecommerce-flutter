class Product {
  final int id;
  final String name;
  final String categoryId;
  final String categoryName;
  final double price;
  final double rating;
  final String imagePath;
  final String description;
  final bool featured;

  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.price,
    required this.rating,
    required this.imagePath,
    required this.description,
    this.featured = false,
  });
}
