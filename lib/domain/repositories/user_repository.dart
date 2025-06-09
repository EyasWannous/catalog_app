import 'package:dartz/dartz.dart';
import 'package:catalog_app/core/errors/failures.dart';
import 'package:catalog_app/domain/entities/user.dart';

/// Defines the contract for user-related data operations.
/// This is the interface that the Domain layer (e.g., Use Cases) will depend on.
/// It speaks in terms of Domain Entities.
abstract class UserRepository {
  Future<Either<Failure, User>> getUser(String userId);
  Future<Either<Failure, List<User>>> getAllUsers();
  Future<Either<Failure, User>> updateUser(User user);
  Future<Either<Failure, void>> deleteUser(String userId);
}