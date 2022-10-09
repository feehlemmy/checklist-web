import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import 'package:projeto_kva/ModelReactive/CheckListSkeletonReactive.dart';
import 'package:projeto_kva/ModelReactive/InterestedPartiesEmailRepository.dart';
import 'package:projeto_kva/ModelReactive/QuestionSkeletonReactive.dart';
import 'package:projeto_kva/ModelReactive/UserEntityReactive.dart';
import 'package:projeto_kva/Repository/Entity/CheckListSkeletonRepository.dart';
import 'package:projeto_kva/Repository/Entity/InterestedPartiesEmailRepository.dart';
import 'package:projeto_kva/Repository/Entity/QuestionSkeletonRepository.dart';
import 'package:projeto_kva/Utils/Constansts.dart';

import 'Entity/Cause.dart';

class ChecklistSketonRepository {
  Future<bool> createChecklistSkeleton(
      CheckListSkeletonReactive checklistEntityReactive) async {
    Dio dio = Dio();
    final box = GetStorage();
    List<QuestionSkeletonRepositoryEntity> questionList = [];
    List<InterestedPartiesEmailRepositoryEntity> partyList = [];

    try {
      String value = (box.read('token'))!;
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + value;
      for (var questionReactive in checklistEntityReactive.questions!) {
        QuestionSkeletonRepositoryEntity question =
            new QuestionSkeletonRepositoryEntity(
                category: questionReactive.category!.value,
                position: questionReactive.position != null
                    ? questionReactive.position!.value!
                    : null,
                description: questionReactive.description!.value,
                tooltip: questionReactive.tooltip!.value);
        questionList.add(question);
      }
      for (var partyReactive
          in checklistEntityReactive.interestedPartiesEmailList!) {
        InterestedPartiesEmailRepositoryEntity party =
            new InterestedPartiesEmailRepositoryEntity(
                email: partyReactive.email!.value);
        partyList.add(party);
      }

      CheckListSkeletonRepositoryEntity checklistEntity =
          CheckListSkeletonRepositoryEntity(
              title: checklistEntityReactive.title!.value,
              productId: checklistEntityReactive.productId!.value,
              sector: checklistEntityReactive.sector!.value,
              status: checklistEntityReactive.status!.value,
              questionList: questionList,
              interestedPartiesEmailList: partyList);

      var response = await dio.post(
          Constants.baseURL + "checklistSkeleton/create",
          data: checklistEntity.toJson());

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<CheckListSkeletonReactive>> getAllChecklistSkeleton(
      UserEntityReactive user) async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      dio.options.headers["authorization"] = "Bearer " + value;

      var response = await dio.get(
        Constants.baseURL + "checklistSkeleton/getAll",
        queryParameters: {
          'sector': user.sector!.value,
        },
      );

      if (response.statusCode == 200) {
        List<CheckListSkeletonReactive> checklistReactiveList = [];
        List<CheckListSkeletonRepositoryEntity> checklistEntityRepositoryList =
            [];
        List<QuestionSkeletonReactive> questionList = [];
        List<InterestedPartiesEmailReactiveEntity> partyList = [];

        checklistEntityRepositoryList = (response.data as List)
            .map((x) => CheckListSkeletonRepositoryEntity.fromMap(x))
            .toList();

        for (int i = 0; i < checklistEntityRepositoryList.length; i++) {
          CheckListSkeletonRepositoryEntity checklistRepositoryEntity =
              checklistEntityRepositoryList[i];
          CheckListSkeletonReactive checkListReactiveEntity =
              CheckListSkeletonReactive();

          for (var questionRepositoryEntity
              in checklistRepositoryEntity.questionList!) {
            QuestionSkeletonReactive question = new QuestionSkeletonReactive(
                category: questionRepositoryEntity.category!.obs,
                description: questionRepositoryEntity.description!.obs,
                tooltip: questionRepositoryEntity.tooltip != null
                    ? questionRepositoryEntity.tooltip!.obs
                    : "".obs,
                position: questionRepositoryEntity.position != null
                    ? questionRepositoryEntity.position!.obs
                    : null,
                id: questionRepositoryEntity.id);
            questionList.add(question);
          }
          for (var partyRepositoryEntity
              in checklistRepositoryEntity.interestedPartiesEmailList!) {
            InterestedPartiesEmailReactiveEntity party =
                new InterestedPartiesEmailReactiveEntity(
                    email: partyRepositoryEntity.email!.obs);
            partyList.add(party);
          }
          checkListReactiveEntity.id = checklistRepositoryEntity.id;
          checkListReactiveEntity.title = checklistRepositoryEntity.title!.obs;
          checkListReactiveEntity.sector =
              checklistRepositoryEntity.sector!.obs;
          checkListReactiveEntity.status =
              checklistRepositoryEntity.status!.obs;
          checkListReactiveEntity.productId =
              checklistRepositoryEntity.productId!.obs;
          checkListReactiveEntity.questions = questionList;
          checkListReactiveEntity.interestedPartiesEmailList = partyList;

          checklistReactiveList.add(checkListReactiveEntity);
          partyList = [];
          questionList = [];
        }
        return checklistReactiveList;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  deleteCheckList(int id) async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + value;

      var response =
          await dio.delete(Constants.baseURL + "checklistSkeleton/delete/$id");

      if (response.statusCode == 204) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  createCause(Cause cause) async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + value;
      dio.options.baseUrl = Constants.baseURL;

      var response = await dio.post(Constants.baseURL + "cause/create",
          data: cause.toJson());

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  getAllCause() async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      dio.options.headers["authorization"] = "Bearer " + value;

      var response = await dio.get(
        Constants.baseURL + "cause/getAll",
      );

      if (response.statusCode == 200) {
        List<Cause> causeList = [];

        causeList =
            (response.data as List).map((x) => Cause.fromMap(x)).toList();

        return causeList;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  edit(CheckListSkeletonReactive checkListSkeletonReactive) async {
    Dio dio = Dio();
    final box = GetStorage();
    List<QuestionSkeletonRepositoryEntity> questionList = [];
    List<InterestedPartiesEmailRepositoryEntity> partyList = [];

    try {
      String value = (box.read('token'))!;
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + value;
      for (var questionReactive in checkListSkeletonReactive.questions!) {
        QuestionSkeletonRepositoryEntity question =
            new QuestionSkeletonRepositoryEntity(
                category: questionReactive.category!.value,
                position: questionReactive.position != null
                    ? questionReactive.position!.value!
                    : null,
                description: questionReactive.description!.value,
                tooltip: questionReactive.tooltip!.value);
        questionList.add(question);
      }
      for (var partyReactive
          in checkListSkeletonReactive.interestedPartiesEmailList!) {
        InterestedPartiesEmailRepositoryEntity party =
            new InterestedPartiesEmailRepositoryEntity(
                email: partyReactive.email!.value);
        partyList.add(party);
      }

      CheckListSkeletonRepositoryEntity checklistEntity =
          CheckListSkeletonRepositoryEntity(
              title: checkListSkeletonReactive.title!.value,
              productId: checkListSkeletonReactive.productId!.value,
              sector: checkListSkeletonReactive.sector!.value,
              status: checkListSkeletonReactive.status!.value,
              id: checkListSkeletonReactive.id,
              questionList: questionList,
              interestedPartiesEmailList: partyList);

      var response = await dio.put(
          Constants.baseURL + "checklistSkeleton/update",
          data: checklistEntity.toJson());

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      e.printError();
      return false;
    }
  }

  disableChecklist(CheckListSkeletonReactive checklistEntityReactive) async {
    {
      Dio dio = Dio();
      final box = GetStorage();
      List<QuestionSkeletonRepositoryEntity> questionList = [];
      List<InterestedPartiesEmailRepositoryEntity> partyList = [];

      try {
        String value = (box.read('token'))!;
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + value;
        for (var questionReactive in checklistEntityReactive.questions!) {
          QuestionSkeletonRepositoryEntity question =
              new QuestionSkeletonRepositoryEntity(
                  category: questionReactive.category!.value,
                  position: questionReactive.position != null
                      ? questionReactive.position!.value!
                      : null,
                  description: questionReactive.description!.value,
                  tooltip: questionReactive.tooltip!.value);
          questionList.add(question);
        }
        for (var partyReactive
            in checklistEntityReactive.interestedPartiesEmailList!) {
          InterestedPartiesEmailRepositoryEntity party =
              new InterestedPartiesEmailRepositoryEntity(
                  email: partyReactive.email!.value);
          partyList.add(party);
        }

        CheckListSkeletonRepositoryEntity checklistEntity =
            CheckListSkeletonRepositoryEntity(
                title: checklistEntityReactive.title!.value,
                id: checklistEntityReactive.id,
                productId: checklistEntityReactive.productId!.value,
                sector: checklistEntityReactive.sector!.value,
                status: checklistEntityReactive.status!.value,
                questionList: questionList,
                interestedPartiesEmailList: partyList);

        var response = await dio.put(
            Constants.baseURL + "checklistSkeleton/disable",
            data: checklistEntity.toJson());

        if (response.statusCode == 200) {
          return true;
        }
        return false;
      } catch (e) {
        return false;
      }
    }
  }

  Future<List<CheckListSkeletonReactive>> getActiveChecklistSkeleton(
      UserEntityReactive user) async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      dio.options.headers["authorization"] = "Bearer " + value;
      dio.options.queryParameters = {
        "sector": user.sector!.value,
      };

      var response = await dio.get(
        Constants.baseURL + "checklistSkeleton/getActive",
      );

      if (response.statusCode == 200) {
        List<CheckListSkeletonReactive> checklistReactiveList = [];
        List<CheckListSkeletonRepositoryEntity> checklistEntityRepositoryList =
            [];
        List<QuestionSkeletonReactive> questionList = [];
        List<InterestedPartiesEmailReactiveEntity> partyList = [];

        checklistEntityRepositoryList = (response.data as List)
            .map((x) => CheckListSkeletonRepositoryEntity.fromMap(x))
            .toList();

        for (int i = 0; i < checklistEntityRepositoryList.length; i++) {
          CheckListSkeletonRepositoryEntity checklistRepositoryEntity =
              checklistEntityRepositoryList[i];
          CheckListSkeletonReactive checkListReactiveEntity =
              CheckListSkeletonReactive();

          for (var questionRepositoryEntity
              in checklistRepositoryEntity.questionList!) {
            QuestionSkeletonReactive question = new QuestionSkeletonReactive(
                category: questionRepositoryEntity.category!.obs,
                description: questionRepositoryEntity.description!.obs,
                tooltip: questionRepositoryEntity.tooltip != null
                    ? questionRepositoryEntity.tooltip!.obs
                    : "".obs,
                position: questionRepositoryEntity.position != null
                    ? questionRepositoryEntity.position!.obs
                    : null,
                id: questionRepositoryEntity.id);
            questionList.add(question);
          }
          for (var partyRepositoryEntity
              in checklistRepositoryEntity.interestedPartiesEmailList!) {
            InterestedPartiesEmailReactiveEntity party =
                new InterestedPartiesEmailReactiveEntity(
                    email: partyRepositoryEntity.email!.obs);
            partyList.add(party);
          }
          checkListReactiveEntity.id = checklistRepositoryEntity.id;
          checkListReactiveEntity.title = checklistRepositoryEntity.title!.obs;
          checkListReactiveEntity.sector =
              checklistRepositoryEntity.sector!.obs;
          checkListReactiveEntity.status =
              checklistRepositoryEntity.status!.obs;
          checkListReactiveEntity.productId =
              checklistRepositoryEntity.productId!.obs;
          checkListReactiveEntity.questions = questionList;
          checkListReactiveEntity.interestedPartiesEmailList = partyList;

          checklistReactiveList.add(checkListReactiveEntity);
          partyList = [];
          questionList = [];
        }
        return checklistReactiveList;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
