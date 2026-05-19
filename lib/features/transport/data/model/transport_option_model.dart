import '../../domain/entities/transport_option.dart';

class TransportOptionModel extends TransportOption {
  const TransportOptionModel({
    required super.id,
    required super.company,
    required super.type,
    required super.origin,
    required super.destination,
    required super.price,
    required super.duration,
    required super.departureTimes,
    super.includes,
    required super.bookingUrl,
    required super.mapsOriginQuery,
    required super.mapsDestQuery,
  });

  factory TransportOptionModel.fromJson(Map<String, dynamic> json) {
    return TransportOptionModel(
      id: json['id'] as String,
      company: json['company'] as String,
      type: json['type'] as String,
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      price: (json['price'] as num).toDouble(),
      duration: json['duration'] as String,
      departureTimes: json['departure_times'] as String,
      includes: json['includes'] as String?,
      bookingUrl: json['booking_url'] as String,
      mapsOriginQuery: json['maps_origin_query'] as String,
      mapsDestQuery: json['maps_dest_query'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'company': company,
        'type': type,
        'origin': origin,
        'destination': destination,
        'price': price,
        'duration': duration,
        'departure_times': departureTimes,
        'includes': includes,
        'booking_url': bookingUrl,
        'maps_origin_query': mapsOriginQuery,
        'maps_dest_query': mapsDestQuery,
      };
}
