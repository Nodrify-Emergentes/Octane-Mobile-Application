import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:octane_mobile/iam/bloc/authentication/authentication_event.dart';
import 'package:bloc/bloc.dart';
import 'package:octane_mobile/iam/bloc/authentication/authentication_state.dart';
import 'package:octane_mobile/iam/services/authentication_service.dart';
import 'package:octane_mobile/iam/services/profile_service.dart';

import '../../../shared/client/api.client.dart';
import '../../models/sign-in_response.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationService authenticationService;
  final ProfileService profileService;

  AuthenticationBloc({
    required this.authenticationService,
    required this.profileService
  }) : super(AuthenticationInitial()) {
    on<SignInEvent>(_onSignInEvent);
    on<SignOutEvent>(_onSignOutEvent);
    on<ResetAuthenticationStateEvent>(_onResetAuthenticationStateEvent);
  }

  void _onSignInEvent(SignInEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final response = await authenticationService.signIn(event.request);

      if (response.statusCode == 200) {
        final signInResponse = SignInResponse.fromJson(
          json.decode(response.body),
        );
        ApiClient.updateToken(signInResponse.token);
        // This is saved for future app launches
        await prefs.setString('auth_token', signInResponse.token);

        final profileResponse = await profileService.getProfile();
        if (profileResponse.statusCode == 200) {
          final roleIdResponse = await profileService.getOwnerId(signInResponse.id.toString());
          if (roleIdResponse.statusCode == 200) {
            final jsonResponse = json.decode(roleIdResponse.body);
            final roleId = jsonResponse['ownerId'] as int;
            await prefs.setInt('role_id', roleId);
          } else {
            emit(AuthenticationFailure('Error while obtaining role ID: ${roleIdResponse.statusCode}'));
            return;
          }

          emit(SignInSuccess(signInResponse));
        } else if (profileResponse.statusCode == 404) {
          emit(AuthenticationFailure('Profile was not found.'));
        } else {
          emit(AuthenticationFailure('Error while obtaining profile details: ${profileResponse.statusCode}'));
        }

      } else {
        emit(AuthenticationFailure('Sign in failed: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AuthenticationFailure('Error: $e'));
    }
  }

  Future<void> _onSignOutEvent(SignOutEvent event, Emitter<AuthenticationState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove('auth_token');
      await prefs.remove('role_id');

      ApiClient.resetToken();

      emit(AuthenticationInitial());
    } catch (e) {
      emit(AuthenticationFailure('Error during sign out: $e'));
    }
  }


  void _onResetAuthenticationStateEvent(ResetAuthenticationStateEvent event, Emitter<AuthenticationState> emit) {
    emit(AuthenticationInitial());

  }

}