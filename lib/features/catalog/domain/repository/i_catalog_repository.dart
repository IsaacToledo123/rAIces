import '../entities/catalog_item.dart';

abstract class ICatalogRepository {
  Future<List<CatalogItem>> getItems();
  Future<List<CatalogItem>> filterByCategory(String category);
}
