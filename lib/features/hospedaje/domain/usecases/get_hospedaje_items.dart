import '../entities/hospedaje_item.dart';
import '../repository/i_hospedaje_repository.dart';

class GetHospedajeItems {
  final IHospedajeRepository repository;

  GetHospedajeItems(this.repository);

  Future<List<HospedajeItem>> call() => repository.getItems();
}
