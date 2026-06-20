import 'dart:convert';

import 'package:octane_mobile/shared/client/api.client.dart';
import 'package:octane_mobile/vehicle_management/model/vehicle_model.dart';

class ModelService {
  Future<List<Model>> getAllModels() async {
      final response = await ApiClient.get("models");

      if(response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data.map((e) => Model.fromJson(e as Map<String, dynamic>)).toList();
      }

      throw Exception('Failed to fetch models: ${response.statusCode}');
  }

  Future<List<String>> getAllBrands() async {
    final response = await ApiClient.get("models/brands");

    if(response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((e) => e as String).toList();
    }

    throw Exception('Failed to fetch brands: ${response.statusCode}');
  }
}