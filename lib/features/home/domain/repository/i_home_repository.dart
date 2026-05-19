import '../entities/experience.dart';

abstract class IHomeRepository {
  Future<List<Experience>> getFeaturedExperiences();
}
