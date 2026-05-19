import '../entities/catalog_item.dart';
import '../repository/i_catalog_repository.dart';

class GetCatalogItems {
  final ICatalogRepository repository;

  GetCatalogItems(this.repository);

  Future<List<CatalogItem>> call() => repository.getItems();
}
