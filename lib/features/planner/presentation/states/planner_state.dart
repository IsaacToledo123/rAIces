import 'package:equatable/equatable.dart';

import '../../domain/entities/planner_entities.dart';

enum PlannerStatus { idle, loading, success, error }

class PlannerState extends Equatable {
  final PlannerStatus status;
  final List<ItineraryDay> itinerary;
  final double? budgetProgress;
  final TripConfig? tripConfig;
  final String? errorMessage;
  final String? aiSummary;
  final List<String> aiTips;

  const PlannerState({
    this.status = PlannerStatus.idle,
    this.itinerary = const [],
    this.budgetProgress,
    this.tripConfig,
    this.errorMessage,
    this.aiSummary,
    this.aiTips = const [],
  });

  PlannerState copyWith({
    PlannerStatus? status,
    List<ItineraryDay>? itinerary,
    double? budgetProgress,
    TripConfig? tripConfig,
    String? errorMessage,
    String? aiSummary,
    List<String>? aiTips,
  }) {
    return PlannerState(
      status: status ?? this.status,
      itinerary: itinerary ?? this.itinerary,
      budgetProgress: budgetProgress ?? this.budgetProgress,
      tripConfig: tripConfig ?? this.tripConfig,
      errorMessage: errorMessage ?? this.errorMessage,
      aiSummary: aiSummary ?? this.aiSummary,
      aiTips: aiTips ?? this.aiTips,
    );
  }

  @override
  List<Object?> get props =>
      [status, itinerary, budgetProgress, tripConfig, errorMessage, aiSummary, aiTips];
}
