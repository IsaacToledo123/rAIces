import 'package:flutter/foundation.dart';

import '../models/ai_recommendation.dart';
import '../../features/catalog/domain/entities/catalog_item.dart';
import '../../features/planner/domain/entities/planner_entities.dart';

class UserPreferencesService extends ChangeNotifier {
  List<String> _interests = [];
  double _budget = 3000;

  List<ItineraryDay> _activeItinerary = [];
  TripConfig? _activeConfig;
  String? _activeSummary;
  double? _activeBudgetProgress;

  List<AiRecommendation> _recommendations = [];
  bool _loadingRecs = false;

  List<CatalogItem> _pinnedItems = [];

  // ── Getters ───────────────────────────────────────────────────────────────
  List<String> get interests => _interests;
  double get budget => _budget;
  bool get hasInterests => _interests.isNotEmpty;

  bool get hasTrip => _activeItinerary.isNotEmpty;
  List<ItineraryDay> get activeItinerary => _activeItinerary;
  TripConfig? get activeConfig => _activeConfig;
  String? get activeSummary => _activeSummary;
  double? get activeBudgetProgress => _activeBudgetProgress;

  List<AiRecommendation> get recommendations => _recommendations;
  bool get loadingRecs => _loadingRecs;
  bool get hasRecommendations => _recommendations.isNotEmpty;

  List<CatalogItem> get pinnedItems => List.unmodifiable(_pinnedItems);
  bool get hasPinnedItems => _pinnedItems.isNotEmpty;
  bool isPinned(String id) => _pinnedItems.any((i) => i.id == id);

  // ── Mutations ─────────────────────────────────────────────────────────────

  void savePreferences({
    required List<String> interests,
    required double budget,
  }) {
    _interests = List.from(interests);
    _budget = budget;
    _recommendations = []; // invalidate cached recs on profile change
    notifyListeners();
  }

  void saveActiveTrip({
    required List<ItineraryDay> days,
    required TripConfig config,
    required String? summary,
    required double? budgetProgress,
  }) {
    _activeItinerary = days;
    _activeConfig = config;
    _activeSummary = summary;
    _activeBudgetProgress = budgetProgress;
    notifyListeners();
  }

  void setRecommendations(List<AiRecommendation> recs) {
    _recommendations = recs;
    _loadingRecs = false;
    notifyListeners();
  }

  void setLoadingRecs(bool v) {
    _loadingRecs = v;
    notifyListeners();
  }

  void clearTrip() {
    _activeItinerary = [];
    _activeConfig = null;
    _activeSummary = null;
    _activeBudgetProgress = null;
    notifyListeners();
  }

  void addPinnedItem(CatalogItem item) {
    if (!_pinnedItems.any((i) => i.id == item.id)) {
      _pinnedItems = [..._pinnedItems, item];
      notifyListeners();
    }
  }

  void removePinnedItem(String id) {
    _pinnedItems = _pinnedItems.where((i) => i.id != id).toList();
    notifyListeners();
  }

  void reset() {
    _interests = [];
    _budget = 3000;
    _activeItinerary = [];
    _activeConfig = null;
    _activeSummary = null;
    _activeBudgetProgress = null;
    _recommendations = [];
    _loadingRecs = false;
    _pinnedItems = [];
    notifyListeners();
  }
}
