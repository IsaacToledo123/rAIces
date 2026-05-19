import 'package:flutter/material.dart';

import '../../domain/usecases/get_featured_experiences.dart';
import '../states/home_state.dart';

class HomeViewModel extends ChangeNotifier {
  final GetFeaturedExperiences _getFeaturedExperiences;

  HomeState _state = const HomeState();

  HomeState get state => _state;

  HomeViewModel(this._getFeaturedExperiences);

  Future<void> loadExperiences() async {
    _state = _state.copyWith(status: HomeStatus.loading);
    notifyListeners();
    try {
      final experiences = await _getFeaturedExperiences();
      _state = _state.copyWith(
        status: HomeStatus.success,
        experiences: experiences,
      );
    } catch (e) {
      _state = _state.copyWith(
        status: HomeStatus.error,
        errorMessage: e.toString(),
      );
    }
    notifyListeners();
  }
}
