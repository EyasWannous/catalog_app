/// Base class for all custom exceptions in the application.
class AppServerException implements Exception {
  final String message;
  final int? statusCode;

  const AppServerException({required this.message, this.statusCode});

  @override
  String toString() => 'AppServerException(message: $message, statusCode: $statusCode)';
}

/// Thrown when there's an issue with network connectivity (e.g., no internet).
class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'No internet connection or server unreachable.'});

  @override
  String toString() => 'NetworkException(message: $message)';
}

/// Thrown when a requested resource is not found (e.g., HTTP 404).
class NotFoundException implements Exception {
  final String message;

  const NotFoundException({this.message = 'Resource not found.'});

  @override
  String toString() => 'NotFoundException(message: $message)';
}

/// Thrown for authentication-related errors (e.g., HTTP 401, 403).
class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException({this.message = 'Unauthorized access.'});

  @override
  String toString() => 'UnauthorizedException(message: $message)';
}

/// Thrown for any unexpected or unhandled error.
class UnknownException implements Exception {
  final String message;

  const UnknownException({this.message = 'An unexpected error occurred.'});

  @override
  String toString() => 'UnknownException(message: $message)';
}

/// Thrown when data validation fails.
class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic>? errors; // Optional detailed validation errors

  const ValidationException({required this.message, this.errors});

  @override
  String toString() => 'ValidationException(message: $message, errors: $errors)';
}

// You can add more specific exceptions as your project grows,
// for example: CacheException, DatabaseException, TimeoutException, etc.