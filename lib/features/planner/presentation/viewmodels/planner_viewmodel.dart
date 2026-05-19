import 'package:flutter/material.dart';

import '../../../../core/services/ai_service.dart';
import '../../../../features/catalog/domain/entities/catalog_item.dart';
import '../../domain/entities/planner_entities.dart';
import '../../domain/usecases/calculate_budget_progress.dart';
import '../states/planner_state.dart';

class PlannerViewModel extends ChangeNotifier {
  final AiService _claude;
  final CalculateBudgetProgress _calculateBudgetProgress;

  PlannerState _state = const PlannerState();
  PlannerState get state => _state;

  PlannerViewModel(this._claude, this._calculateBudgetProgress);


  Future<void> generateItinerary(
    TripConfig config, {
    List<CatalogItem> pinnedItems = const [],
  }) async {
    _state = _state.copyWith(
      status: PlannerStatus.loading,
      tripConfig: config,
    );
    notifyListeners();

    try {
      final result = await _claude.generateItinerary(
        config,
        pinnedItems: pinnedItems,
      );
      final budgetProgress =
          await _calculateBudgetProgress(result.days, config.budget);

      _state = _state.copyWith(
        status: PlannerStatus.success,
        itinerary: result.days,
        budgetProgress: budgetProgress,
        aiSummary: result.summary,
        aiTips: result.tips,
      );
    } catch (e) {
      _state = _state.copyWith(
        status: PlannerStatus.error,
        errorMessage: e.toString(),
      );
    }
    notifyListeners();
  }

  void reset() {
    _state = const PlannerState();
    notifyListeners();
  }
}
