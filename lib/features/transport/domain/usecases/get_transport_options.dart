import '../entities/transport_option.dart';
import '../repository/i_transport_repository.dart';

class GetTransportOptions {
  final ITransportRepository repository;

  GetTransportOptions(this.repository);

  Future<List<TransportOption>> call() => repository.getOptions();
}
