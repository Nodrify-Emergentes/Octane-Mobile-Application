import 'dart:convert';

import 'package:octane_mobile/shared/client/api.client.dart';

import '../model/maintenance.dart';

class MaintenanceService {
  // GET /maintenance/{maintenanceId}
  Future<Maintenance> getMaintenanceById(int maintenanceId) async {
    final response = await ApiClient.get('maintenance/$maintenanceId');

    if (response.statusCode == 200) {
      return Maintenance.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to fetch maintenance: ${response.statusCode} - ${response.body}');
  }

  // GET /maintenance/mechanic/{mechanicId}
  Future<List<Maintenance>> getMaintenancesByMechanicId(int mechanicId) async {
    final response = await ApiClient.get('maintenance/mechanic/$mechanicId');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((e) => Maintenance.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to fetch maintenances by mechanic: ${response.statusCode} - ${response.body}');
  }

  Future<List<Maintenance>> getMaintenancesByOwnerId(int ownerId) async {
    final response = await ApiClient.get('maintenance/owner/$ownerId');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((e) => Maintenance.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to fetch maintenances by mechanic: ${response.statusCode} - ${response.body}');
  }

  // GET /maintenance/vehicle/{vehicleId}
  Future<List<Maintenance>> getMaintenancesByVehicleId(int vehicleId) async {
    final response = await ApiClient.get('maintenance/vehicle/$vehicleId');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((e) => Maintenance.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to fetch maintenances by vehicle: ${response.statusCode} - ${response.body}');
  }

  // POST /maintenance
  // Angular omitted: id, state, expense from payload. Accept a map without those fields.
  Future<Maintenance> createMaintenance(Map<String, dynamic> maintenanceData) async {
    final response = await ApiClient.post('maintenance', body: maintenanceData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Maintenance.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to create maintenance: ${response.statusCode} - ${response.body}');
  }

  // DELETE /maintenance/{maintenanceId}
  Future<void> deleteMaintenance(int maintenanceId) async {
    final response = await ApiClient.delete('maintenance/$maintenanceId');

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }
    throw Exception('Failed to delete maintenance: ${response.statusCode} - ${response.body}');
  }

  // PUT /maintenance/{maintenanceId} with body { "newStatus": <string> }
  Future<Maintenance> updateMaintenanceStatus(int maintenanceId, String newStatus) async {
    final response = await ApiClient.put(
      'maintenance/$maintenanceId',
      body: { 'newStatus': newStatus },
    );

    if (response.statusCode == 200) {
      return Maintenance.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to update maintenance status: ${response.statusCode} - ${response.body}');
  }

  // PUT /maintenance/{maintenanceId}/expense/assign/{expenseId}
  Future<Maintenance> assignExpenseToMaintenance(int maintenanceId, int expenseId) async {
    final response = await ApiClient.put('maintenance/$maintenanceId/expense/assign/$expenseId');

    if (response.statusCode == 200) {
      return Maintenance.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to assign expense to maintenance: ${response.statusCode} - ${response.body}');
  }
}

