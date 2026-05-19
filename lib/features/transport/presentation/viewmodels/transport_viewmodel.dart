import 'package:flutter/material.dart';

import '../../domain/entities/transport_option.dart';
import '../../domain/usecases/get_transport_options.dart';
import '../states/transport_state.dart';

class TransportViewModel extends ChangeNotifier {
  final GetTransportOptions _getOptions;

  TransportViewModel(this._getOptions);

  TransportState _state = const TransportState();
  TransportState get state => _state;

  List<TransportOption> _allOptions = [];

  Future<void> loadOptions() async {
    _state = _state.copyWith(status: TransportStatus.loading);
    notifyListeners();
    try {
      _allOptions = await _getOptions();
      _state = _state.copyWith(
        status: TransportStatus.success,
        options: _allOptions,
      );
    } catch (e) {
      _state = _state.copyWith(
        status: TransportStatus.error,
        errorMessage: 'Error al cargar opciones de transporte',
      );
    }
    notifyListeners();
  }

  Future<void> applyTypeFilter(String type) async {
    if (_allOptions.isEmpty) _allOptions = await _getOptions();
    _state = _state.copyWith(
      selectedType: type,
      options: _applyFilters(_state.selectedOrigin, type),
    );
    notifyListeners();
  }

  void applyOriginFilter(String origin) {
    _state = _state.copyWith(
      selectedOrigin: origin,
      options: _applyFilters(origin, _state.selectedType),
    );
    notifyListeners();
  }

  // ── Filtering helpers ──────────────────────────────────────────────────────

  List<TransportOption> _applyFilters(String originQuery, String type) {
    var result = _allOptions;
    if (originQuery.isNotEmpty) {
      final q = originQuery.toLowerCase();
      result = result.where((o) => o.origin.toLowerCase().contains(q)).toList();
    }
    if (type != 'Todos') {
      result = result.where((o) => o.type == type).toList();
    }
    return result;
  }

  /// Convierte el nombre de ciudad detectado por geocoding en un término
  /// de búsqueda que coincida con los orígenes del catálogo.
  String mapCityToFilter(String detectedCity) {
    final city = detectedCity.toLowerCase();
    if (city.contains('méxico') ||
        city.contains('mexico') ||
        city.contains('cdmx') ||
        city.contains('ciudad de mex') ||
        city.contains('distrito federal')) {
      return 'México';
    }
    if (city.contains('oaxaca')) return 'Oaxaca';
    if (city.contains('veracruz') && !city.contains('coatz')) return 'Veracruz';
    if (city.contains('puebla')) return 'Puebla';
    if (city.contains('coatzacoalcos') || city.contains('minatitl')) {
      return 'Coatzacoalcos';
    }
    if (city.contains('villahermosa') || city.contains('tabasco')) {
      return 'Villahermosa';
    }
    if (city.contains('tuxtla')) return 'Tuxtla';
    if (city.contains('san cristóbal') ||
        city.contains('san cristobal') ||
        city.contains('cristóbal colón')) {
      return 'Cristóbal';
    }
    if (city.contains('guadalajara') || city.contains('jalisco')) {
      return 'Guadalajara';
    }
    if (city.contains('monterrey') || city.contains('nuevo león') ||
        city.contains('nuevo leon')) {
      return 'Monterrey';
    }
    return '';
  }
}
