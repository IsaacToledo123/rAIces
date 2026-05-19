class AiRecommendation {
  final String itemId;
  final String reason;
  final int score;

  const AiRecommendation({
    required this.itemId,
    required this.reason,
    required this.score,
  });

  factory AiRecommendation.fromJson(Map<String, dynamic> j) => AiRecommendation(
        itemId: j['id'] as String,
        reason: j['razon'] as String,
        score: (j['puntuacion'] as num).toInt(),
      );
}
