import 'dart:convert';
import 'package:octane_mobile/shared/client/api.client.dart';
import '../model/assignment.dart';

class AssignmentService {
  /// Get all assignments associated to the specified mechanic filtered by status
  ///
  /// [mechanicId] - The ID of the mechanic
  /// [status] - The status to filter by
  /// Returns a Future of Assignment list
  Future<List<Assignment>> getAssignmentsByMechanicIdAndStatus(
    int mechanicId,
    String status,
  ) async {
    final response = await ApiClient.get('mechanic/$mechanicId/assignments/$status');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((e) => Assignment.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception(
      'Failed to fetch assignments by mechanic and status: ${response.statusCode} - ${response.body}',
    );
  }
}

