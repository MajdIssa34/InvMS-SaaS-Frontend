import 'package:invms_app/api/api_client.dart';

import '../models/api_key.dart';
class ApiKeyRepository {
  final ApiClient _apiClient;

  ApiKeyRepository(this._apiClient);

  Future<List<ApiKey>> getApiKeys() async {
    try {
      // Use the dio instance from our authenticated ApiClient
      final response = await _apiClient.dio.get('/developer/keys');

      // Assuming the API returns a list of JSON objects
      final List<dynamic> data = response.data;
      return data.map((json) => ApiKey.fromJson(json)).toList();

    } catch (e) {
      // Handle errors, maybe throw a custom exception
      print('Error fetching API keys: $e');
      rethrow;
    }
  }

  // You can add methods for create and delete here later
  // Future<ApiKey> createApiKey(String name) async { ... }
  // Future<void> deleteApiKey(String id) async { ... }
}