import 'package:octane_mobile/iam/models/sign-in_request.dart';

abstract class AuthenticationEvent {}

class SignInEvent extends AuthenticationEvent {
  final SignInRequest request;

  SignInEvent({required this.request});
}

class SignOutEvent extends AuthenticationEvent {}

class ResetAuthenticationStateEvent extends AuthenticationEvent {}
