import 'package:openid_client/openid_client.dart';

// A more explicit contract for our platform-specific providers.
abstract class AuthProvider {
  // Just starts the login process (e.g., redirects the browser).
  Future<void> initiateLogin();

  // Checks for a credential after a redirect.
  Future<Credential?> processLogin();

  // Logs the user out.
  Future<void> logout(Credential credential);
}