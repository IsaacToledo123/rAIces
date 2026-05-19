import '../../domain/entities/hospedaje_item.dart';
import '../../domain/repository/i_hospedaje_repository.dart';
import '../datasource/hospedaje_local_datasource.dart';

class HospedajeRepositoryImpl implements IHospedajeRepository {
  final HospedajeLocalDatasource datasource;

  HospedajeRepositoryImpl(this.datasource);

  @override
  Future<List<HospedajeItem>> getItems() => datasource.getItems();

  @override
  Future<List<HospedajeItem>> filterByLocation(String location) async {
    final all = await datasource.getItems();
    if (location == 'Todos') return all;
    return all.where((h) => h.location == location).toList();
  }
}
