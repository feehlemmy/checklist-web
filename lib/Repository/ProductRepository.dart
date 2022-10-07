import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:projeto_kva/ModelReactive/ProductEntityReactive.dart';
import 'package:projeto_kva/Repository/Entity/ProductRepositoryEntity.dart';
import 'package:projeto_kva/Utils/Constansts.dart';
import 'package:get/get.dart';

class ProductRepository {
  Future<bool> createProduct(
      ProductEntityReactive productEntityReactive) async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + value;
      dio.options.baseUrl = Constants.baseURL;
      ProducRepositoryEntity productRepositoryEntity = ProducRepositoryEntity(
        name: productEntityReactive.name!.value!,
        category: productEntityReactive.category!.value!,
        status: 'Active',
      );

      var response = await dio.post(Constants.baseURL + "product/create",
          data: productRepositoryEntity.toJson());

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<ProductEntityReactive>> getAllProducts() async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      dio.options.headers["authorization"] = "Bearer " + value;

      var response = await dio.get(
        Constants.baseURL + "product/getAll",
      );

      if (response.statusCode == 200) {
        List<ProductEntityReactive> productReactiveList = [];
        List<ProducRepositoryEntity> productEntityRepositoryList = [];

        productEntityRepositoryList = (response.data as List)
            .map((x) => ProducRepositoryEntity.fromMap(x))
            .toList();

        for (int i = 0; i < productEntityRepositoryList.length; i++) {
          ProducRepositoryEntity productRepository =
              productEntityRepositoryList[i];
          ProductEntityReactive productReactive = ProductEntityReactive();
          productReactive.id = productRepository.id;
          productReactive.name = productRepository.name!.obs;
          productReactive.category = productRepository.category!.obs;
          productReactive.status = productRepository.status!.obs;

          productReactiveList.add(productReactive);
        }

        return productReactiveList;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> deleteProduct(ProductEntityReactive product) async {
    {
      Dio dio = Dio();
      final box = GetStorage();

      try {
        String value = (box.read('token'))!;
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + value;
        ProducRepositoryEntity productRepositoryEntity = ProducRepositoryEntity(
            name: product.name!.value!,
            category: product.category!.value!,
            status: product.status!.value);

        var response = await dio.put(
            Constants.baseURL + "product/disable/${product.id}",
            data: productRepositoryEntity.toJson());

        if (response.statusCode == 200) {
          return true;
        }
        return false;
      } catch (e) {
        e.printError();
        return false;
      }
    }
  }

  edit(ProductEntityReactive productEntityReactive) async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + value;
      ProducRepositoryEntity product = ProducRepositoryEntity(
        id: productEntityReactive.id,
        name: productEntityReactive.name!.value!,
        category: productEntityReactive.category!.value!,
        status: productEntityReactive.status!.value!,
      );

      var response = await dio.put(Constants.baseURL + "product/update",
          data: product.toJson());

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      e.printError();
      return false;
    }
  }
}
