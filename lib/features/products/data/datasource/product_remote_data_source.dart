import 'dart:io';
import 'package:catalog_app/core/error/exception.dart';
import 'package:catalog_app/core/network/api_service.dart';
import 'package:catalog_app/core/utils/logger.dart';
import 'package:catalog_app/features/products/data/model/attachment_model.dart';
import 'package:catalog_app/features/products/data/model/product_model.dart';
import 'package:catalog_app/features/products/data/model/product_response_model.dart';
import 'package:dio/dio.dart';

abstract class ProductRemoteDataSource {
  // Product operations
  Future<ProductResponseModel> getProducts(
    String categoryId, {
    int? pageNumber,
    int? pageSize,
  });
  Future<ProductModel> getProduct(int id);

  // Create product with images (POST /products with files)
  Future<ProductModel> createProductWithImages(
    String name,
    String description,
    String price,
    String categoryId,
    List<File> images,
  );

  // Update product data only (PUT /products without images)
  Future<ProductModel> updateProduct(
    int id,
    String name,
    String description,
    String price,
    String categoryId,
  );

  Future<void> deleteProduct(int id);

  // Attachment operations
  // Create attachment for existing product (POST /attachments)
  Future<AttachmentModel> createAttachment(
    int productId,
    File imageFile,
  );

  // Delete specific attachment (DELETE /attachments/{id})
  Future<void> deleteAttachment(int attachmentId);

  // Legacy methods - kept for backward compatibility
  @Deprecated('Use createProductWithImages instead')
  Future<ProductModel> postProduct(
    String name,
    String description,
    String price,
    String categoryId,
  );
}

class ProductRemoteDataSourceImpl extends ProductRemoteDataSource {
  final ApiService apiService;
  ProductRemoteDataSourceImpl(this.apiService);

  @override
  Future<ProductResponseModel> getProducts(
    String categoryId, {
    int? pageNumber,
    int? pageSize,
  }) async {
    try {
      final response = await apiService.get(
        '/Categories/$categoryId/products',
        queryParameters: {
          'pageNumber': pageNumber ?? 1,
          'pageSize': pageSize ?? 10,
        },
      );
      AppLogger.info('Get products response: ${response.toString()}');
      return ProductResponseModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('Error getting products', e);
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> getProduct(int id) async {
    try {
      final response = await apiService.get('/products/$id');

      AppLogger.info('Get product response: ${response.toString()}');

      // Extract the 'data' field from the API response
      final productData = response.data['data'];
      if (productData == null) {
        AppLogger.error('Product data is null in API response', null);
        throw ServerException();
      }

      AppLogger.info('Parsing product data: ${productData.toString()}');
      return ProductModel.fromJson(productData);
    } catch (e) {
      AppLogger.error('Error getting product', e);
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> postProduct(
    String name,
    String description,
    String price,
    String categoryId,
  ) async {
    var body = ProductModel(
      hiveId: 0,
      hiveName: name,
      hiveDescription: description,
      hivePrice: price,
      hiveCategoryId: int.parse(categoryId),
      hiveAttachments: [], // Empty attachments for legacy method
    );

    try {
      final response = await apiService.post('/products', data: body.toJson());

      AppLogger.info('Post product response: ${response.toString()}');
      return ProductModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('Error posting product', e);
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> updateProduct(
    int id,
    String name,
    String description,
    String price,
    String categoryId,
  ) async {
    var body = ProductModel(
      hiveId: id,
      hiveName: name,
      hiveDescription: description,
      hivePrice: price,
      hiveCategoryId: int.parse(categoryId),
      hiveAttachments: [], // Empty attachments for update (images handled separately)
    );

    try {
      final response = await apiService.put(
        '/products/$id',
        data: body.toJson(),
      );

      AppLogger.info('Update product response: ${response.toString()}');
      return ProductModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('Error updating product', e);
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      final response = await apiService.delete('/products/$id');

      AppLogger.info('Delete product response: ${response.toString()}');
      return;
    } catch (e) {
      AppLogger.error('Error deleting product', e);
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> createProductWithImages(
    String name,
    String description,
    String price,
    String categoryId,
    List<File> images,
  ) async {
    try {
      // Create FormData with product data and images
      final Map<String, dynamic> formDataMap = {
        'Name': name,
        'Description': description,
        'Price': price,
        'CategoryId': categoryId,
      };

      // Add images to form data as a list
      final List<MultipartFile> imageFiles = [];
      for (int i = 0; i < images.length; i++) {
        imageFiles.add(await MultipartFile.fromFile(
          images[i].path,
          filename: 'image_$i.jpg',
        ));
      }

      if (imageFiles.isNotEmpty) {
        formDataMap['Images'] = imageFiles;
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await apiService.post(
        '/products',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      AppLogger.info('Create product with images response: ${response.toString()}');
      return ProductModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('Error creating product with images', e);
      throw ServerException();
    }
  }

  @override
  Future<AttachmentModel> createAttachment(
    int productId,
    File imageFile,
  ) async {
    try {
      final formData = FormData.fromMap({
        'ProductId': productId,
        'File': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'attachment.jpg',
        ),
      });

      final response = await apiService.post(
        '/attachments',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      AppLogger.info('Create attachment response: ${response.toString()}');
      return AttachmentModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('Error creating attachment', e);
      throw ServerException();
    }
  }

  @override
  Future<void> deleteAttachment(int attachmentId) async {
    try {
      final response = await apiService.delete('/attachments/$attachmentId');

      AppLogger.info('Delete attachment response: ${response.toString()}');
      return;
    } catch (e) {
      AppLogger.error('Error deleting attachment', e);
      throw ServerException();
    }
  }
}