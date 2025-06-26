import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// Initial state, before we've checked for a stored credential
class AuthInitial extends AuthState {}

// State when the user is successfully authenticated
class AuthAuthenticated extends AuthState {}

// State when the user is not authenticated
class AuthUnauthenticated extends AuthState {}

// State for when an auth process (login/logout) is in progress
class AuthLoading extends AuthState {}

// State for when an error occurs
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}