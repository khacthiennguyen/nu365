import 'package:dio/dio.dart';
import 'package:nu365/core/data/runtime/runtime_memory_storage.dart';

/// Interceptor that adds Authorization header to requests
class AuthInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      // Check if the endpoint should be authenticated
      final bool shouldAuthenticate = _shouldAuthenticateEndpoint(options.path);

      if (shouldAuthenticate) {
        // Try to get the token from RuntimeMemoryStorage safely
        final String? token = _getAccessToken();

        // Add Authorization header if token exists
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }

      // Continue with the request
      return handler.next(options);
    } catch (e) {
      // If there's an error getting the token, just continue without it
      print('Error in AuthInterceptor: $e');
      return handler.next(options);
    }
  }

  /// Returns the access token safely from storage
  String? _getAccessToken() {
    try {

      final dynamic session = RuntimeMemoryStorage.get('session');
      if (session is Map<String, dynamic> &&
          session.containsKey('accessToken')) {
        return session['accessToken'] as String?;
      }

      return null;
    } catch (e) {
      print('Error getting access token: $e');
      return null;
    }
  }

  /// Determines if the endpoint should have authentication
  bool _shouldAuthenticateEndpoint(String path) {
    // List of endpoints that don't need authentication
    final List<String> publicEndpoints = [
      'auth/login',
      'auth/register',
      // Add other public endpoints here
    ];

    // Check if the path is in the public endpoints list
    for (final endpoint in publicEndpoints) {
      if (path.contains(endpoint)) {
        return false;
      }
    }

    return true;
  }
}
