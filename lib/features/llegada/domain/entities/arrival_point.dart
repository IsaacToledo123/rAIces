import 'package:equatable/equatable.dart';

class LocalTransport extends Equatable {
  final String type; // 'taxi' | 'moto_taxi' | 'colectivo'
  final String label;
  final String priceRange;
  final String duration;
  final String? notes;

  const LocalTransport({
    required this.type,
    required this.label,
    required this.priceRange,
    required this.duration,
    this.notes,
  });

  @override
  List<Object?> get props => [type, label, priceRange];
}

class ArrivalPoint extends Equatable {
  final String id;
  final String name;
  final String city;
  final String type; // 'bus' | 'airport'
  final String address;
  final String mapsQuery;
  final String centerMapsQuery;
  final List<LocalTransport> transports;

  const ArrivalPoint({
    required this.id,
    required this.name,
    required this.city,
    required this.type,
    required this.address,
    required this.mapsQuery,
    required this.centerMapsQuery,
    required this.transports,
  });

  @override
  List<Object?> get props => [id];
}
