import '../../domain/entities/catalog_item.dart';
import '../../domain/repository/i_catalog_repository.dart';
import '../datasource/catalog_local_datasource.dart';

class CatalogRepositoryImpl implements ICatalogRepository {
  final CatalogLocalDatasource localDatasource;

  CatalogRepositoryImpl(this.localDatasource);

  @override
  Future<List<CatalogItem>> getItems() async {
    return await localDatasource.getItems();
  }

  @override
  Future<List<CatalogItem>> filterByCategory(String category) async {
    return await localDatasource.filterByCategory(category);
  }
}
