import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/recipe_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  /// Check if the backend is reachable
  Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.healthCheck}'),
            headers: ApiConfig.headers,
          )
          .timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Generate a recipe from the given ingredients
  Future<RecipeResponse> generateRecipe(RecipeRequest request) async {
    try {
      final uri =
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.generateRecipe}');

      final response = await http
          .post(
            uri,
            headers: ApiConfig.headers,
            body: jsonEncode(request.toJson()),
          )
          .timeout(ApiConfig.timeoutDuration);

      if (response.statusCode == 200) {
        final body = response.body.trim();
        final jsonData = jsonDecode(body);
        return RecipeResponse.fromJson(jsonData);
      } else {
        String errorMsg = 'Failed to generate recipe (${response.statusCode})';
        try {
          final errorBody = jsonDecode(response.body);
          errorMsg = errorBody['detail'] ?? errorMsg;
        } catch (_) {}
        throw ApiException(
          message: errorMsg,
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      throw ApiException(
        message: 'Network error: ${e.message}',
        statusCode: 0,
      );
    } on Exception catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw ApiException(
          message: 'The AI is taking too long to respond. Please try again with simpler ingredients.',
          statusCode: 408,
        );
      }
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Unexpected error: $e',
        statusCode: 0,
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
