// ignore_for_file: unused_import
import 'package:example/core/isolate_handler.dart';
import 'package:example/extensions/response_extension.dart';
import 'package:example/utils/utility.dart';
import 'package:example/modules/products/services/products_details_service.dart';
import 'package:example/modules/products/models/products_details_response_model.dart';

abstract class ProductsDetailsRepo {
  Future<ProductsDetailsResponseModel?> getAll({required String page, required String itemPerPage});
  Future<dynamic> getById(String id);
  Future<dynamic> create(Map<String, dynamic> data);
  Future<dynamic> update(String id, Map<String, dynamic> data);
  Future<dynamic> delete(String id);
}

class ProductsDetailsRepoImpl implements ProductsDetailsRepo {
  final ProductsDetailsService service;
  ProductsDetailsRepoImpl({required this.service});

  @override
  Future<ProductsDetailsResponseModel?> getAll({required String page, required String itemPerPage}) async {
    try {
      final response = await service.getAll(page: int.parse(page), limit: int.parse(itemPerPage));
      if (response != null) {
        return await IsolateHandler.run<dynamic, ProductsDetailsResponseModel>(
          response,
          (json) => ProductsDetailsResponseModel.fromJson(json),
        );
      }
      return null;
    } catch (e, st) {
      AppUtility.log('getAll: $e st=$st', tag: 'error');
      rethrow;
    }
  }

  @override
  Future<dynamic> getById(String id) async {
    try {
      return await service.getById(id);
    } catch (e, st) {
      AppUtility.log('getById: $e st=$st', tag: 'error');
      rethrow;
    }
  }

  @override
  Future<dynamic> create(Map<String, dynamic> data) async {
    try {
      return await service.create(data);
    } catch (e, st) {
      AppUtility.log('create: $e st=$st', tag: 'error');
      rethrow;
    }
  }

  @override
  Future<dynamic> update(String id, Map<String, dynamic> data) async {
    try {
      return await service.update(id, data);
    } catch (e, st) {
      AppUtility.log('update: $e st=$st', tag: 'error');
      rethrow;
    }
  }

  @override
  Future<dynamic> delete(String id) async {
    try {
      return await service.delete(id);
    } catch (e, st) {
      AppUtility.log('delete: $e st=$st', tag: 'error');
      rethrow;
    }
  }
}
