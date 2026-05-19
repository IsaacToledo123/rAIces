import '../entities/planner_entities.dart';

abstract class IPlannerRepository {
  Future<List<ItineraryDay>> generateItinerary(TripConfig config);
  Future<double> calculateBudgetProgress(List<ItineraryDay> itinerary, double budget);
}
