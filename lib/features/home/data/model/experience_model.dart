import '../../domain/entities/experience.dart';

class ExperienceModel extends Experience {
  const ExperienceModel({
    required String id,
    required String name,
    required String category,
    required double price,
    required double rating,
    required String community,
    required String description,
    String? imageUrl,
  }) : super(
    id: id,
    name: name,
    category: category,
    price: price,
    rating: rating,
    community: community,
    description: description,
    imageUrl: imageUrl,
  );

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      community: json['community'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'rating': rating,
      'community': community,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory ExperienceModel.fromEntity(Experience entity) {
    return ExperienceModel(
      id: entity.id,
      name: entity.name,
      category: entity.category,
      price: entity.price,
      rating: entity.rating,
      community: entity.community,
      description: entity.description,
      imageUrl: entity.imageUrl,
    );
  }
}
