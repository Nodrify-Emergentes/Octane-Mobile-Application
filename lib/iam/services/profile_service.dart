import 'package:octane_mobile/shared/client/api.client.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  Future<http.Response> getProfile() async {
    return await ApiClient.get('profiles/user');
  }

  Future<http.Response> assignOwnerToAssignment(String assignmentCode, int ownerId) async {
    return await ApiClient.post('assignments/code/$assignmentCode/assign-owner/$ownerId', body: {
      'ownerId': ownerId,
    });
  }

  Future<http.Response> getOwnerId(String userId) async {
    return await ApiClient.get('users/owner');
  }
}