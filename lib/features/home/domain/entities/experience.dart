import 'package:equatable/equatable.dart';

class Experience extends Equatable {
  final String id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final String community;
  final String description;
  final String? imageUrl;

  const Experience({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.community,
    required this.description,
    this.imageUrl,
  });

  @override
  List<Object?> get props =>
      [id, name, category, price, rating, community, description, imageUrl];
}
