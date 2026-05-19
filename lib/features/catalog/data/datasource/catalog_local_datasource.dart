import '../../domain/entities/catalog_item.dart';

abstract class CatalogLocalDatasource {
  Future<List<CatalogItem>> getItems();
  Future<List<CatalogItem>> filterByCategory(String category);
}

class CatalogLocalDatasourceImpl implements CatalogLocalDatasource {
  final List<CatalogItem> _mockItems = [
    CatalogItem(
      id: '1',
      name: 'Mercado Benito Juárez',
      category: 'Compras',
      community: 'Juchitán de Zaragoza',
      price: 0,
      rating: 4.8,
      description: 'Mercado tradicional zapoteco',
      includes: 'Acceso libre, guía opcional',
      schedule: '06:00 - 18:00',
    ),
    CatalogItem(
      id: '2',
      name: 'Laguna Superior',
      category: 'Naturaleza',
      community: 'Santo Domingo Tehuantepec',
      price: 350,
      rating: 4.9,
      description: 'Avistamiento de aves y kayak',
      includes: 'Kayak, chaleco salvavidas, guía experto',
      schedule: '07:00 - 17:00',
    ),
    CatalogItem(
      id: '3',
      name: 'Taller de Bordado',
      category: 'Cultura',
      community: 'San Blas Atempa',
      price: 400,
      rating: 4.7,
      description: 'Técnicas ancestrales de bordado zapoteco',
      includes: 'Materiales, instrucción 4 horas, obra para llevar',
      schedule: '09:00 - 13:00',
    ),
    CatalogItem(
      id: '4',
      name: 'Taller de Cocina Zapoteca',
      category: 'Cultura',
      community: 'Juchitán de Zaragoza',
      price: 450,
      rating: 4.8,
      description: 'Cocina tradicional del Istmo',
      includes: 'Ingredientes, recetas, almuerzo incluido',
      schedule: '10:00 - 15:00',
    ),
    CatalogItem(
      id: '5',
      name: 'Playa La Ventosa',
      category: 'Playa',
      community: 'Salina Cruz',
      price: 150,
      rating: 4.6,
      description: 'Playas vírgenes y deportes acuáticos',
      includes: 'Acceso a playa, equipo para actividades',
      schedule: '08:00 - 18:00',
    ),
    CatalogItem(
      id: '6',
      name: 'Cerro del Tigre',
      category: 'Naturaleza',
      community: 'Santo Domingo Tehuantepec',
      price: 250,
      rating: 4.9,
      description: 'Senderismo y vistas panorámicas',
      includes: 'Guía naturalista, agua, snacks',
      schedule: '06:00 - 14:00',
    ),
  ];

  @override
  Future<List<CatalogItem>> getItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockItems;
  }

  @override
  Future<List<CatalogItem>> filterByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockItems
        .where((item) => item.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
}
