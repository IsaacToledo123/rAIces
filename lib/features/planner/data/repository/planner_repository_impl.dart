import '../../domain/entities/planner_entities.dart';
import '../../domain/repository/i_planner_repository.dart';
import '../datasource/planner_local_datasource.dart';

class PlannerRepositoryImpl implements IPlannerRepository {
  final PlannerLocalDatasource localDatasource;

  PlannerRepositoryImpl(this.localDatasource);

  @override
  Future<List<ItineraryDay>> generateItinerary(TripConfig config) async {
    return await localDatasource.generateItinerary(config);
  }

  @override
  Future<double> calculateBudgetProgress(
      List<ItineraryDay> itinerary, double budget) async {
    return await localDatasource.calculateBudgetProgress(itinerary, budget);
  }
}
