import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:invms_app/auth/auth_provider.dart';
import 'package:openid_client/openid_client.dart';
import 'auth_provider_factory.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final AuthProvider _provider;
  final Client _client;

  // Private constructor
  AuthService._(this._provider, this._client);

  // Public factory for creation
  static Future<AuthService> create() async {
    const String keycloakUrl =
        'https://auth.invms.xyz/realms/advanced-inventory-management-system';
    const String clientId = 'inventory-client';
    const List<String> scopes = ['openid', 'profile', 'email'];
    final Uri redirectUri = Uri.parse('https://api.invms.xyz/');
    
    final issuer = await Issuer.discover(Uri.parse(keycloakUrl));
    final client = Client(issuer, clientId);
    final provider = createAuthProvider(client, scopes, redirectUri);
    return AuthService._(provider, client);
  }

  // This method ONLY starts the login flow.
  Future<void> login() async {
    await _provider.initiateLogin();
  }

  Future<void> logout() async {
    try {
      final credential = await getCredentialFromStorage();
      if (credential != null) {
        await _provider.logout(credential);
      }
    } finally {
      await _secureStorage.delete(key: 'credential');
    }
  }

  // This method checks storage OR a redirect, but does NOT start a new login.
  Future<Credential?> getInitialCredential() async {
    // First, try to get from storage.
    var credential = await getCredentialFromStorage();
    if (credential != null) return credential;

    // If not in storage, check if we have a credential from a redirect.
    credential = await _provider.processLogin();
    if (credential != null) {
      // If we got one, save it for next time.
      await _secureStorage.write(
        key: 'credential',
        value: json.encode(credential.toJson()),
      );
    }
    return credential;
  }

  Future<Credential?> getCredentialFromStorage() async {
    final rawCredential = await _secureStorage.read(key: 'credential');
    if (rawCredential != null) {
      final json = jsonDecode(rawCredential);
      return _client.createCredential(
        accessToken: json['access_token'],
        tokenType: json['token_type'],
        refreshToken: json['refresh_token'],
        idToken: json['id_token'],
      );
    }
    return null;
  }
}
