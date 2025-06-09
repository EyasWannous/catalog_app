import 'package:equatable/equatable.dart';

/// Base class for all custom failures in the application.
/// It extends Equatable to allow for easy comparison of failure types.
abstract class Failure extends Equatable {
  final String message;
  final List<dynamic> properties; // Used by Equatable for comparison

  // Making the properties default to const <dynamic>[] ensures
  // that subclasses can use const constructors if their own properties are const.
  const Failure({required this.message, this.properties = const <dynamic>[]}); // <--- FIX HERE

  @override
  List<Object?> get props => [message, properties];

  @override
  String toString() => message; // Simple representation for convenience
}

/// Represents a failure originating from the server (e.g., HTTP 500, business logic error from API).
class ServerFailure extends Failure {
  final int? statusCode;

  // No need for 'const' keyword on the constructor if properties are not always const
  // However, if all properties are constant, you can keep it.
  // For simplicity and flexibility, remove it if issues arise.
  // We can make it const here because statusCode is final and message is from super.
  const ServerFailure({required super.message, this.statusCode})
      : super(properties: const []); // <--- FIX HERE if 'statusCode' is not always used in props, otherwise keep as is
      // If statusCode is always used in props for comparison, then:
      // : super(properties: [message, statusCode]); // This is often fine without 'const' on list.

  // Let's refine for `const` safety:
  @override
  List<Object?> get props => [message, statusCode]; // Equatable handles properties directly
}

/// Represents a failure due to network issues (e.g., no internet, DNS lookup failed).
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

/// Represents a failure where a requested resource was not found.
class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message});
}

/// Represents an authentication or authorization failure.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required super.message});
}

/// Represents a general unknown or unhandled failure.
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}

/// Represents a failure due to invalid data validation.
class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors; // Optional detailed validation errors

  const ValidationFailure({required super.message, this.errors}); // <--- FIX HERE: remove properties from super()

  @override
  List<Object?> get props => [message, errors]; // Equatable handles properties directly
}

/// Represents a failure when no data is found (e.g., an empty list where data was expected).
class NoDataFailure extends Failure {
  const NoDataFailure({required super.message});
}

/// Represents a failure when data caching operations fail.
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}