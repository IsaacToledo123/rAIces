import '../entities/planner_entities.dart';
import '../repository/i_planner_repository.dart';

class GenerateItinerary {
  final IPlannerRepository repository;

  GenerateItinerary(this.repository);

  Future<List<ItineraryDay>> call(TripConfig config) =>
      repository.generateItinerary(config);
}
