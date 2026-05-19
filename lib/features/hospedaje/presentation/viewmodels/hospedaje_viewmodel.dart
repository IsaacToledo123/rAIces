import 'package:flutter/material.dart';

import '../../domain/entities/hospedaje_item.dart';
import '../../domain/usecases/get_hospedaje_items.dart';
import '../states/hospedaje_state.dart';

class HospedajeViewModel extends ChangeNotifier {
  final GetHospedajeItems _getItems;

  HospedajeViewModel(this._getItems);

  HospedajeState _state = const HospedajeState();
  HospedajeState get state => _state;

  List<HospedajeItem> _allItems = [];

  Future<void> loadItems() async {
    _state = _state.copyWith(status: HospedajeStatus.loading);
    notifyListeners();
    try {
      _allItems = await _getItems();
      _state = _state.copyWith(
        status: HospedajeStatus.success,
        items: _allItems,
      );
    } catch (e) {
      _state = _state.copyWith(
        status: HospedajeStatus.error,
        errorMessage: 'Error al cargar hospedaje',
      );
    }
    notifyListeners();
  }

  void filterByLocation(String location) {
    final filtered = location == 'Todos'
        ? _allItems
        : _allItems.where((h) => h.location == location).toList();
    _state = _state.copyWith(
      selectedLocation: location,
      items: filtered,
    );
    notifyListeners();
  }
}
