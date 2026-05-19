import '../../domain/entities/experience.dart';

abstract class HomeLocalDatasource {
  Future<List<Experience>> getFeaturedExperiences();
}

class HomeLocalDatasourceImpl implements HomeLocalDatasource {
  @override
  Future<List<Experience>> getFeaturedExperiences() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Experience(
        id: '1',
        name: 'Mercado Benito Juárez',
        category: 'Compras',
        price: 0,
        rating: 4.8,
        community: 'Juchitán de Zaragoza',
        description:
            'Descubre los colores y aromas del mercado tradicional zapoteco más emblemático del Istmo.',
        imageUrl: 'assets/images/mercado.png',
      ),
      Experience(
        id: '2',
        name: 'Laguna Superior',
        category: 'Naturaleza',
        price: 350,
        rating: 4.9,
        community: 'Santo Domingo Tehuantepec',
        description:
            'Avistamiento de aves y kayak en la laguna más hermosa de la región.',
        imageUrl: 'assets/images/laguna.png',
      ),
      Experience(
        id: '3',
        name: 'Taller de Bordado Istmeño',
        category: 'Cultura',
        price: 400,
        rating: 4.7,
        community: 'San Blas Atempa',
        description:
            'Aprende las técnicas ancestrales de bordado zapoteco con maestras artesanas.',
        imageUrl: 'assets/images/bordado.png',
      ),
      Experience(
        id: '4',
        name: 'Playa La Ventosa',
        category: 'Playa',
        price: 150,
        rating: 4.6,
        community: 'Salina Cruz',
        description:
            'Playas vírgenes con aguas cristalinas y vientos ideales para deportes acuáticos.',
        imageUrl: 'assets/images/playa.png',
      ),
    ];
  }
}
