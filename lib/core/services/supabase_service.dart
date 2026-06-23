import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getPlaces() async {
    return await _client.from('places').select();
  }

  Future<List<Map<String, dynamic>>> getStories(String placeId) async {
    return await _client
        .from('stories')
        .select()
        .eq('place_id', placeId);
  }

  Future<List<Map<String, dynamic>>> getFoods() async {
    return await _client.from('foods').select();
  }

  Future<List<Map<String, dynamic>>> getClothes() async {
    return await _client.from('clothes').select();
  }

  Future<List<Map<String, dynamic>>> getWords() async {
    return await _client.from('words').select();
  }

  Future<Map<String, dynamic>> getAIPlan({
    required String query,
    required double budget,
  }) async {
    final response = await _client.functions.invoke(
      'ai_planner',
      body: {'query': query, 'budget': budget},
    );
    final data = response.data as Map<String, dynamic>;
    if (data['success'] == true) {
      return data['plan'] as Map<String, dynamic>;
    }
    throw Exception(data['error'] ?? 'AI planner failed');
  }

  Future<Map<String, dynamic>> enrichContent({
    required String type,
    required String name,
    required String baseDescription,
  }) async {
    final response = await _client.functions.invoke(
      'enrich_content',
      body: {'type': type, 'name': name, 'baseDescription': baseDescription},
    );
    final data = response.data as Map<String, dynamic>;
    if (data['success'] == true) {
      return data['story'] as Map<String, dynamic>;
    }
    throw Exception(data['error'] ?? 'Content enrichment failed');
  }

  Future<Map<String, dynamic>> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final response = await _client.functions.invoke(
      'translate',
      body: {'text': text, 'sourceLanguage': sourceLanguage, 'targetLanguage': targetLanguage},
    );
    final data = response.data as Map<String, dynamic>;
    if (data['success'] == true) {
      return data;
    }
    throw Exception(data['error'] ?? 'Translation failed');
  }
}
