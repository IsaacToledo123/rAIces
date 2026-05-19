import 'package:equatable/equatable.dart';

import '../../domain/entities/onboarding_slide.dart';

class OnboardingSlideModel extends OnboardingSlide {
  const OnboardingSlideModel({
    required int id,
    required String title,
    required String description,
    required String imagePath,
  }) : super(
    id: id,
    title: title,
    description: description,
    imagePath: imagePath,
  );

  factory OnboardingSlideModel.fromJson(Map<String, dynamic> json) {
    return OnboardingSlideModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
    };
  }

  factory OnboardingSlideModel.fromEntity(OnboardingSlide entity) {
    return OnboardingSlideModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      imagePath: entity.imagePath,
    );
  }

  @override
  List<Object?> get props => [id, title, description, imagePath];
}
