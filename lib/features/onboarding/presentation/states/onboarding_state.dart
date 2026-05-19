import 'package:equatable/equatable.dart';

import '../../domain/entities/onboarding_slide.dart';

enum OnboardingStatus { idle, loading, success, error }

class OnboardingState extends Equatable {
  final OnboardingStatus status;
  final List<OnboardingSlide> slides;
  final String? errorMessage;
  final int currentIndex;

  const OnboardingState({
    this.status = OnboardingStatus.idle,
    this.slides = const [],
    this.errorMessage,
    this.currentIndex = 0,
  });

  OnboardingState copyWith({
    OnboardingStatus? status,
    List<OnboardingSlide>? slides,
    String? errorMessage,
    int? currentIndex,
  }) {
    return OnboardingState(
      status: status ?? this.status,
      slides: slides ?? this.slides,
      errorMessage: errorMessage ?? this.errorMessage,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [status, slides, errorMessage, currentIndex];
}
