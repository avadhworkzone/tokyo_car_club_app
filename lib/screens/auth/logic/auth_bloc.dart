import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokyo_car_club/screens/auth/data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.signIn(event.email, event.password);
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user =
        await repository.signUp(event.name, event.email, event.password);
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
