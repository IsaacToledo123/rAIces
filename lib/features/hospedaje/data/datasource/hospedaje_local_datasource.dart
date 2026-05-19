import '../../domain/entities/hospedaje_item.dart';

abstract class HospedajeLocalDatasource {
  Future<List<HospedajeItem>> getItems();
}

class HospedajeLocalDatasourceImpl implements HospedajeLocalDatasource {
  @override
  Future<List<HospedajeItem>> getItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      HospedajeItem(
        id: '1',
        name: 'Hotel Calli',
        type: 'hotel',
        location: 'Tehuantepec',
        pricePerNight: 580,
        rating: 4.2,
        description:
            'Hotel céntrico con alberca y restaurante típico istmeño. Decoración con toques zapotecas y atención personalizada. Ideal para explorar el centro histórico de Tehuantepec.',
        amenities: ['WiFi', 'Alberca', 'Restaurante', 'Estacionamiento', 'AC'],
        address: 'Calzada del Ejército s/n, Santo Domingo Tehuantepec, Oax.',
        bookingUrl:
            'https://www.booking.com/searchresults.es.html?ss=Tehuantepec+Oaxaca+Mexico&checkin=2026-06-01&checkout=2026-06-05',
        mapsUrl: 'https://maps.google.com/?q=Hotel+Calli+Tehuantepec+Oaxaca',
      ),
      HospedajeItem(
        id: '2',
        name: 'Hotel Donají',
        type: 'hotel',
        location: 'Juchitán',
        pricePerNight: 450,
        rating: 4.0,
        description:
            'Ubicado a pasos del Mercado Benito Juárez. Habitaciones cómodas con baño privado, televisión y acceso fácil a los principales atractivos de Juchitán.',
        amenities: ['WiFi', 'AC', 'TV', 'Agua caliente', 'Estacionamiento'],
        address: '16 de Septiembre No. 7, Juchitán de Zaragoza, Oax.',
        bookingUrl:
            'https://www.booking.com/searchresults.es.html?ss=Juchitan+de+Zaragoza+Oaxaca+Mexico',
        mapsUrl: 'https://maps.google.com/?q=Hotel+Donají+Juchitán+Oaxaca',
      ),
      HospedajeItem(
        id: '3',
        name: 'Posada del Istmo',
        type: 'posada',
        location: 'Juchitán',
        pricePerNight: 320,
        rating: 4.5,
        description:
            'Posada familiar con ambiente auténtico zapoteco. Las anfitrionas locales comparten tradiciones y preparan desayunos con recetas típicas del Istmo. La experiencia más genuina.',
        amenities: ['WiFi', 'Desayuno incluido', 'Patio', 'Agua caliente'],
        address: 'Av. Efraín González Luna, Juchitán de Zaragoza, Oax.',
        bookingUrl:
            'https://www.booking.com/searchresults.es.html?ss=Juchitan+de+Zaragoza+Oaxaca+Mexico',
        mapsUrl: 'https://maps.google.com/?q=Juchitán+de+Zaragoza+Oaxaca',
      ),
      HospedajeItem(
        id: '4',
        name: 'Hotel Guiechati',
        type: 'hotel',
        location: 'Juchitán',
        pricePerNight: 650,
        rating: 4.3,
        description:
            '"Lugar de descanso" en zapoteco. El hotel más completo de Juchitán: alberca, restaurante de cocina regional y salones de eventos. A 5 min del centro.',
        amenities: ['WiFi', 'Alberca', 'Restaurante', 'Bar', 'Estacionamiento', 'AC'],
        address: 'Blvd. Héroe de Nacozari, Juchitán de Zaragoza, Oax.',
        bookingUrl:
            'https://www.booking.com/searchresults.es.html?ss=Juchitan+de+Zaragoza+Oaxaca+Mexico',
        mapsUrl: 'https://maps.google.com/?q=Hotel+Guiechati+Juchitán',
      ),
      HospedajeItem(
        id: '5',
        name: 'Casa La Ventosa',
        type: 'casa_huespedes',
        location: 'Salina Cruz',
        pricePerNight: 280,
        rating: 4.6,
        description:
            'Casa de huéspedes a 5 min de Playa La Ventosa. Ideal para surfistas y amantes del mar. Jardín con hamacas, cocina compartida y ambiente muy relajado.',
        amenities: ['WiFi', 'Cocina compartida', 'Jardín', 'Hamacas', 'Bicicletas'],
        address: 'Colonia Jardines, Salina Cruz, Oax.',
        bookingUrl:
            'https://www.booking.com/searchresults.es.html?ss=Salina+Cruz+Oaxaca+Mexico',
        mapsUrl: 'https://maps.google.com/?q=Salina+Cruz+Oaxaca+Mexico',
      ),
      HospedajeItem(
        id: '6',
        name: 'Hotel Puerto Cruz',
        type: 'hotel',
        location: 'Salina Cruz',
        pricePerNight: 520,
        rating: 4.1,
        description:
            'Moderno hotel frente al puerto. Vista al Pacífico, acceso cercano a La Ventosa y transporte incluido los fines de semana hacia las playas.',
        amenities: ['WiFi', 'Vista al mar', 'AC', 'Estacionamiento', 'Desayuno'],
        address: 'Blvd. Puerto Ángel s/n, Salina Cruz, Oax.',
        bookingUrl:
            'https://www.booking.com/searchresults.es.html?ss=Salina+Cruz+Oaxaca+Mexico',
        mapsUrl: 'https://maps.google.com/?q=Salina+Cruz+Oaxaca+Mexico',
      ),
    ];
  }
}
