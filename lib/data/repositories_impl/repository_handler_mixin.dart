import 'package:dartz/dartz.dart';
import 'package:catalog_app/core/errors/exceptions.dart';
import 'package:catalog_app/core/errors/failures.dart';

/// A mixin that provides a generic handler for performing repository operations
/// with standardized exception-to-failure conversion.
///
/// This mixin is designed to be used by concrete repository implementations.
/// It wraps calls to datasources, catches known exceptions, and maps them
/// to appropriate Failure types, returning them wrapped in an `Either` type.
mixin RepositoryHandlerMixin {
  /// Handles an asynchronous call to a data source, catching specific
  /// [Exception] types and converting them into [Failure] types.
  ///
  /// [call]: An asynchronous function that executes the data source operation.
  ///         This function is expected to throw custom [Exception] types.
  ///
  /// Returns:
  /// - `Right(T)` if the [call] completes successfully.
  /// - `Left(Failure)` if a known [Exception] is caught, mapped to the corresponding [Failure].
  /// - `Left(UnknownFailure)` for any other unexpected exceptions.
  Future<Either<Failure, T>> callDataSource<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Right(result);
    } on AppServerException catch (e) {
      // Map AppServerException to ServerFailure
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      // Map NetworkException to NetworkFailure
      return Left(NetworkFailure(message: e.message));
    } on NotFoundException catch (e) {
      // Map NotFoundException to NotFoundFailure
      return Left(NotFoundFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      // Map UnauthorizedException to UnauthorizedFailure
      return Left(UnauthorizedFailure(message: e.message));
    } on ValidationException catch (e) {
      // Map ValidationException to ValidationFailure
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } catch (e) {
      // Catch any other unexpected exceptions and map to UnknownFailure
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}