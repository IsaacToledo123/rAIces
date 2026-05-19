import '../entities/catalog_item.dart';
import '../repository/i_catalog_repository.dart';

class FilterCatalogByCategory {
  final ICatalogRepository repository;

  FilterCatalogByCategory(this.repository);

  Future<List<CatalogItem>> call(String category) =>
      repository.filterByCategory(category);
}
