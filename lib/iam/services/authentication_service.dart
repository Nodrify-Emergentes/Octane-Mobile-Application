import 'package:octane_mobile/shared/client/api.client.dart';
import 'package:http/http.dart' as http;

import '../models/sign-in_request.dart';

class AuthenticationService {
  Future<http.Response> signIn(SignInRequest request) async {
    return await ApiClient.post('authentication/sign-in', body: request.toJson());
  }
}