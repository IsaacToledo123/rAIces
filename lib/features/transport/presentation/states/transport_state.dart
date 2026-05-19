import 'package:equatable/equatable.dart';

import '../../domain/entities/transport_option.dart';

enum TransportStatus { idle, loading, success, error }

class TransportState extends Equatable {
  final TransportStatus status;
  final List<TransportOption> options;
  final String selectedType;
  final String selectedOrigin;
  final String? errorMessage;

  const TransportState({
    this.status = TransportStatus.idle,
    this.options = const [],
    this.selectedType = 'Todos',
    this.selectedOrigin = '',
    this.errorMessage,
  });

  TransportState copyWith({
    TransportStatus? status,
    List<TransportOption>? options,
    String? selectedType,
    String? selectedOrigin,
    String? errorMessage,
  }) {
    return TransportState(
      status: status ?? this.status,
      options: options ?? this.options,
      selectedType: selectedType ?? this.selectedType,
      selectedOrigin: selectedOrigin ?? this.selectedOrigin,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, options, selectedType, selectedOrigin, errorMessage];
}
