import 'package:equatable/equatable.dart';

import '../../domain/entities/catalog_item.dart';

enum CatalogStatus { idle, loading, success, error }

class CatalogState extends Equatable {
  final CatalogStatus status;
  final List<CatalogItem> items;
  final String? errorMessage;
  final String selectedCategory;

  const CatalogState({
    this.status = CatalogStatus.idle,
    this.items = const [],
    this.errorMessage,
    this.selectedCategory = 'Todos',
  });

  CatalogState copyWith({
    CatalogStatus? status,
    List<CatalogItem>? items,
    String? errorMessage,
    String? selectedCategory,
  }) {
    return CatalogState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage, selectedCategory];
}
