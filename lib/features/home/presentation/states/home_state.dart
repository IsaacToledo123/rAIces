import 'package:equatable/equatable.dart';

import '../../domain/entities/experience.dart';

enum HomeStatus { idle, loading, success, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Experience> experiences;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.idle,
    this.experiences = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Experience>? experiences,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      experiences: experiences ?? this.experiences,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, experiences, errorMessage];
}
