import '../entities/transport_option.dart';

abstract class ITransportRepository {
  Future<List<TransportOption>> getOptions();
  Future<List<TransportOption>> filterByType(String type);
}
