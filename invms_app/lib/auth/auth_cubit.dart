import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial());

  // checkAuthentication now calls the non-looping getInitialCredential
  Future<void> checkAuthentication() async {
    emit(AuthLoading());
    try {
      final credential = await _authService.getInitialCredential();
      if (credential != null) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError('Failed to check authentication status: $e'));
    }
  }

  // login now ONLY calls the method that initiates the login flow.
  Future<void> login() async {
    emit(AuthLoading());
    try {
      await _authService.login();
      // No state change here, the redirect will handle it.
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _authService.logout();
    } finally {
      // Always ensure we end up in the unauthenticated state after logout.
      emit(AuthUnauthenticated());
    }
  }
}