import '../entities/onboarding_slide.dart';
import '../repository/i_onboarding_repository.dart';

class GetOnboardingSlides {
  final IOnboardingRepository repository;

  GetOnboardingSlides(this.repository);

  Future<List<OnboardingSlide>> call() => repository.getSlides();
}
