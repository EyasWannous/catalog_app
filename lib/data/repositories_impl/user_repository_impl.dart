import 'package:dartz/dartz.dart';
import 'package:catalog_app/core/errors/failures.dart';
import 'package:catalog_app/core/network/network_info.dart';
import 'package:catalog_app/data/datasources/remote/remote_user_datasource.dart';
import 'package:catalog_app/data/models/user_model.dart';
import 'package:catalog_app/domain/entities/user.dart';
import 'package:catalog_app/domain/repositories/user_repository.dart';
import 'package:catalog_app/data/repositories_impl/repository_handler_mixin.dart';

/// Concrete implementation of the UserRepository defined in the Domain layer.
/// This class is responsible for deciding where to get the data (remote, local)
/// and handling errors by converting Exceptions to Failures using [RepositoryHandlerMixin].
class UserRepositoryImpl with RepositoryHandlerMixin implements UserRepository {
  final RemoteUserDataSource remoteDataSource;
  final NetworkInfo networkInfo; // To check internet connectivity

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> getUser(String userId) async {
    if (await networkInfo.isConnected) {
      // Use the mixin's handler to wrap the datasource call
      return await callDataSource<User>(() => remoteDataSource.getUser(userId));
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
      // You might add logic here to try fetching from local data source if available
    }
  }

  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    if (await networkInfo.isConnected) {
      // Use the mixin's handler
      return await callDataSource<List<User>>(
          () => remoteDataSource.getAllUsers());
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser(User user) async {
    if (await networkInfo.isConnected) {
      // Convert domain entity to data model before passing to datasource
      final userModel = UserModel.fromEntity(user);
      // Use the mixin's handler
      return await callDataSource<User>(
          () => remoteDataSource.updateUser(userModel));
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String userId) async {
    if (await networkInfo.isConnected) {
      // Use the mixin's handler
      return await callDataSource<void>(
          () => remoteDataSource.deleteUser(userId));
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
