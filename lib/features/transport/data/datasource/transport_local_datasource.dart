import '../../domain/entities/transport_option.dart';

abstract class TransportLocalDatasource {
  Future<List<TransportOption>> getOptions();
}

class TransportLocalDatasourceImpl implements TransportLocalDatasource {
  @override
  Future<List<TransportOption>> getOptions() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const [
      // ── Ciudad de México ──────────────────────────────────────────────────
      TransportOption(
        id: '1',
        company: 'ADO GL',
        type: 'bus',
        origin: 'Ciudad de México (TAPO)',
        destination: 'Juchitán de Zaragoza',
        price: 980,
        duration: '12h 30min',
        departureTimes: '18:00 • 20:00 • 22:00',
        includes: 'Asiento reclinable 160°, WiFi, USB, servicio a bordo',
        bookingUrl: 'https://www.ado.com.mx',
        mapsOriginQuery: 'Terminal TAPO Ciudad de Mexico',
        mapsDestQuery: 'Juchitán de Zaragoza, Oaxaca, México',
      ),
      TransportOption(
        id: '2',
        company: 'ADO Platino',
        type: 'bus',
        origin: 'Ciudad de México (TAPO)',
        destination: 'Juchitán de Zaragoza',
        price: 1480,
        duration: '12h 30min',
        departureTimes: '20:00',
        includes: 'Asiento cama 180°, WiFi premium, alimentos y bebidas, amenity kit',
        bookingUrl: 'https://www.ado.com.mx',
        mapsOriginQuery: 'Terminal TAPO Ciudad de Mexico',
        mapsDestQuery: 'Juchitán de Zaragoza, Oaxaca, México',
      ),
      TransportOption(
        id: '3',
        company: 'OCC',
        type: 'bus',
        origin: 'Ciudad de México (TAPO)',
        destination: 'Juchitán de Zaragoza',
        price: 810,
        duration: '13h 00min',
        departureTimes: '16:00 • 19:00 • 21:30',
        includes: 'Asiento reclinable, aire acondicionado',
        bookingUrl: 'https://www.ado.com.mx',
        mapsOriginQuery: 'Terminal TAPO Ciudad de Mexico',
        mapsDestQuery: 'Juchitán de Zaragoza, Oaxaca, México',
      ),
      TransportOption(
        id: '4',
        company: 'Vuelo + ADO',
        type: 'flight_bus',
        origin: 'Ciudad de México (AICM)',
        destination: 'Juchitán vía Oaxaca',
        price: 1820,
        duration: '~5h total',
        departureTimes: 'Vuelo ~1h • Traslado + Bus ~4h',
        includes: 'Vuelo CDMX→Oaxaca (VivaAerobus/Aeroméxico) + ADO Oaxaca→Juchitán. Precio estimado.',
        bookingUrl: 'https://www.vivaaerobus.com',
        mapsOriginQuery: 'Aeropuerto Internacional de la Ciudad de Mexico AICM Terminal 1',
        mapsDestQuery: 'Aeropuerto Internacional Xoxocotlan Oaxaca',
      ),

      // ── Oaxaca ───────────────────────────────────────────────────────────
      TransportOption(
        id: '5',
        company: 'ADO',
        type: 'bus',
        origin: 'Oaxaca (Central de Autobuses)',
        destination: 'Juchitán de Zaragoza',
        price: 376,
        duration: '4h 30min',
        departureTimes: '06:00 • 09:00 • 12:00 • 15:00 • 18:00',
        includes: 'Asiento reclinable, aire acondicionado',
        bookingUrl: 'https://www.ado.com.mx',
        mapsOriginQuery: 'Central de Autobuses de Oaxaca',
        mapsDestQuery: 'Juchitán de Zaragoza, Oaxaca, México',
      ),

      // ── Veracruz ─────────────────────────────────────────────────────────
      TransportOption(
        id: '6',
        company: 'ADO',
        type: 'bus',
        origin: 'Veracruz (Central ADO)',
        destination: 'Juchitán de Zaragoza',
        price: 690,
        duration: '8h 00min',
        departureTimes: '08:00 • 22:00',
        includes: 'Asiento reclinable, aire acondicionado',
        bookingUrl: 'https://www.ado.com.mx',
        mapsOriginQuery: 'Central de Autobuses ADO Veracruz',
        mapsDestQuery: 'Juchitán de Zaragoza, Oaxaca, México',
      ),

      // ── Puebla ───────────────────────────────────────────────────────────
      TransportOption(
        id: '7',
        company: 'ADO',
        type: 'bus',
        origin: 'Puebla (CAPU)',
        destination: 'Juchitán de Zaragoza',
        price: 560,
        duration: '10h 00min',
        departureTimes: '18:00 • 20:30',
        includes: 'Asiento reclinable, aire acondicionado, USB',
        bookingUrl: 'https://www.ado.com.mx',
        mapsOriginQuery: 'CAPU Central de Autobuses de Puebla',
        mapsDestQuery: 'Juchitán de Zaragoza, Oaxaca, México',
      ),

      // ── Coatzacoalcos ────────────────────────────────────────────────────
      TransportOption(
        id: '8',
        company: 'ADO',
        type: 'bus',
        origin: 'Coatzacoalcos (Terminal ADO)',
        destination: 'Juchitán de Zaragoza',
        price: 260,
        duration: '3h 00min',
        departureTimes: '06:30 • 09:00 • 12:30 • 16:00 • 19:00 • 22:00',
        includes: 'Asiento reclinable, aire acondicionado',
        bookingUrl: 'https://www.ado.com.mx',
        mapsOriginQuery: 'Terminal ADO Coatzacoalcos Veracruz',
        mapsDestQuery: 'Juchitán de Zaragoza, Oaxaca, México',
      ),

      // ── Villahermosa ─────────────────────────────────────────────────────
      TransportOption(
        id: '9',
        company: 'ADO',
        type: 'bus',
        origin: 'Villahermosa (CAXA)',
        destination: 'Juchitán de Zaragoza',
        price: 395,
        duration: '6h 00min',
        departureTimes: '08:00 • 14:00 • 22:00',
        includes: 'Asiento reclinable, aire acondicionado',
        bookingUrl: 'https://www.ado.com.mx',
        mapsOriginQuery: 'CAXA Central de Autobuses de Villahermosa Tabasco',
        mapsDestQuery: 'Juchitán de Zaragoza, Oaxaca, México',
      ),

      // ── Tuxtla Gutiérrez ─────────────────────────────────────────────────
      TransportOption(
        id: '10',
        company: 'OCC',
        type: 'bus',
        origin: 'Tuxtla Gutiérrez (Central Cristóbal Colón)',
        destination: 'Juchitán de Zaragoza',
        price: 320,
        duration: '4h 00min',
        departureTimes: '07:00 • 10:00 • 14:00 • 18:00',
        includes: 'Asiento reclinable, aire acondicionado',
        bookingUrl: 'https://www.ado.com.mx',
        mapsOriginQuery: 'Central Cristóbal Colón Tuxtla Gutiérrez Chiapas',
        mapsDestQuery: 'Juchitán de Zaragoza, Oaxaca, México',
      ),

      // ── San Cristóbal de las Casas ────────────────────────────────────────
      TransportOption(
        id: '11',
        company: 'OCC',
        type: 'bus',
        origin: 'San Cristóbal de las Casas (Cristóbal Colón)',
        destination: 'Juchitán de Zaragoza',
        price: 410,
        duration: '5h 30min',
        departureTimes: '08:00 • 14:00',
        includes: 'Asiento reclinable, aire acondicionado',
        bookingUrl: 'https://www.ado.com.mx',
        mapsOriginQuery: 'Central ADO OCC San Cristóbal de las Casas Chiapas',
        mapsDestQuery: 'Juchitán de Zaragoza, Oaxaca, México',
      ),

      // ── Guadalajara ──────────────────────────────────────────────────────
      TransportOption(
        id: '12',
        company: 'ADO GL',
        type: 'bus',
        origin: 'Guadalajara (Central Nueva)',
        destination: 'Juchitán de Zaragoza',
        price: 1150,
        duration: '16h 00min',
        departureTimes: '16:00',
        includes: 'Asiento reclinable 160°, WiFi, USB, servicio a bordo',
        bookingUrl: 'https://www.ado.com.mx',
        mapsOriginQuery: 'Central Nueva de Autobuses Guadalajara Jalisco',
        mapsDestQuery: 'Juchitán de Zaragoza, Oaxaca, México',
      ),

      // ── Monterrey ────────────────────────────────────────────────────────
      TransportOption(
        id: '13',
        company: 'Vuelo + ADO',
        type: 'flight_bus',
        origin: 'Monterrey (Aeropuerto MTY)',
        destination: 'Juchitán vía Oaxaca',
        price: 2400,
        duration: '~6h total',
        departureTimes: 'Vuelo ~2h • Traslado + Bus ~4h',
        includes: 'Vuelo MTY→Oaxaca + ADO Oaxaca→Juchitán. Precio estimado.',
        bookingUrl: 'https://www.vivaaerobus.com',
        mapsOriginQuery: 'Aeropuerto Internacional General Mariano Escobedo Monterrey',
        mapsDestQuery: 'Aeropuerto Internacional Xoxocotlan Oaxaca',
      ),
    ];
  }
}
