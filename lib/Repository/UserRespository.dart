import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:projeto_kva/Controller/HomeController.dart';
import 'package:projeto_kva/ModelReactive/UserEntityReactive.dart';
import 'package:projeto_kva/Repository/Entity/UserRepositoryEntity.dart';
import 'package:projeto_kva/Utils/Constansts.dart';
import 'package:get/get.dart';

class UserRepository {
  Future<UserRepositoryEntity> login(String username, String password) async {
    Dio dio = Dio();

    await GetStorage.init();
    final box = GetStorage();

    try {
      var response = await dio.post(Constants.baseURL + "user/login",
          options: Options(headers: {
            'content-type': 'application/json',
            'Access-Control-Allow-Origin': 'true'
          }),
          data: {'username': username, 'password': password});

      if (response.statusCode == 200) {
        String token = response.data['jwt'];

        box.write('token', token);
        box.write('username', username);
        box.write('name', response.data['name']);
        box.write('sector', response.data['sector']);

        UserRepositoryEntity user = UserRepositoryEntity.fromMap(response.data);
        return user;
      }
    } catch (e) {
      e.printError();
      e.printInfo();
      print(e);
      HomeController.to.errorSnackbar("Usuário ou senha inválidos");
    }
    return new UserRepositoryEntity();
  }

  Future<bool> createUser(UserEntityReactive userEntityReactive) async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + value;
      dio.options.headers["access-control-allow-origin"] = '*';
      UserRepositoryEntity userRepositoryEntity = UserRepositoryEntity(
          name: userEntityReactive.name!.value!,
          password: userEntityReactive.password!.value!,
          sector: userEntityReactive.sector!.value!,
          status: "Active",
          username: userEntityReactive.username!.value!);

      var response = await dio.post(Constants.baseURL + "user/signUp",
          data: userRepositoryEntity.toJson());

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<UserEntityReactive>> getAllUsers() async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      dio.options.headers["authorization"] = "Bearer " + value;

      var response = await dio.get(
        Constants.baseURL + "user/getAll",
      );

      if (response.statusCode == 200) {
        List<UserEntityReactive> userReactiveList = [];
        List<UserRepositoryEntity> userList = [];

        userList = (response.data as List)
            .map((x) => UserRepositoryEntity.fromMap(x))
            .toList();

        for (int i = 0; i < userList.length; i++) {
          UserRepositoryEntity userRepository = userList[i];
          UserEntityReactive userEntityReactice = UserEntityReactive();
          userEntityReactice.id = userRepository.id;
          userEntityReactice.name = userRepository.name!.obs;
          userEntityReactice.status = userRepository.status!.obs;
          userEntityReactice.username = userRepository.username!.obs;
          userEntityReactice.sector = userRepository.sector!.obs;
          userReactiveList.add(userEntityReactice);
        }

        return userReactiveList;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> disableUser(UserEntityReactive userEntityReactive) async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + value;
      UserRepositoryEntity userRepositoryEntity = UserRepositoryEntity(
          name: userEntityReactive.name!.value!,
          sector: userEntityReactive.sector!.value!,
          status: userEntityReactive.status!.value,
          username: userEntityReactive.username!.value!);

      var response = await dio.put(
          Constants.baseURL + "user/delete/${userEntityReactive.id}",
          data: userRepositoryEntity.toJson());

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      e.printError();
      return false;
    }
  }

  Future<bool> updatePassword(UserEntityReactive userEntityReactive) async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + value;
      UserRepositoryEntity userRepositoryEntity = UserRepositoryEntity(
        password: userEntityReactive.password!.value!,
      );

      var response = await dio.put(
          Constants.baseURL + "user/updatePassword/${userEntityReactive.id}",
          data: userRepositoryEntity.toJson());

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      e.printError();
      return false;
    }
  }

  Future<UserEntityReactive> getUser() async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      String username = (box.read('username'))!;

      dio.options.headers["authorization"] = "Bearer " + value;

      var response = await dio.get(
        Constants.baseURL + "user/get/$username",
      );

      if (response.statusCode == 200) {
        UserRepositoryEntity user = UserRepositoryEntity.fromMap(response.data);
        return UserEntityReactive(
          id: user.id,
          name: user.name!.obs,
          password: user.password!.obs,
          sector: user.sector!.obs,
          status: user.status!.obs,
          username: user.username!.obs,
        );
      }

      return UserEntityReactive();
    } catch (e) {
      e.printError();
      return UserEntityReactive();
    }
  }

  Future<bool> edit(UserEntityReactive userToEdit) async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + value;
      UserRepositoryEntity userRepositoryEntity = UserRepositoryEntity(
          id: userToEdit.id,
          name: userToEdit.name!.value!,
          sector: userToEdit.sector!.value!,
          status: userToEdit.status!.value,
          username: userToEdit.username!.value!);

      var response = await dio.put(Constants.baseURL + "user/update",
          data: userRepositoryEntity.toJson());

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      e.printError();
      return false;
    }
  }

  validatePasswordForDelete(String password) async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + value;

      var response =
          await dio.get(Constants.baseURL + "user/ValidatePassword/$password");
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
