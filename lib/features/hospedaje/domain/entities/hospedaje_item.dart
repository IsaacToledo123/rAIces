import 'package:equatable/equatable.dart';

class HospedajeItem extends Equatable {
  final String id;
  final String name;
  final String type; // 'hotel' | 'posada' | 'casa_huespedes'
  final String location;
  final double pricePerNight;
  final double rating;
  final String description;
  final List<String> amenities;
  final String address;
  final String bookingUrl;
  final String? mapsUrl;

  const HospedajeItem({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.pricePerNight,
    required this.rating,
    required this.description,
    required this.amenities,
    required this.address,
    required this.bookingUrl,
    this.mapsUrl,
  });

  @override
  List<Object?> get props =>
      [id, name, type, location, pricePerNight, rating];
}
