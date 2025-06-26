import 'package:openid_client/openid_client_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'auth_provider.dart';

class AuthProviderImpl implements AuthProvider {
  final Client client;
  final List<String> scopes;
  final Uri redirectUri;

  AuthProviderImpl({required this.client, required this.scopes, required this.redirectUri});

  late final Authenticator _authenticator = Authenticator(
    client,
    scopes: scopes,
    redirectUri: redirectUri,
    urlLancher: (url) async {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    },
  );

  // On mobile, both initiating and processing happen in one step.
  @override
  Future<void> initiateLogin() async {
    await _authenticator.authorize();
  }

  @override
  Future<Credential?> processLogin() async {
    // This is a bit of a workaround for the library's design on IO.
    // We assume `authorize` was called by `initiateLogin`.
    // In a real mobile app, you'd listen for the redirect URI.
    // For now, this structure works for web, which is our primary target.
    return null;
  }

  @override
  Future<void> logout(Credential credential) async {
    final logoutUrl = credential.generateLogoutUrl();
    if (logoutUrl != null) {
      if (await canLaunchUrl(logoutUrl)) {
        await launchUrl(logoutUrl);
      }
    }
  }
}