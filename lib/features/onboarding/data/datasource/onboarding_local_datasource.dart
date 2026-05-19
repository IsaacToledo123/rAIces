import '../../domain/entities/onboarding_slide.dart';

abstract class OnboardingLocalDatasource {
  Future<List<OnboardingSlide>> getSlides();
}

class OnboardingLocalDatasourceImpl implements OnboardingLocalDatasource {
  @override
  Future<List<OnboardingSlide>> getSlides() async {
    await Future.delayed(Duration(milliseconds: 500));
    return [
      OnboardingSlide(
        id: 1,
        title: 'Bienvenido a rAIces',
        description: 'Descubre el turismo comunitario del Istmo de Tehuantepec',
        imagePath: 'assets/images/onboarding_1.png',
      ),
      OnboardingSlide(
        id: 2,
        title: 'Experiencias Auténticas',
        description: 'Vive la cultura zapoteca de primera mano con nuestras comunidades',
        imagePath: 'assets/images/onboarding_2.png',
      ),
      OnboardingSlide(
        id: 3,
        title: 'Planifica tu Viaje',
        description: 'Crea tu itinerario perfecto con IA que entiende la región',
        imagePath: 'assets/images/onboarding_3.png',
      ),
    ];
  }
}
