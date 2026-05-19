import 'package:equatable/equatable.dart';

import '../../domain/entities/hospedaje_item.dart';

enum HospedajeStatus { idle, loading, success, error }

class HospedajeState extends Equatable {
  final HospedajeStatus status;
  final List<HospedajeItem> items;
  final String selectedLocation;
  final String? errorMessage;

  const HospedajeState({
    this.status = HospedajeStatus.idle,
    this.items = const [],
    this.selectedLocation = 'Todos',
    this.errorMessage,
  });

  HospedajeState copyWith({
    HospedajeStatus? status,
    List<HospedajeItem>? items,
    String? selectedLocation,
    String? errorMessage,
  }) {
    return HospedajeState(
      status: status ?? this.status,
      items: items ?? this.items,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, items, selectedLocation, errorMessage];
}
