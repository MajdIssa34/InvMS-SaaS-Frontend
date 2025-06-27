import 'package:equatable/equatable.dart';
import '../../../models/api_key.dart';

abstract class ApiKeyState extends Equatable {
  const ApiKeyState();

  @override
  List<Object> get props => [];
}

class ApiKeyInitial extends ApiKeyState {}

class ApiKeyLoading extends ApiKeyState {}

class ApiKeyLoaded extends ApiKeyState {
  final List<ApiKey> apiKeys;

  const ApiKeyLoaded(this.apiKeys);

  @override
  List<Object> get props => [apiKeys];
}

class ApiKeyError extends ApiKeyState {
  final String message;

  const ApiKeyError(this.message);

  @override
  List<Object> get props => [message];
}