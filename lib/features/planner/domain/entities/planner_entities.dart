import 'package:equatable/equatable.dart';

class ItineraryActivity extends Equatable {
  final String time;
  final String name;
  final String place;
  final double estimatedCost;
  final String? description;
  final String? tipo;

  const ItineraryActivity({
    required this.time,
    required this.name,
    required this.place,
    required this.estimatedCost,
    this.description,
    this.tipo,
  });

  factory ItineraryActivity.fromJson(Map<String, dynamic> j) =>
      ItineraryActivity(
        time: j['hora'] as String? ?? '00:00',
        name: j['nombre'] as String? ?? '',
        place: j['lugar'] as String? ?? '',
        estimatedCost: (j['costo_estimado'] as num?)?.toDouble() ?? 0,
        description: j['descripcion'] as String?,
        tipo: j['tipo'] as String?,
      );

  @override
  List<Object?> get props => [time, name, place, estimatedCost];
}

class ItineraryDay extends Equatable {
  final int dayNumber;
  final String? title;
  final List<ItineraryActivity> activities;
  final double? dailyCost;

  const ItineraryDay({
    required this.dayNumber,
    this.title,
    required this.activities,
    this.dailyCost,
  });

  factory ItineraryDay.fromJson(Map<String, dynamic> j) => ItineraryDay(
        dayNumber: j['numero'] as int? ?? 0,
        title: j['titulo'] as String?,
        activities: (j['actividades'] as List<dynamic>? ?? [])
            .map((a) => ItineraryActivity.fromJson(a as Map<String, dynamic>))
            .toList(),
        dailyCost: (j['costo_total_dia'] as num?)?.toDouble(),
      );

  @override
  List<Object?> get props => [dayNumber, activities];
}

class TripConfig extends Equatable {
  final String origin;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final List<String> interests;

  const TripConfig({
    required this.origin,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.interests,
  });

  @override
  List<Object?> get props => [origin, startDate, endDate, budget, interests];
}

class AiItineraryResult extends Equatable {
  final String summary;
  final List<ItineraryDay> days;
  final List<String> tips;
  final double totalCost;

  const AiItineraryResult({
    required this.summary,
    required this.days,
    required this.tips,
    required this.totalCost,
  });

  factory AiItineraryResult.fromJson(Map<String, dynamic> j) =>
      AiItineraryResult(
        summary: j['resumen'] as String? ?? '',
        days: (j['dias'] as List<dynamic>? ?? [])
            .map((d) => ItineraryDay.fromJson(d as Map<String, dynamic>))
            .toList(),
        tips: (j['consejos'] as List<dynamic>? ?? [])
            .map((c) => c.toString())
            .toList(),
        totalCost: (j['presupuesto_usado'] as num?)?.toDouble() ?? 0,
      );

  @override
  List<Object?> get props => [summary, days, tips, totalCost];
}
