import '../entities/planner_entities.dart';
import '../repository/i_planner_repository.dart';

class CalculateBudgetProgress {
  final IPlannerRepository repository;

  CalculateBudgetProgress(this.repository);

  Future<double> call(List<ItineraryDay> itinerary, double budget) =>
      repository.calculateBudgetProgress(itinerary, budget);
}
