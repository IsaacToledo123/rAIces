import 'package:equatable/equatable.dart';

class OnboardingSlide extends Equatable {
  final int id;
  final String title;
  final String description;
  final String imagePath;

  const OnboardingSlide({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [id, title, description, imagePath];
}
