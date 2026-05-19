import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_secrets.dart';
import '../../features/planner/domain/entities/planner_entities.dart';

class ClaudeService {
  static const _apiKey = AppSecrets.anthropicKey;
  static const _model = 'claude-haiku-4-5-20251001';
  static const _endpoint = 'https://api.anthropic.com/v1/messages';

  Future<AiItineraryResult> generateItinerary(TripConfig config) async {
    final totalDays = config.endDate.difference(config.startDate).inDays + 1;
    final interests = config.interests.isEmpty
        ? 'Cultura, Gastronomía, Naturaleza'
        : config.interests.join(', ');

    final prompt = '''Eres un experto en turismo comunitario del Istmo de Tehuantepec, Oaxaca, México.

Genera un itinerario de viaje personalizado para:
- Origen: ${config.origin}
- Duración: $totalDays días (${_fmt(config.startDate)} al ${_fmt(config.endDate)})
- Presupuesto total: \$${config.budget.toInt()} MXN por persona
- Intereses: $interests

El destino es el Istmo de Tehuantepec: Juchitán de Zaragoza, Tehuantepec, Salina Cruz y comunidades zapotecas.

Responde ÚNICAMENTE con un objeto JSON válido (sin markdown, sin bloques de código, sin texto extra):
{
  "resumen": "descripción motivadora del viaje en 2-3 oraciones",
  "dias": [
    {
      "numero": 1,
      "titulo": "título del día",
      "actividades": [
        {
          "hora": "09:00",
          "nombre": "nombre de la actividad",
          "lugar": "lugar específico en el Istmo",
          "descripcion": "descripción breve de 1 oración",
          "costo_estimado": 150,
          "tipo": "gastronomia"
        }
      ],
      "costo_total_dia": 650
    }
  ],
  "consejos": ["consejo práctico 1", "consejo práctico 2", "consejo práctico 3"],
  "presupuesto_usado": 2800
}

Reglas importantes:
- Actividades reales y específicas del Istmo de Tehuantepec
- Presupuesto total <= \$${config.budget.toInt()} MXN
- Día 1: llegada e instalación en el Istmo
- Último día: tiempo para regreso a ${config.origin}
- Entre 3 y 5 actividades por día
- Tipos válidos: gastronomia, cultura, naturaleza, compras, transporte, alojamiento
- Solo JSON, sin texto adicional''';

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'x-api-key': _apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'model': _model,
        'max_tokens': 4096,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode != 200) {
      final err = jsonDecode(response.body);
      throw Exception(
          'Error Claude ${response.statusCode}: ${err['error']?['message'] ?? response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final text = (data['content'] as List).first['text'] as String;
    final jsonStr = _extractJson(text);
    return AiItineraryResult.fromJson(
        jsonDecode(jsonStr) as Map<String, dynamic>);
  }

  String _extractJson(String text) {
    // Intento directo
    try {
      jsonDecode(text);
      return text;
    } catch (_) {}

    // Extrae entre llaves si Claude añadió texto alrededor
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start != -1 && end > start) return text.substring(start, end + 1);

    throw Exception('La IA devolvió una respuesta inesperada');
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
}
