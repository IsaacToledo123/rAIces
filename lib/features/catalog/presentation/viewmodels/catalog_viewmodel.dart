import 'package:flutter/material.dart';

import '../../domain/entities/catalog_item.dart';
import '../../domain/usecases/filter_catalog_by_category.dart';
import '../../domain/usecases/get_catalog_items.dart';
import '../states/catalog_state.dart';

class CatalogViewModel extends ChangeNotifier {
  final GetCatalogItems _getCatalogItems;
  final FilterCatalogByCategory _filterCatalogByCategory;

  CatalogState _state = const CatalogState();

  CatalogState get state => _state;

  CatalogViewModel(
    this._getCatalogItems,
    this._filterCatalogByCategory,
  );

  Future<void> loadItems() async {
    _state = _state.copyWith(status: CatalogStatus.loading);
    notifyListeners();
    try {
      final items = await _getCatalogItems();
      _state = _state.copyWith(
        status: CatalogStatus.success,
        items: items,
      );
    } catch (e) {
      _state = _state.copyWith(
        status: CatalogStatus.error,
        errorMessage: e.toString(),
      );
    }
    notifyListeners();
  }

  Future<void> filterByCategory(String category) async {
    _state = _state.copyWith(status: CatalogStatus.loading);
    notifyListeners();
    try {
      List<CatalogItem> items;
      if (category == 'Todos') {
        items = await _getCatalogItems();
      } else {
        items = await _filterCatalogByCategory(category);
      }
      _state = _state.copyWith(
        status: CatalogStatus.success,
        items: items,
        selectedCategory: category,
      );
    } catch (e) {
      _state = _state.copyWith(
        status: CatalogStatus.error,
        errorMessage: e.toString(),
      );
    }
    notifyListeners();
  }
}
