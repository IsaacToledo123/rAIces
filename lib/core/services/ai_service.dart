import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_secrets.dart';
import '../models/ai_recommendation.dart';
import '../../features/catalog/domain/entities/catalog_item.dart';
import '../../features/planner/domain/entities/planner_entities.dart';

class AiService {
  static const _apiKey = AppSecrets.openAiKey;
  static const _model = 'gpt-4o-mini';

  // Responses API — soporta web_search_preview
  static const _responsesEndpoint = 'https://api.openai.com/v1/responses';
  // Chat Completions — soporta response_format json_object (JSON garantizado)
  static const _chatEndpoint = 'https://api.openai.com/v1/chat/completions';

  static const _headers = {
    'Authorization': 'Bearer $_apiKey',
    'Content-Type': 'application/json',
  };

  // ─── Itinerary (3 pasos: 2 búsquedas web específicas + JSON garantizado) ───

  Future<AiItineraryResult> generateItinerary(
    TripConfig config, {
    List<CatalogItem> pinnedItems = const [],
  }) async {
    final totalDays =
        config.endDate.difference(config.startDate).inDays + 1;
    final interests = config.interests.isEmpty
        ? 'Cultura, Gastronomía, Naturaleza'
        : config.interests.join(', ');
    final year = DateTime.now().year;

    // ── Paso 1a: precios de transporte (ADO/OCC) ─────────────────────────────
    String busContext = '';
    try {
      final busResp = await http.post(
        Uri.parse(_responsesEndpoint),
        headers: _headers,
        body: jsonEncode({
          'model': _model,
          'input':
              'Precio actual $year del boleto de autobús ADO o OCC '
              'desde ${config.origin} hasta Juchitán de Zaragoza o Tehuantepec, Oaxaca. '
              'Incluye clase (ejecutivo/de lujo), duración del viaje y precio exacto en pesos MXN.',
          'tools': [
            {'type': 'web_search_preview'},
          ],
          'max_output_tokens': 600,
        }),
      );
      if (busResp.statusCode == 200) {
        busContext = _parseResponsesText(jsonDecode(busResp.body));
      }
    } catch (_) {}

    // ── Paso 1b: precios de hospedaje en el Istmo ────────────────────────────
    String hotelContext = '';
    try {
      final hotelResp = await http.post(
        Uri.parse(_responsesEndpoint),
        headers: _headers,
        body: jsonEncode({
          'model': _model,
          'input':
              'Precio por noche de hoteles en Juchitán de Zaragoza y Tehuantepec, Oaxaca $year. '
              'Menciona nombres de hoteles económicos y de precio medio con su costo en pesos MXN por noche.',
          'tools': [
            {'type': 'web_search_preview'},
          ],
          'max_output_tokens': 600,
        }),
      );
      if (hotelResp.statusCode == 200) {
        hotelContext = _parseResponsesText(jsonDecode(hotelResp.body));
      }
    } catch (_) {}

    final StringBuffer priceBuffer = StringBuffer();
    if (busContext.isNotEmpty) {
      priceBuffer.writeln('TRANSPORTE (precios reales $year):');
      priceBuffer.writeln(busContext);
    }
    if (hotelContext.isNotEmpty) {
      priceBuffer.writeln('HOSPEDAJE (precios reales $year):');
      priceBuffer.writeln(hotelContext);
    }
    final priceContext = priceBuffer.toString().trim();

    // ── Paso 2: generar itinerario en JSON garantizado ───────────────────────
    final pinnedBlock = pinnedItems.isEmpty
        ? ''
        : 'EXPERIENCIAS QUE EL VIAJERO YA ELIGIÓ Y DEBEN APARECER EN EL ITINERARIO:\n'
            '${pinnedItems.map((i) => '- ${i.name} | ${i.category} | \$${i.price.toInt()} MXN | ${i.community}').join('\n')}\n'
            'Inclúyelas en días apropiados con su nombre exacto y precio real.\n';

    final prompt = '''Eres un experto en turismo comunitario del Istmo de Tehuantepec, Oaxaca, México.

${priceContext.isNotEmpty ? 'USA OBLIGATORIAMENTE ESTOS PRECIOS REALES ENCONTRADOS EN INTERNET:\n$priceContext\n\nIMPORTANTE: Los costos de transporte y hospedaje en el itinerario DEBEN coincidir con los precios reales de arriba.\n' : ''}${pinnedBlock.isNotEmpty ? '$pinnedBlock\n' : ''}
Genera un itinerario para:
- Origen: ${config.origin}
- Duración: $totalDays días (${_fmt(config.startDate)} al ${_fmt(config.endDate)})
- Presupuesto: \$${config.budget.toInt()} MXN por persona
- Intereses: $interests

Destino: Istmo de Tehuantepec — Juchitán de Zaragoza, Tehuantepec, Salina Cruz, comunidades zapotecas.

Devuelve ÚNICAMENTE este JSON (sin texto extra):
{
  "resumen": "descripción motivadora en 2-3 oraciones",
  "dias": [
    {
      "numero": 1,
      "titulo": "título del día",
      "actividades": [
        {
          "hora": "09:00",
          "nombre": "nombre actividad",
          "lugar": "lugar específico en el Istmo",
          "descripcion": "descripción en 1 oración",
          "costo_estimado": 150,
          "tipo": "gastronomia"
        }
      ],
      "costo_total_dia": 650
    }
  ],
  "consejos": ["consejo 1", "consejo 2", "consejo 3"],
  "presupuesto_usado": 2800
}

Reglas:
- OBLIGATORIO: usa los precios reales de transporte y hospedaje del bloque anterior
- OBLIGATORIO: incluye en el itinerario las experiencias elegidas por el viajero (si las hay)
- Si no hay precios reales, usa estimados razonables para la región
- Presupuesto total <= \$${config.budget.toInt()} MXN
- Día 1: llegada e instalación en el Istmo (incluye el costo real del autobús)
- Último día: preparación para regreso a ${config.origin} (incluye costo de regreso)
- El alojamiento debe aparecer cada noche con su costo real por noche
- Máximo 4 actividades por día (para que el JSON no sea demasiado largo)
- Tipos válidos: gastronomia, cultura, naturaleza, compras, transporte, alojamiento''';

    final resp = await http.post(
      Uri.parse(_chatEndpoint),
      headers: _headers,
      body: jsonEncode({
        'model': _model,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        'max_tokens': 4096,
        'temperature': 0.7,
        'response_format': {'type': 'json_object'},
      }),
    );

    if (resp.statusCode != 200) {
      final err = jsonDecode(resp.body);
      throw Exception(
          'Error OpenAI ${resp.statusCode}: '
          '${err['error']?['message'] ?? resp.body}');
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final text = data['choices'][0]['message']['content'] as String;
    return AiItineraryResult.fromJson(
        jsonDecode(text) as Map<String, dynamic>);
  }

  // ─── Recommendations (sin búsqueda web — catálogo local) ───────────────────

  Future<List<AiRecommendation>> getRecommendations({
    required List<String> interests,
    required double budget,
    required List<CatalogItem> items,
  }) async {
    if (interests.isEmpty || items.isEmpty) return [];

    final catalog = items
        .map((i) =>
            'ID:${i.id}|${i.name}|${i.category}|\$${i.price.toInt()} MXN|${i.community}')
        .join('\n');

    final prompt = '''Eres experto en turismo comunitario del Istmo de Tehuantepec.

Perfil del viajero:
- Intereses: ${interests.join(', ')}
- Presupuesto: \$${budget.toInt()} MXN

Catálogo disponible:
$catalog

Devuelve ÚNICAMENTE este JSON:
{"recomendaciones":[{"id":"1","razon":"razón específica en 1 oración","puntuacion":9}]}

Selecciona las 4 más relevantes ordenadas por relevancia.''';

    final resp = await http.post(
      Uri.parse(_chatEndpoint),
      headers: _headers,
      body: jsonEncode({
        'model': _model,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        'max_tokens': 400,
        'temperature': 0.4,
        'response_format': {'type': 'json_object'},
      }),
    );

    if (resp.statusCode != 200) {
      throw Exception('Error recomendaciones: ${resp.statusCode}');
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final text = data['choices'][0]['message']['content'] as String;
    final parsed = jsonDecode(text) as Map<String, dynamic>;
    final list =
        (parsed['recomendaciones'] as List).cast<Map<String, dynamic>>();
    return list.map(AiRecommendation.fromJson).toList();
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  // Extrae el texto del mensaje final en el output de la Responses API.
  // El array `output` puede tener items `web_search_call` antes del `message`.
  String _parseResponsesText(Map<String, dynamic> data) {
    final output = data['output'] as List<dynamic>;
    for (final item in output) {
      if (item['type'] == 'message') {
        final content = item['content'] as List<dynamic>;
        for (final c in content) {
          if (c['type'] == 'output_text') {
            return c['text'] as String;
          }
        }
      }
    }
    throw Exception('La IA no devolvió texto en la respuesta');
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
}
