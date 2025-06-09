import 'package:dio/dio.dart';
import 'package:catalog_app/data/models/user_model.dart';
import 'package:catalog_app/data/datasources/remote/remote_data_source_mixin.dart';

/// Defines the contract for interacting with the remote user API.
abstract class RemoteUserDataSource {
  Future<UserModel> getUser(String userId);
  Future<List<UserModel>> getAllUsers();
  Future<UserModel> updateUser(UserModel userModel);
  Future<void> deleteUser(String userId);
}

class RemoteUserDataSourceImpl
    with RemoteDataSourceMixin
    implements RemoteUserDataSource {
  final Dio dio;

  RemoteUserDataSourceImpl({required this.dio});

  @override
  Future<UserModel> getUser(String userId) {
    // Use the mixin's handler to wrap the API call. No need to implement it here.
    return handleRemoteCall(() async {
      final response = await dio.get('/users/$userId');
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    });
  }

  @override
  Future<List<UserModel>> getAllUsers() {
    return handleRemoteCall(() async {
      final response = await dio.get('/users');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => UserModel.fromJson(json))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    });
  }

  @override
  Future<UserModel> updateUser(UserModel userModel) {
    return handleRemoteCall(() async {
      final response =
          await dio.put('/users/${userModel.id}', data: userModel.toJson());
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    });
  }

  @override
  Future<void> deleteUser(String userId) {
    return handleRemoteCall(() async {
      final response = await dio.delete('/users/$userId');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    });
  }
}
