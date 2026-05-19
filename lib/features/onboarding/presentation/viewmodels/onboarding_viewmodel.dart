import 'package:flutter/material.dart';

import '../../domain/usecases/get_onboarding_slides.dart';
import '../states/onboarding_state.dart';

class OnboardingViewModel extends ChangeNotifier {
  final GetOnboardingSlides _getOnboardingSlides;

  OnboardingState _state = const OnboardingState();

  OnboardingState get state => _state;

  OnboardingViewModel(this._getOnboardingSlides);

  Future<void> loadSlides() async {
    _state = _state.copyWith(status: OnboardingStatus.loading);
    notifyListeners();
    try {
      final slides = await _getOnboardingSlides();
      _state = _state.copyWith(
        status: OnboardingStatus.success,
        slides: slides,
      );
    } catch (e) {
      _state = _state.copyWith(
        status: OnboardingStatus.error,
        errorMessage: e.toString(),
      );
    }
    notifyListeners();
  }

  void updateIndex(int index) {
    _state = _state.copyWith(currentIndex: index);
    notifyListeners();
  }
}
