import '../../domain/entities/catalog_item.dart';

class CatalogItemModel extends CatalogItem {
  const CatalogItemModel({
    required String id,
    required String name,
    required String category,
    required String community,
    required double price,
    required double rating,
    required String description,
    String? includes,
    String? schedule,
  }) : super(
    id: id,
    name: name,
    category: category,
    community: community,
    price: price,
    rating: rating,
    description: description,
    includes: includes,
    schedule: schedule,
  );

  factory CatalogItemModel.fromJson(Map<String, dynamic> json) {
    return CatalogItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      community: json['community'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      description: json['description'] as String,
      includes: json['includes'] as String?,
      schedule: json['schedule'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'community': community,
      'price': price,
      'rating': rating,
      'description': description,
      'includes': includes,
      'schedule': schedule,
    };
  }

  factory CatalogItemModel.fromEntity(CatalogItem entity) {
    return CatalogItemModel(
      id: entity.id,
      name: entity.name,
      category: entity.category,
      community: entity.community,
      price: entity.price,
      rating: entity.rating,
      description: entity.description,
      includes: entity.includes,
      schedule: entity.schedule,
    );
  }
}
