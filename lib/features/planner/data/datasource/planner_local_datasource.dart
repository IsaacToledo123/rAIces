import '../../domain/entities/planner_entities.dart';

abstract class PlannerLocalDatasource {
  Future<List<ItineraryDay>> generateItinerary(TripConfig config);
  Future<double> calculateBudgetProgress(
      List<ItineraryDay> itinerary, double budget);
}

class PlannerLocalDatasourceImpl implements PlannerLocalDatasource {
  @override
  Future<List<ItineraryDay>> generateItinerary(TripConfig config) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final numberOfDays =
        config.endDate.difference(config.startDate).inDays + 1;

    return List.generate(
      numberOfDays,
      (index) => ItineraryDay(
        dayNumber: index + 1,
        activities: [
          ItineraryActivity(
            time: '09:00',
            name: 'Desayuno local',
            place: 'Comedor comunitario',
            estimatedCost: 80,
          ),
          ItineraryActivity(
            time: '11:00',
            name: 'Experiencia principal',
            place: 'Centro del Istmo',
            estimatedCost: 350,
          ),
          ItineraryActivity(
            time: '14:00',
            name: 'Almuerzo',
            place: 'Restaurante local',
            estimatedCost: 120,
          ),
          ItineraryActivity(
            time: '16:00',
            name: 'Actividad complementaria',
            place: 'Comunidad',
            estimatedCost: 200,
          ),
        ],
      ),
    );
  }

  @override
  Future<double> calculateBudgetProgress(
      List<ItineraryDay> itinerary, double budget) async {
    await Future.delayed(const Duration(milliseconds: 300));

    double totalCost = 0;
    for (final day in itinerary) {
      for (final activity in day.activities) {
        totalCost += activity.estimatedCost;
      }
    }

    return (totalCost / budget) * 100;
  }
}
