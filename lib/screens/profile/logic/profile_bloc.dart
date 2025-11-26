import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        await Future.delayed(const Duration(seconds: 1));
        final profile = {
          'name': 'John Doe',
          'email': 'john.doe@email.com',
          'phone': '+91 9876543210',
          'image': 'assets/images/user.png',
        };
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        await Future.delayed(const Duration(seconds: 2));
        emit(ProfileUpdated());
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}