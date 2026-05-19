import '../../domain/entities/transport_option.dart';
import '../../domain/repository/i_transport_repository.dart';
import '../datasource/transport_local_datasource.dart';

class TransportRepositoryImpl implements ITransportRepository {
  final TransportLocalDatasource datasource;

  TransportRepositoryImpl(this.datasource);

  @override
  Future<List<TransportOption>> getOptions() => datasource.getOptions();

  @override
  Future<List<TransportOption>> filterByType(String type) async {
    final all = await datasource.getOptions();
    if (type == 'Todos') return all;
    return all.where((o) => o.type == type).toList();
  }
}
