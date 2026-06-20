import 'dart:convert';
import 'package:octane_mobile/shared/client/api.client.dart';
import '../models/user.dart';

class UserService {
  Future<User> getUserById(int userId) async {
    final response = await ApiClient.get('users/$userId');

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to fetch user: ${response.statusCode} - ${response.body}');
  }
}

