import 'package:dio/dio.dart';
import 'package:catalog_app/core/errors/exceptions.dart';

mixin RemoteDataSourceMixin {
  /// A mixin that provides a generic handler for performing remote data source
  /// operations with standardized error handling.
  ///
  /// Implement this mixin in your concrete remote data source classes (e.g., RemoteUserDataSourceImpl)
  /// to wrap your API calls and catch common network/server exceptions,
  /// throwing appropriate custom exceptions defined in your core layer.
  Future<T> handleRemoteCall<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      if (e.response != null) {
        switch (e.response!.statusCode) {
          case 401: // Unauthorized
          case 403: // Forbidden
            throw UnauthorizedException(message: e.response!.statusMessage ?? 'Authentication failed.');
          case 404: // Not Found
            throw NotFoundException(message: e.response!.statusMessage ?? 'Resource not found.');
          case 400: // Bad Request (often for validation errors)
            throw ValidationException(
              message: e.response!.statusMessage ?? 'Invalid request data.',
              errors: e.response!.data is Map ? e.response!.data : null, // Pass detailed errors if available
            );
          default: // Other server errors (5xx, or unhandled 4xx)
            throw AppServerException(
              statusCode: e.response!.statusCode,
              message: e.response!.statusMessage ?? 'Server Error',
            );
        }
      }
      // No response means a network issue (e.g., no internet, DNS lookup failed, timeout)
      throw NetworkException(message: 'No internet connection or server unreachable.');
    } catch (e) {
      // Catch any other unexpected errors that are not DioExceptions
      throw UnknownException(message: e.toString());
    }
  }
}