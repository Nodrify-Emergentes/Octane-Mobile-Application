import 'dart:convert';
import 'package:octane_mobile/shared/client/api.client.dart';
import 'package:octane_mobile/vehicle_management/model/vehicle_create_request.dart';
import '../model/vehicle_model.dart';

class VehicleService {
  Future<List<Vehicle>> getVehiclesByOwnerId(int ownerId) async {
    final response = await ApiClient.get('vehicles/owner/$ownerId');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((e) => Vehicle.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to fetch vehicles: ${response.statusCode} - ${response.body}');
  }

  Future<Vehicle> getVehicleById(int vehicleId) async {
    final response = await ApiClient.get('vehicles/$vehicleId');

    if (response.statusCode == 200) {
      return Vehicle.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to fetch vehicle: ${response.statusCode} - ${response.body}');
  }

  Future<Vehicle> createVehicleForOwnerId(int ownerId, VehicleCreateRequest request) async {
    final response = await ApiClient.post('vehicles/$ownerId', body: request.toJson());

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Vehicle.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to create vehicle: ${response.statusCode} - ${response.body}');
  }
}

