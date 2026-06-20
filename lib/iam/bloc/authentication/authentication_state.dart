import 'package:octane_mobile/iam/models/sign-in_response.dart';

abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class SignInSuccess extends AuthenticationState {
  final SignInResponse response;

  SignInSuccess(this.response);
}

class AuthenticationFailure extends AuthenticationState {
  final String error;

  AuthenticationFailure(this.error);
}