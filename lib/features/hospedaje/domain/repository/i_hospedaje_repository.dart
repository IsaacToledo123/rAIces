import '../entities/hospedaje_item.dart';

abstract class IHospedajeRepository {
  Future<List<HospedajeItem>> getItems();
  Future<List<HospedajeItem>> filterByLocation(String location);
}
