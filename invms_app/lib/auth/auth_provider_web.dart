import 'package:openid_client/openid_client_browser.dart';
import 'auth_provider.dart';

class AuthProviderImpl implements AuthProvider {
  final Client client;
  final List<String> scopes;
  final Uri redirectUri;

  AuthProviderImpl({required this.client, required this.scopes, required this.redirectUri});

  late final Authenticator _authenticator = Authenticator(client, scopes: scopes);

  // On web, this just redirects the page.
  @override
  Future<void> initiateLogin() async {
    _authenticator.authorize();
  }

  // On web, this completes after the page has reloaded from the redirect.
  @override
  Future<Credential?> processLogin() async {
    return await _authenticator.credential;
  }

  @override
  Future<void> logout(Credential credential) async {
    _authenticator.logout();
  }
}