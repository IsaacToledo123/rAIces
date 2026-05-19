import '../../domain/entities/onboarding_slide.dart';
import '../../domain/repository/i_onboarding_repository.dart';
import '../datasource/onboarding_local_datasource.dart';

class OnboardingRepositoryImpl implements IOnboardingRepository {
  final OnboardingLocalDatasource localDatasource;

  OnboardingRepositoryImpl(this.localDatasource);

  @override
  Future<List<OnboardingSlide>> getSlides() async {
    return await localDatasource.getSlides();
  }
}
