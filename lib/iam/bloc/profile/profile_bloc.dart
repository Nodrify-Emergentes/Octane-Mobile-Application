import 'dart:convert';

import 'package:octane_mobile/iam/bloc/profile/profile_event.dart';
import 'package:octane_mobile/iam/bloc/profile/profile_state.dart';
import 'package:octane_mobile/iam/services/profile_service.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/profile_entity.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService profileService;

  ProfileBloc({ required this.profileService }) : super(ProfileInitial()) {
    on<FetchProfileEvent>(_onFetchProfile);
  }

  Future<void> _onFetchProfile(
    FetchProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final response = await profileService.getProfile();

      if (response.statusCode == 200) {
        final profile = Profile.fromJson(json.decode(response.body));
        emit(ProfileLoaded(profile));
      } else {
        emit(ProfileError('Failed to load profile'));
      }
    } catch (e) {
      emit(ProfileError('Error: $e'));
    }
  }
}