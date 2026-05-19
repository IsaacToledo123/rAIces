import '../entities/onboarding_slide.dart';

abstract class IOnboardingRepository {
  Future<List<OnboardingSlide>> getSlides();
}
