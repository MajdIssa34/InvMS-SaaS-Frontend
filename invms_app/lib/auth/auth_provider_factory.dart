import 'package:invms_app/auth/auth_provider_web.dart';
import 'package:openid_client/openid_client.dart';
import 'auth_provider.dart';

// Conditional exports choose the correct file at compile time.
export 'auth_provider_stub.dart'
    if (dart.library.io) 'auth_provider_io.dart'
    if (dart.library.html) 'auth_provider_web.dart';

// This function can now correctly instantiate `AuthProviderImpl` because
// the name is the same in all conditionally exported files.
AuthProvider createAuthProvider(Client client, List<String> scopes, Uri redirectUri) {
  return AuthProviderImpl(client: client, scopes: scopes, redirectUri: redirectUri);
}