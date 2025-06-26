import 'package:dio/dio.dart';
import '../auth/auth_service.dart';

class ApiClient {
  final Dio _dio;
  final AuthService _authService;

  ApiClient(this._authService) : _dio = Dio() {
    // Set the base URL for all API requests
    // This points to your local NGINX proxy which routes to the API Gateway
    _dio.options.baseUrl = 'http://localhost:8181/api';

    // Add our custom interceptor to the Dio instance
    _dio.interceptors.add(_AuthInterceptor(_authService, _dio));
  }

  // You can now add methods for making API calls, for example:
  // Future<Response> getApiKeys() => _dio.get('/developer/keys');
  // Future<Response> createApiKey(String name) => _dio.post('/developer/keys', data: {'name': name});

  // We'll expose the dio instance directly for now to use in repositories
  Dio get dio => _dio;
}

// This is the interceptor that will add the auth token to every request
class _AuthInterceptor extends Interceptor {
  final AuthService _authService;
  final Dio _dio; // Pass dio to handle token refresh later

  _AuthInterceptor(this._authService, this._dio);

  // In lib/api/api_client.dart, inside the _AuthInterceptor class

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get the stored credential
    final credential = await _authService.getCredentialFromStorage();

    if (credential != null) {
      // THE FIX IS HERE:
      // Get the token response from the credential first.
      final token = await credential.getTokenResponse();

      // Now we can safely access the accessToken from the token response.
      if (token.accessToken != null) {
        options.headers['Authorization'] = 'Bearer ${token.accessToken}';
        print('--> Adding Auth Token to request for: ${options.path}');
      }
    } else {
      print('--> No Auth Token found for request to: ${options.path}');
    }

    // Continue with the request
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Here is where you would handle 401 Unauthorized errors,
    // which indicates an expired token.
    // For now, we will just pass the error along.
    // In a future step, we would try to refresh the token here.
    if (err.response?.statusCode == 401) {
      print('!!! API returned 401 Unauthorized. Token may be expired.');
      // 1. Lock the dio instance to prevent other requests
      // 2. Try to refresh the token using authService
      // 3. If successful, update the request header and retry it
      // 4. If failed, log the user out.
    }
    return handler.next(err);
  }
}
