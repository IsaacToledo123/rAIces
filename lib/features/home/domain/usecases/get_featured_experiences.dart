import '../entities/experience.dart';
import '../repository/i_home_repository.dart';

class GetFeaturedExperiences {
  final IHomeRepository repository;

  GetFeaturedExperiences(this.repository);

  Future<List<Experience>> call() => repository.getFeaturedExperiences();
}
