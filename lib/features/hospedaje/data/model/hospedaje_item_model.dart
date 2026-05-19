import '../../domain/entities/hospedaje_item.dart';

class HospedajeItemModel extends HospedajeItem {
  const HospedajeItemModel({
    required super.id,
    required super.name,
    required super.type,
    required super.location,
    required super.pricePerNight,
    required super.rating,
    required super.description,
    required super.amenities,
    required super.address,
    required super.bookingUrl,
    super.mapsUrl,
  });

  factory HospedajeItemModel.fromJson(Map<String, dynamic> json) {
    return HospedajeItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      location: json['location'] as String,
      pricePerNight: (json['price_per_night'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      description: json['description'] as String,
      amenities: List<String>.from(json['amenities'] as List),
      address: json['address'] as String,
      bookingUrl: json['booking_url'] as String,
      mapsUrl: json['maps_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'location': location,
        'price_per_night': pricePerNight,
        'rating': rating,
        'description': description,
        'amenities': amenities,
        'address': address,
        'booking_url': bookingUrl,
        'maps_url': mapsUrl,
      };
}
