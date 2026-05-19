import '../../domain/entities/arrival_point.dart';

abstract class LlegadaDatasource {
  List<ArrivalPoint> getArrivalPoints();
}

class LlegadaDatasourceImpl implements LlegadaDatasource {
  @override
  List<ArrivalPoint> getArrivalPoints() {
    return const [
      ArrivalPoint(
        id: '1',
        name: 'Terminal ADO / OCC Juchitán',
        city: 'Juchitán de Zaragoza',
        type: 'bus',
        address: 'Blvd. Héroe de Nacozari, Juchitán de Zaragoza, Oaxaca',
        mapsQuery: 'Terminal ADO Juchitán de Zaragoza Oaxaca',
        centerMapsQuery: 'Centro de Juchitán de Zaragoza Oaxaca',
        transports: [
          LocalTransport(
            type: 'taxi',
            label: 'Taxi',
            priceRange: '\$40 – \$80 MXN',
            duration: '5 – 10 min',
            notes: 'Disponibles afuera de la terminal. Negocia el precio antes de subir.',
          ),
          LocalTransport(
            type: 'moto_taxi',
            label: 'Moto-taxi',
            priceRange: '\$15 – \$25 MXN',
            duration: '5 – 10 min',
            notes: 'Transporte típico del Istmo. Económico y rápido para distancias cortas.',
          ),
          LocalTransport(
            type: 'colectivo',
            label: 'Colectivo / Combi',
            priceRange: '\$8 – \$12 MXN',
            duration: '10 – 20 min',
            notes: 'Rutas fijas al centro. Pregunta en la terminal cuál pasa por tu destino.',
          ),
        ],
      ),
      ArrivalPoint(
        id: '2',
        name: 'Terminal ADO Tehuantepec',
        city: 'Santo Domingo Tehuantepec',
        type: 'bus',
        address: 'Av. Juárez, Santo Domingo Tehuantepec, Oaxaca',
        mapsQuery: 'Terminal ADO Tehuantepec Oaxaca',
        centerMapsQuery: 'Zócalo de Tehuantepec Oaxaca',
        transports: [
          LocalTransport(
            type: 'taxi',
            label: 'Taxi',
            priceRange: '\$35 – \$70 MXN',
            duration: '5 – 8 min',
          ),
          LocalTransport(
            type: 'moto_taxi',
            label: 'Moto-taxi',
            priceRange: '\$15 – \$25 MXN',
            duration: '5 – 8 min',
            notes: 'El transporte más popular en Tehuantepec.',
          ),
          LocalTransport(
            type: 'colectivo',
            label: 'Colectivo',
            priceRange: '\$7 – \$10 MXN',
            duration: '10 – 15 min',
          ),
        ],
      ),
      ArrivalPoint(
        id: '3',
        name: 'Terminal ADO Salina Cruz',
        city: 'Salina Cruz',
        type: 'bus',
        address: 'Av. Tampico, Salina Cruz, Oaxaca',
        mapsQuery: 'Terminal ADO Salina Cruz Oaxaca',
        centerMapsQuery: 'Centro de Salina Cruz Oaxaca',
        transports: [
          LocalTransport(
            type: 'taxi',
            label: 'Taxi',
            priceRange: '\$45 – \$90 MXN',
            duration: '8 – 12 min',
          ),
          LocalTransport(
            type: 'moto_taxi',
            label: 'Moto-taxi',
            priceRange: '\$20 – \$35 MXN',
            duration: '8 – 12 min',
          ),
          LocalTransport(
            type: 'colectivo',
            label: 'Colectivo',
            priceRange: '\$8 – \$12 MXN',
            duration: '15 – 25 min',
            notes: 'Rutas hacia el centro y puertos. Pregunta la ruta antes de abordar.',
          ),
        ],
      ),
      ArrivalPoint(
        id: '4',
        name: 'Aeropuerto de Ixtepec',
        city: 'Ciudad Ixtepec',
        type: 'airport',
        address: 'Carr. Ixtepec–Juchitán, Ciudad Ixtepec, Oaxaca',
        mapsQuery: 'Aeropuerto Ciudad Ixtepec Oaxaca',
        centerMapsQuery: 'Juchitán de Zaragoza Oaxaca',
        transports: [
          LocalTransport(
            type: 'taxi',
            label: 'Taxi',
            priceRange: '\$150 – \$250 MXN',
            duration: '20 – 30 min',
            notes: 'Principal opción desde el aeropuerto. ~25 km hasta Juchitán. No hay servicio de colectivo directo.',
          ),
          LocalTransport(
            type: 'moto_taxi',
            label: 'Moto-taxi al pueblo',
            priceRange: '\$20 – \$40 MXN',
            duration: '5 – 10 min',
            notes: 'Solo llega al centro de Ixtepec. Desde ahí toma colectivo a Juchitán.',
          ),
          LocalTransport(
            type: 'colectivo',
            label: 'Colectivo Ixtepec → Juchitán',
            priceRange: '\$15 – \$20 MXN',
            duration: '25 – 35 min',
            notes: 'Primero llega al centro de Ixtepec en moto-taxi, luego toma el colectivo en la terminal local.',
          ),
        ],
      ),
    ];
  }
}
