import 'package:openid_client/openid_client.dart';
import 'auth_provider.dart';

// This is the stub implementation that matches the new interface.
class AuthProviderImpl implements AuthProvider {
  AuthProviderImpl({required Client client, required List<String> scopes, required Uri redirectUri});

  @override
  Future<void> initiateLogin() => throw UnimplementedError('Platform not supported');

  @override
  Future<Credential?> processLogin() => throw UnimplementedError('Platform not supported');

  @override
  Future<void> logout(Credential credential) => throw UnimplementedError('Platform not supported');
}