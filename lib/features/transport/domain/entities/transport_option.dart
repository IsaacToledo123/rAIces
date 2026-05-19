import 'package:equatable/equatable.dart';

class TransportOption extends Equatable {
  final String id;
  final String company;
  final String type; // 'bus' | 'flight_bus'
  final String origin;
  final String destination;
  final double price;
  final String duration;
  final String departureTimes;
  final String? includes;
  final String bookingUrl;
  final String mapsOriginQuery;
  final String mapsDestQuery;

  const TransportOption({
    required this.id,
    required this.company,
    required this.type,
    required this.origin,
    required this.destination,
    required this.price,
    required this.duration,
    required this.departureTimes,
    this.includes,
    required this.bookingUrl,
    required this.mapsOriginQuery,
    required this.mapsDestQuery,
  });

  @override
  List<Object?> get props => [id, company, type, origin, destination, price];
}
