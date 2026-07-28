import '../models/product.dart';
class Product {
  final int id;
  final String name;
  final String description;
  final int price;
  final String image;
  final String category;
  final double rating;
  final int stock;
  final List<String> sizes;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.rating,
    required this.stock,
    required this.sizes,
  });
}