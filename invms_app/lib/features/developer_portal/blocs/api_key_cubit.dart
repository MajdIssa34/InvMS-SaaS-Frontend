import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invms_app/models/api_key_repository.dart';
import 'api_key_state.dart';

class ApiKeyCubit extends Cubit<ApiKeyState> {
  final ApiKeyRepository _apiKeyRepository;

  ApiKeyCubit(this._apiKeyRepository) : super(ApiKeyInitial());

  Future<void> fetchApiKeys() async {
    try {
      emit(ApiKeyLoading());
      final apiKeys = await _apiKeyRepository.getApiKeys();
      emit(ApiKeyLoaded(apiKeys));
    } catch (e) {
      emit(ApiKeyError('Failed to fetch API keys: $e'));
    }
  }

  // We will add create and revoke methods here later.
}