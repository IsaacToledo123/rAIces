import 'package:equatable/equatable.dart';

class CatalogItem extends Equatable {
  final String id;
  final String name;
  final String category;
  final String community;
  final double price;
  final double rating;
  final String description;
  final String? includes;
  final String? schedule;

  const CatalogItem({
    required this.id,
    required this.name,
    required this.category,
    required this.community,
    required this.price,
    required this.rating,
    required this.description,
    this.includes,
    this.schedule,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    community,
    price,
    rating,
    description,
    includes,
    schedule,
  ];
}
