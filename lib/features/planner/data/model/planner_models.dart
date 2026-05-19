import '../../domain/entities/planner_entities.dart';

class ItineraryActivityModel extends ItineraryActivity {
  const ItineraryActivityModel({
    required String time,
    required String name,
    required String place,
    required double estimatedCost,
  }) : super(
    time: time,
    name: name,
    place: place,
    estimatedCost: estimatedCost,
  );

  factory ItineraryActivityModel.fromJson(Map<String, dynamic> json) {
    return ItineraryActivityModel(
      time: json['time'] as String,
      name: json['name'] as String,
      place: json['place'] as String,
      estimatedCost: (json['estimatedCost'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'name': name,
      'place': place,
      'estimatedCost': estimatedCost,
    };
  }

  factory ItineraryActivityModel.fromEntity(ItineraryActivity entity) {
    return ItineraryActivityModel(
      time: entity.time,
      name: entity.name,
      place: entity.place,
      estimatedCost: entity.estimatedCost,
    );
  }
}

class ItineraryDayModel extends ItineraryDay {
  const ItineraryDayModel({
    required int dayNumber,
    required List<ItineraryActivity> activities,
  }) : super(
    dayNumber: dayNumber,
    activities: activities,
  );

  factory ItineraryDayModel.fromJson(Map<String, dynamic> json) {
    return ItineraryDayModel(
      dayNumber: json['dayNumber'] as int,
      activities: (json['activities'] as List<dynamic>)
          .map((a) => ItineraryActivityModel.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayNumber': dayNumber,
      'activities': activities
          .map((a) => (a as ItineraryActivityModel).toJson())
          .toList(),
    };
  }

  factory ItineraryDayModel.fromEntity(ItineraryDay entity) {
    return ItineraryDayModel(
      dayNumber: entity.dayNumber,
      activities: entity.activities,
    );
  }
}

class TripConfigModel extends TripConfig {
  const TripConfigModel({
    required String origin,
    required DateTime startDate,
    required DateTime endDate,
    required double budget,
    required List<String> interests,
  }) : super(
    origin: origin,
    startDate: startDate,
    endDate: endDate,
    budget: budget,
    interests: interests,
  );

  factory TripConfigModel.fromJson(Map<String, dynamic> json) {
    return TripConfigModel(
      origin: json['origin'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      budget: (json['budget'] as num).toDouble(),
      interests: List<String>.from(json['interests'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'origin': origin,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'budget': budget,
      'interests': interests,
    };
  }

  factory TripConfigModel.fromEntity(TripConfig entity) {
    return TripConfigModel(
      origin: entity.origin,
      startDate: entity.startDate,
      endDate: entity.endDate,
      budget: entity.budget,
      interests: entity.interests,
    );
  }
}
