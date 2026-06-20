import 'dart:convert';
import 'package:octane_mobile/shared/client/api.client.dart';
import 'package:octane_mobile/vehicle_wellness/data/datasource/token_datasource.dart';
import 'package:http/http.dart' as http;
import '../models/wellness_metric_model.dart';

class WellnessMetricDataSource {
  final String baseUrl = ApiClient.baseUrl;
  //final String baseUrl= 'http://10.0.2.2:8080/api/v1/' ;
  //final String baseUrl= 'https://backend-web-services-1.onrender.com/api/v1/' ;
  final String basePath = 'metrics';

  Future<String?> _getToken() async {
    try {
      return await TokenDataSource.getToken();
    } catch (e) {
      print('Error obteniendo token: $e');
      return null;
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<WellnessMetricModel> createWellnessMetric(WellnessMetricModel metric) async {
    final response = await http.post(
      Uri.parse('$baseUrl$basePath'),
      headers: await _getHeaders(),
      body: json.encode(metric.toJson()),
    );

    if (response.statusCode == 201) {
      return WellnessMetricModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error creating wellness metric: ${response.statusCode} - ${response.body}');
    }
  }

  Future<WellnessMetricModel> updateWellnessMetric(int id, WellnessMetricModel metric) async {
    final response = await http.put(
      Uri.parse('$baseUrl$basePath/$id'),
      headers: await _getHeaders(),
      body: json.encode(metric.toJson()),
    );

    if (response.statusCode == 200) {
      return WellnessMetricModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error updating wellness metric: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> deleteWellnessMetric(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$basePath/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Error deleting wellness metric: ${response.statusCode} - ${response.body}');
    }
  }

  Future<WellnessMetricModel> getWellnessMetricById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl$basePath/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return WellnessMetricModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error fetching wellness metric: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<WellnessMetricModel>> getAllWellnessMetrics() async {
    final response = await http.get(
      Uri.parse('$baseUrl$basePath'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => WellnessMetricModel.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching all wellness vehicle_wellness: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<WellnessMetricModel>> getWellnessMetricsByVehicleId(int vehicleId) async {
    print('🔍 [DEBUG] Getting wellness metrics for vehicle: $vehicleId');

    final headers = await _getHeaders();
    print('🔍 [DEBUG] Headers: $headers');

    final url = '$baseUrl$basePath/vehicle/$vehicleId';
    print('🔍 [DEBUG] URL: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print('🔍 [DEBUG] Response status: ${response.statusCode}');
    print('🔍 [DEBUG] Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      print('🔍 [DEBUG] Parsed ${jsonList.length} metrics');
      return jsonList.map((json) => WellnessMetricModel.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      print('🔍 [DEBUG] No metrics found (404)');
      return [];
    } else {
      print('❌ [DEBUG] Error: ${response.statusCode} - ${response.body}');
      throw Exception('Error fetching vehicle metrics: ${response.statusCode} - ${response.body}');
    }
  }
}