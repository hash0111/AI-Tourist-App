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
    return response.data as Map<String, dynamic>;
  }
}