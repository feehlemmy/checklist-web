import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:projeto_kva/Controller/Controller.dart';
import 'package:projeto_kva/ModelReactive/CheckListAnswerReactive.dart';
import 'package:projeto_kva/ModelReactive/InterestedPartiesEmailAnswerReactiveEntity.dart';
import 'package:projeto_kva/ModelReactive/QuestionAnswerReactive.dart';
import 'package:projeto_kva/Repository/Entity/CheckListAnswerRepositoryEntity.dart';
import 'package:projeto_kva/Repository/Entity/QuestionAnswerRepositoryEntity.dart';
import 'package:projeto_kva/Utils/Constansts.dart';
import 'package:get/get.dart';

import 'Entity/InterestedPartiesEmailRepositoryAnswerEntity.dart';

class CheckListAnswerRepository {
  saveAnswer(CheckListAnswerReactive checkListAnswer) async {
    Dio dio = Dio();
    final box = GetStorage();
    List<QuestionAnswerRepositoryEntity> questionList = [];
    List<InterestedPartiesEmailAnswerRepositoryEntity> partyList = [];

    try {
      String value = (box.read('token'))!;
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + value;
      for (var questionReactive in checkListAnswer.questions!) {
        QuestionAnswerRepositoryEntity question =
            new QuestionAnswerRepositoryEntity(
          category: questionReactive.category!.value,
          description: questionReactive.description!.value,
          tooltip: questionReactive.tooltip!.value,
          position: questionReactive.position != null
              ? questionReactive.position!.value!
              : null,
          approved: questionReactive.approved!.value,
          disapproved: questionReactive.disapproved!.value,
        );

        questionList.add(question);
      }
      for (var partyReactive in checkListAnswer.interestedPartiesEmailList!) {
        InterestedPartiesEmailAnswerRepositoryEntity party =
            new InterestedPartiesEmailAnswerRepositoryEntity(
                email: partyReactive.email!.value);
        partyList.add(party);
      }

      CheckListAnswerRepositoryEntity checklistEntity =
          CheckListAnswerRepositoryEntity(
              title: checkListAnswer.title!.value,
              productId: checkListAnswer.productId!.value,
              sector: checkListAnswer.sector!.value,
              batch: checkListAnswer.batch!.value,
              date: checkListAnswer.date,
              nameOfUser: checkListAnswer.nameOfUser!.value,
              productVersion: checkListAnswer.productVersion!.value,
              serieNumber: checkListAnswer.serieNumber!.value,
              cause: checkListAnswer.cause,
              redirectTo: checkListAnswer.redirectTo,
              statusOfCheckList: checkListAnswer.statusOfCheckList,
              statusOfProduct: checkListAnswer.statusOfProduct,
              observation:
                  checkListAnswer
                              .observation !=
                          null
                      ? checkListAnswer.observation!.value
                      : '',
              origin: checkListAnswer.origin != null
                  ? checkListAnswer.origin!.value
                  : '',
              testEnvironment: checkListAnswer.testEnvironment != null
                  ? checkListAnswer.testEnvironment!.value
                  : '',
              questionList: questionList,
              interestedPartiesEmailList: partyList);
      var response = await dio.post(
          Constants.baseURL + "checklistAnswer/create",
          data: checklistEntity.toJson());

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<CheckListAnswerReactive>> findByBatchOrSerialNumer(
      int? productId, String searchType, String parameter, String status,
      {String reprovedOrAll = 'all'}) async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      dio.options.headers["authorization"] = "Bearer " + value;
      dio.options.headers["reprovedOrAll"] = reprovedOrAll;

      var response = await dio.get(
        Constants.baseURL + "checklistAnswer/find",
        queryParameters: {
          'findBy': searchType,
          'value': parameter,
          'productId': productId,
          'status': status,
          'sector': Controller.to.user.sector!.value,
        },
      );

      if (response.statusCode == 200) {
        List<CheckListAnswerReactive> checklistReactiveList = [];
        List<CheckListAnswerRepositoryEntity> checklistEntityRepositoryList =
            [];
        List<QuestionAnswerReactive> questionList = [];
        List<InterestedPartiesEmailAnswerReactiveEntity> partyList = [];

        checklistEntityRepositoryList = (response.data as List)
            .map((x) => CheckListAnswerRepositoryEntity.fromMap(x))
            .toList();

        for (int i = 0; i < checklistEntityRepositoryList.length; i++) {
          CheckListAnswerRepositoryEntity checklistRepositoryEntity =
              checklistEntityRepositoryList[i];
          CheckListAnswerReactive checkListReactiveEntity =
              CheckListAnswerReactive();
          for (var questionRepositoryEntity
              in checklistRepositoryEntity.questionList!) {
            QuestionAnswerReactive question = new QuestionAnswerReactive(
                category: questionRepositoryEntity.category!.obs,
                description: questionRepositoryEntity.description!.obs,
                tooltip: questionRepositoryEntity.tooltip != null
                    ? questionRepositoryEntity.tooltip!.obs
                    : "".obs,
                position: questionRepositoryEntity.position != null
                    ? questionRepositoryEntity.position!.obs
                    : null,
                id: questionRepositoryEntity.id,
                approved: questionRepositoryEntity.approved!.obs,
                disapproved: questionRepositoryEntity.disapproved!.obs);

            questionList.add(question);
          }
          for (var partyRepositoryEntity
              in checklistRepositoryEntity.interestedPartiesEmailList!) {
            InterestedPartiesEmailAnswerReactiveEntity party =
                new InterestedPartiesEmailAnswerReactiveEntity(
              email: partyRepositoryEntity.email!.obs,
              id: partyRepositoryEntity.id,
            );
            partyList.add(party);
          }

          checkListReactiveEntity.id = checklistRepositoryEntity.id;
          checkListReactiveEntity.title = checklistRepositoryEntity.title!.obs;
          checkListReactiveEntity.sector =
              checklistRepositoryEntity.sector!.obs;
          checkListReactiveEntity.productId =
              checklistRepositoryEntity.productId!.obs;
          checkListReactiveEntity.questions = questionList;
          checkListReactiveEntity.interestedPartiesEmailList = partyList;
          checkListReactiveEntity.batch = checklistRepositoryEntity.batch!.obs;
          checkListReactiveEntity.cause = checklistRepositoryEntity.cause;
          checkListReactiveEntity.causeDescription =
              checklistRepositoryEntity.causeDescription;

          checkListReactiveEntity.date = checklistRepositoryEntity.date;
          checkListReactiveEntity.dateAssistance =
              checklistRepositoryEntity.dateAssistance;
          checkListReactiveEntity.redirectTo =
              checklistRepositoryEntity.redirectTo;
          checkListReactiveEntity.productVersion =
              checklistRepositoryEntity.productVersion!.obs;
          checkListReactiveEntity.serieNumber =
              checklistRepositoryEntity.serieNumber!.obs;
          checkListReactiveEntity.statusOfCheckList =
              checklistRepositoryEntity.statusOfCheckList;
          checkListReactiveEntity.statusOfProduct =
              checklistRepositoryEntity.statusOfProduct;
          checkListReactiveEntity.nameOfUser =
              checklistRepositoryEntity.nameOfUser!.obs;
          checkListReactiveEntity.nameOfUserAssistance =
              checklistRepositoryEntity.nameOfUserAssistance;
          checkListReactiveEntity.observation =
              checklistRepositoryEntity.observation != null
                  ? checklistRepositoryEntity.observation!.obs
                  : ''.obs;
          checkListReactiveEntity.origin =
              checklistRepositoryEntity.origin != null
                  ? checklistRepositoryEntity.origin!.obs
                  : ''.obs;
          checkListReactiveEntity.testEnvironment =
              checklistRepositoryEntity.testEnvironment != null
                  ? checklistRepositoryEntity.testEnvironment!.obs
                  : ''.obs;
          checklistReactiveList.add(checkListReactiveEntity);
          partyList = [];
          questionList = [];
        }

        return checklistReactiveList;
      }
      return [];
    } catch (e) {
      print(e);
      e.printError();
      return [];
    }
  }

  Future<List<CheckListAnswerReactive>> findByDate(
      int? productId,
      DateTime? initialDate,
      DateTime? endDate,
      String? limit,
      String? offset,
      String? status,
      String productFilterName,
      {String reprovedOrAll = "all"}) async {
    Dio dio = Dio();
    final box = GetStorage();

    if (productId == null) {
      productId = -1;
    }
    try {
      String value = (box.read('token'))!;
      dio.options.headers["authorization"] = "Bearer " + value;
      dio.options.headers["reprovedOrAll"] = reprovedOrAll;

      String url = productId != null
          ? "checklistAnswer/findByDate"
          : 'checklistAnswer/findOnlyDate';
      var response = await dio.post(
        Constants.baseURL + url,
        data: {
          'initialDate': initialDate.toString(),
          'endDate': endDate.toString(),
          'productId': productId,
          'limit': limit,
          'offset': offset,
          'status': status,
          'sector': Controller.to.user.sector!.value,
          'productFilterName': productFilterName
        },
      );

      if (response.statusCode == 200) {
        List<CheckListAnswerReactive> checklistReactiveList = [];
        List<CheckListAnswerRepositoryEntity> checklistEntityRepositoryList =
            [];
        List<QuestionAnswerReactive> questionList = [];
        List<InterestedPartiesEmailAnswerReactiveEntity> partyList = [];

        checklistEntityRepositoryList = (response.data as List)
            .map((x) => CheckListAnswerRepositoryEntity.fromMap(x))
            .toList();

        for (int i = 0; i < checklistEntityRepositoryList.length; i++) {
          CheckListAnswerRepositoryEntity checklistRepositoryEntity =
              checklistEntityRepositoryList[i];
          CheckListAnswerReactive checkListReactiveEntity =
              CheckListAnswerReactive();
          for (var questionRepositoryEntity
              in checklistRepositoryEntity.questionList!) {
            QuestionAnswerReactive question = new QuestionAnswerReactive(
                category: questionRepositoryEntity.category!.obs,
                description: questionRepositoryEntity.description!.obs,
                tooltip: questionRepositoryEntity.tooltip != null
                    ? questionRepositoryEntity.tooltip!.obs
                    : "".obs,
                position: questionRepositoryEntity.position != null
                    ? questionRepositoryEntity.position!.obs
                    : null,
                id: questionRepositoryEntity.id,
                approved: questionRepositoryEntity.approved!.obs,
                disapproved: questionRepositoryEntity.disapproved!.obs);

            questionList.add(question);
          }
          for (var partyRepositoryEntity
              in checklistRepositoryEntity.interestedPartiesEmailList!) {
            InterestedPartiesEmailAnswerReactiveEntity party =
                new InterestedPartiesEmailAnswerReactiveEntity(
              email: partyRepositoryEntity.email!.obs,
              id: partyRepositoryEntity.id,
            );
            partyList.add(party);
          }

          checkListReactiveEntity.id = checklistRepositoryEntity.id;
          checkListReactiveEntity.title = checklistRepositoryEntity.title!.obs;
          checkListReactiveEntity.sector =
              checklistRepositoryEntity.sector!.obs;
          checkListReactiveEntity.productId =
              checklistRepositoryEntity.productId!.obs;
          checkListReactiveEntity.questions = questionList;
          checkListReactiveEntity.interestedPartiesEmailList = partyList;
          checkListReactiveEntity.batch = checklistRepositoryEntity.batch!.obs;
          checkListReactiveEntity.cause = checklistRepositoryEntity.cause;
          checkListReactiveEntity.causeDescription =
              checklistRepositoryEntity.causeDescription;

          checkListReactiveEntity.date = checklistRepositoryEntity.date;
          checkListReactiveEntity.dateAssistance =
              checklistRepositoryEntity.dateAssistance;
          checkListReactiveEntity.redirectTo =
              checklistRepositoryEntity.redirectTo;
          checkListReactiveEntity.productVersion =
              checklistRepositoryEntity.productVersion!.obs;
          checkListReactiveEntity.serieNumber =
              checklistRepositoryEntity.serieNumber!.obs;
          checkListReactiveEntity.statusOfCheckList =
              checklistRepositoryEntity.statusOfCheckList;
          checkListReactiveEntity.statusOfProduct =
              checklistRepositoryEntity.statusOfProduct;
          checkListReactiveEntity.nameOfUser =
              checklistRepositoryEntity.nameOfUser!.obs;
          checkListReactiveEntity.nameOfUserAssistance =
              checklistRepositoryEntity.nameOfUserAssistance;
          checkListReactiveEntity.observation =
              checklistRepositoryEntity.observation != null
                  ? checklistRepositoryEntity.observation!.obs
                  : ''.obs;
          checkListReactiveEntity.origin =
              checklistRepositoryEntity.origin != null
                  ? checklistRepositoryEntity.origin!.obs
                  : ''.obs;

          checkListReactiveEntity.testEnvironment =
              checklistRepositoryEntity.testEnvironment != null
                  ? checklistRepositoryEntity.testEnvironment!.obs
                  : ''.obs;

          checklistReactiveList.add(checkListReactiveEntity);
          partyList = [];
          questionList = [];
        }

        return checklistReactiveList;
      }
      return [];
    } catch (e) {
      print(e);
      e.printError();
      return [];
    }
  }

  Future<List<CheckListAnswerReactive>> findByDateReport(
      int? productId,
      DateTime? initialDate,
      DateTime? endDate,
      String? limit,
      String? offset,
      String? status,
      String productFilterName,
      {String reprovedOrAll = "all"}) async {
    Dio dio = Dio();
    final box = GetStorage();

    if (productId == null) {
      productId = -1;
    }
    try {
      String value = (box.read('token'))!;
      dio.options.headers["authorization"] = "Bearer " + value;
      dio.options.headers["reprovedOrAll"] = reprovedOrAll;

      String url = 'checklistAnswer/findByDateReport';
      var response = await dio.post(
        Constants.baseURL + url,
        data: {
          'initialDate': initialDate.toString(),
          'endDate': endDate.toString(),
          'productId': productId,
          'limit': limit,
          'offset': offset,
          'status': status,
          'sector': Controller.to.user.sector!.value,
          'productFilterName': productFilterName
        },
      );

      if (response.statusCode == 200) {
        List<CheckListAnswerReactive> checklistReactiveList = [];
        List<CheckListAnswerRepositoryEntity> checklistEntityRepositoryList =
            [];
        List<QuestionAnswerReactive> questionList = [];
        List<InterestedPartiesEmailAnswerReactiveEntity> partyList = [];

        checklistEntityRepositoryList = (response.data as List)
            .map((x) => CheckListAnswerRepositoryEntity.fromMap(x))
            .toList();

        for (int i = 0; i < checklistEntityRepositoryList.length; i++) {
          CheckListAnswerRepositoryEntity checklistRepositoryEntity =
              checklistEntityRepositoryList[i];
          CheckListAnswerReactive checkListReactiveEntity =
              CheckListAnswerReactive();
          for (var questionRepositoryEntity
              in checklistRepositoryEntity.questionList!) {
            QuestionAnswerReactive question = new QuestionAnswerReactive(
                category: questionRepositoryEntity.category!.obs,
                description: questionRepositoryEntity.description!.obs,
                tooltip: questionRepositoryEntity.tooltip != null
                    ? questionRepositoryEntity.tooltip!.obs
                    : "".obs,
                position: questionRepositoryEntity.position != null
                    ? questionRepositoryEntity.position!.obs
                    : null,
                id: questionRepositoryEntity.id,
                approved: questionRepositoryEntity.approved!.obs,
                disapproved: questionRepositoryEntity.disapproved!.obs);

            questionList.add(question);
          }
          for (var partyRepositoryEntity
              in checklistRepositoryEntity.interestedPartiesEmailList!) {
            InterestedPartiesEmailAnswerReactiveEntity party =
                new InterestedPartiesEmailAnswerReactiveEntity(
              email: partyRepositoryEntity.email!.obs,
              id: partyRepositoryEntity.id,
            );
            partyList.add(party);
          }

          checkListReactiveEntity.id = checklistRepositoryEntity.id;
          checkListReactiveEntity.title = checklistRepositoryEntity.title!.obs;
          checkListReactiveEntity.sector =
              checklistRepositoryEntity.sector!.obs;
          checkListReactiveEntity.productId =
              checklistRepositoryEntity.productId!.obs;
          checkListReactiveEntity.questions = questionList;
          checkListReactiveEntity.interestedPartiesEmailList = partyList;
          checkListReactiveEntity.batch = checklistRepositoryEntity.batch!.obs;
          checkListReactiveEntity.cause = checklistRepositoryEntity.cause;
          checkListReactiveEntity.causeDescription =
              checklistRepositoryEntity.causeDescription;

          checkListReactiveEntity.date = checklistRepositoryEntity.date;
          checkListReactiveEntity.dateAssistance =
              checklistRepositoryEntity.dateAssistance;
          checkListReactiveEntity.redirectTo =
              checklistRepositoryEntity.redirectTo;
          checkListReactiveEntity.productVersion =
              checklistRepositoryEntity.productVersion!.obs;
          checkListReactiveEntity.serieNumber =
              checklistRepositoryEntity.serieNumber!.obs;
          checkListReactiveEntity.statusOfCheckList =
              checklistRepositoryEntity.statusOfCheckList;
          checkListReactiveEntity.statusOfProduct =
              checklistRepositoryEntity.statusOfProduct;
          checkListReactiveEntity.nameOfUser =
              checklistRepositoryEntity.nameOfUser!.obs;
          checkListReactiveEntity.nameOfUserAssistance =
              checklistRepositoryEntity.nameOfUserAssistance;
          checkListReactiveEntity.observation =
              checklistRepositoryEntity.observation != null
                  ? checklistRepositoryEntity.observation!.obs
                  : ''.obs;
          checkListReactiveEntity.origin =
              checklistRepositoryEntity.origin != null
                  ? checklistRepositoryEntity.origin!.obs
                  : ''.obs;

          checkListReactiveEntity.testEnvironment =
              checklistRepositoryEntity.testEnvironment != null
                  ? checklistRepositoryEntity.testEnvironment!.obs
                  : ''.obs;

          checklistReactiveList.add(checkListReactiveEntity);
          partyList = [];
          questionList = [];
        }

        return checklistReactiveList;
      }
      return [];
    } catch (e) {
      print(e);
      e.printError();
      return [];
    }
  }

  Future<List<CheckListAnswerReactive>> findByDateReproved(
      int? productId,
      DateTime? initialDate,
      DateTime? endDate,
      String? limit,
      String? offset,
      String productFilterName,
      {String reprovedOrAll = "all"}) async {
    Dio dio = Dio();
    final box = GetStorage();

    if (productId == null) {
      productId = -1;
    }
    try {
      String value = (box.read('token'))!;
      dio.options.headers["authorization"] = "Bearer " + value;
      dio.options.headers["reprovedOrAll"] = reprovedOrAll;

      String url = 'checklistAnswer/findByDateReproved';
      var response = await dio.post(
        Constants.baseURL + url,
        data: {
          'initialDate': initialDate.toString(),
          'endDate': endDate.toString(),
          'productId': productId,
          'limit': limit,
          'offset': offset,
          'sector': Controller.to.user.sector!.value,
          'productFilterName': productFilterName
        },
      );

      if (response.statusCode == 200) {
        List<CheckListAnswerReactive> checklistReactiveList = [];
        List<CheckListAnswerRepositoryEntity> checklistEntityRepositoryList =
            [];
        List<QuestionAnswerReactive> questionList = [];
        List<InterestedPartiesEmailAnswerReactiveEntity> partyList = [];

        checklistEntityRepositoryList = (response.data as List)
            .map((x) => CheckListAnswerRepositoryEntity.fromMap(x))
            .toList();

        for (int i = 0; i < checklistEntityRepositoryList.length; i++) {
          CheckListAnswerRepositoryEntity checklistRepositoryEntity =
              checklistEntityRepositoryList[i];
          CheckListAnswerReactive checkListReactiveEntity =
              CheckListAnswerReactive();
          for (var questionRepositoryEntity
              in checklistRepositoryEntity.questionList!) {
            QuestionAnswerReactive question = new QuestionAnswerReactive(
                category: questionRepositoryEntity.category!.obs,
                description: questionRepositoryEntity.description!.obs,
                tooltip: questionRepositoryEntity.tooltip != null
                    ? questionRepositoryEntity.tooltip!.obs
                    : "".obs,
                position: questionRepositoryEntity.position != null
                    ? questionRepositoryEntity.position!.obs
                    : null,
                id: questionRepositoryEntity.id,
                approved: questionRepositoryEntity.approved!.obs,
                disapproved: questionRepositoryEntity.disapproved!.obs);

            questionList.add(question);
          }
          for (var partyRepositoryEntity
              in checklistRepositoryEntity.interestedPartiesEmailList!) {
            InterestedPartiesEmailAnswerReactiveEntity party =
                new InterestedPartiesEmailAnswerReactiveEntity(
              email: partyRepositoryEntity.email!.obs,
              id: partyRepositoryEntity.id,
            );
            partyList.add(party);
          }

          checkListReactiveEntity.id = checklistRepositoryEntity.id;
          checkListReactiveEntity.title = checklistRepositoryEntity.title!.obs;
          checkListReactiveEntity.sector =
              checklistRepositoryEntity.sector!.obs;
          checkListReactiveEntity.productId =
              checklistRepositoryEntity.productId!.obs;
          checkListReactiveEntity.questions = questionList;
          checkListReactiveEntity.interestedPartiesEmailList = partyList;
          checkListReactiveEntity.batch = checklistRepositoryEntity.batch!.obs;
          checkListReactiveEntity.cause = checklistRepositoryEntity.cause;
          checkListReactiveEntity.causeDescription =
              checklistRepositoryEntity.causeDescription;

          checkListReactiveEntity.date = checklistRepositoryEntity.date;
          checkListReactiveEntity.dateAssistance =
              checklistRepositoryEntity.dateAssistance;
          checkListReactiveEntity.redirectTo =
              checklistRepositoryEntity.redirectTo;
          checkListReactiveEntity.productVersion =
              checklistRepositoryEntity.productVersion!.obs;
          checkListReactiveEntity.serieNumber =
              checklistRepositoryEntity.serieNumber!.obs;
          checkListReactiveEntity.statusOfCheckList =
              checklistRepositoryEntity.statusOfCheckList;
          checkListReactiveEntity.statusOfProduct =
              checklistRepositoryEntity.statusOfProduct;
          checkListReactiveEntity.nameOfUser =
              checklistRepositoryEntity.nameOfUser!.obs;
          checkListReactiveEntity.nameOfUserAssistance =
              checklistRepositoryEntity.nameOfUserAssistance;
          checkListReactiveEntity.observation =
              checklistRepositoryEntity.observation != null
                  ? checklistRepositoryEntity.observation!.obs
                  : ''.obs;
          checkListReactiveEntity.origin =
              checklistRepositoryEntity.origin != null
                  ? checklistRepositoryEntity.origin!.obs
                  : ''.obs;

          checkListReactiveEntity.testEnvironment =
              checklistRepositoryEntity.testEnvironment != null
                  ? checklistRepositoryEntity.testEnvironment!.obs
                  : ''.obs;

          checklistReactiveList.add(checkListReactiveEntity);
          partyList = [];
          questionList = [];
        }

        return checklistReactiveList;
      }
      return [];
    } catch (e) {
      print(e);
      e.printError();
      return [];
    }
  }

  findForIndicators(String month, String year) async {
    List<DateTime> dateList = buildDate(month, year);
    return findByDate(
        null, dateList[0], dateList[1], null, null, 'Todos', 'Todos');
  }

  List<DateTime> buildDate(String month, String year) {
    String? firstDay;
    String? lastDay;
    String? monthNumber;
    switch (month) {
      case 'Janeiro':
        firstDay = '01';
        lastDay = '31';
        monthNumber = '01';
        break;
      case 'Fevereiro':
        firstDay = '01';
        lastDay = '28';
        monthNumber = '02';

        break;
      case 'Março':
        firstDay = '01';
        lastDay = '31';
        monthNumber = '03';

        break;
      case 'Abril':
        firstDay = '01';
        lastDay = '30';
        monthNumber = '04';

        break;
      case 'Maio':
        firstDay = '01';
        lastDay = '31';
        monthNumber = '05';

        break;
      case 'Junho':
        firstDay = '01';
        lastDay = '30';
        monthNumber = '06';

        break;
      case 'Julho':
        firstDay = '01';
        lastDay = '31';
        monthNumber = '07';

        break;
      case 'Agosto':
        firstDay = '01';
        lastDay = '31';
        monthNumber = '08';

        break;
      case 'Setembro':
        firstDay = '01';
        lastDay = '30';
        monthNumber = '09';

        break;
      case 'Outubro':
        firstDay = '01';
        lastDay = '31';
        monthNumber = '10';

        break;
      case 'Novembro':
        firstDay = '01';
        lastDay = '30';
        monthNumber = '11';

        break;
      case 'Dezembro':
        firstDay = '01';
        lastDay = '31';
        monthNumber = '12';

        break;
    }
    String firstDate = firstDay! + '-' + monthNumber! + '-' + year;
    String endDate = lastDay! + '-' + monthNumber + '-' + year;

    return [
      new DateFormat("dd-MM-yyyy").parse(firstDate),
      DateFormat("dd-MM-yyyy").parse(endDate)
    ];
  }

  update(CheckListAnswerReactive checkListAnswer) async {
    Dio dio = Dio();
    final box = GetStorage();
    List<QuestionAnswerRepositoryEntity> questionList = [];
    List<InterestedPartiesEmailAnswerRepositoryEntity> partyList = [];

    try {
      String value = (box.read('token'))!;
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + value;
      for (var questionReactive in checkListAnswer.questions!) {
        QuestionAnswerRepositoryEntity question =
            new QuestionAnswerRepositoryEntity(
                category: questionReactive.category!.value,
                description: questionReactive.description!.value,
                tooltip: questionReactive.tooltip!.value,
                position: questionReactive.position != null
                    ? questionReactive.position!.value!
                    : null,
                approved: questionReactive.approved!.value,
                disapproved: questionReactive.disapproved!.value,
                id: questionReactive.id);

        questionList.add(question);
      }
      for (var partyReactive in checkListAnswer.interestedPartiesEmailList!) {
        InterestedPartiesEmailAnswerRepositoryEntity party =
            new InterestedPartiesEmailAnswerRepositoryEntity(
                email: partyReactive.email!.value,
                id: partyReactive.id,
                checkListSkeletonId: checkListAnswer.id);
        partyList.add(party);
      }

      CheckListAnswerRepositoryEntity checklistEntity =
          CheckListAnswerRepositoryEntity(
              id: checkListAnswer.id,
              title: checkListAnswer.title!.value,
              productId: checkListAnswer.productId!.value,
              sector: checkListAnswer.sector!.value,
              batch: checkListAnswer.batch!.value,
              date: checkListAnswer.date,
              nameOfUser: checkListAnswer.nameOfUser!.value,
              nameOfUserAssistance: checkListAnswer.nameOfUserAssistance!,
              productVersion: checkListAnswer.productVersion!.value,
              serieNumber: checkListAnswer.serieNumber!.value,
              cause: checkListAnswer.cause,
              causeDescription: checkListAnswer.causeDescription,
              dateAssistance: checkListAnswer.dateAssistance,
              statusOfCheckList: checkListAnswer.statusOfCheckList,
              statusOfProduct: checkListAnswer.statusOfProduct,
              redirectTo: checkListAnswer.redirectTo,
              observation:
                  checkListAnswer
                              .observation !=
                          null
                      ? checkListAnswer.observation!.value
                      : '',
              origin: checkListAnswer.origin != null
                  ? checkListAnswer.origin!.value
                  : '',
              testEnvironment: checkListAnswer.testEnvironment != null
                  ? checkListAnswer.testEnvironment!.value
                  : '',
              questionList: questionList,
              interestedPartiesEmailList: partyList);
      var response = await dio.put(Constants.baseURL + "checklistAnswer/update",
          data: checklistEntity.toJson());

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<int> countResponse(int? productId, String searchType, String parameter,
      String status) async {
    Dio dio = Dio();
    final box = GetStorage();
    try {
      String value = (box.read('token'))!;
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + value;
      var response = await dio.get(
          Constants.baseURL + "checklistAnswer/countElements",
          queryParameters: {
            'findBy': searchType,
            'value': parameter,
            'productId': productId,
            'status': status,
            'sector':
                Controller.to.user.sector!.value == Constants.administrativo
                    ? null
                    : Controller.to.user.sector!.value
          });

      if (response.statusCode == 200) {
        return response.data;
      }
      return -1;
    } catch (e) {
      print(e);
      return -1;
    }
  }

  findByPaginationBatchOrSerialNumer(
      int? productId,
      String searchType,
      String parameter,
      String limit,
      String offset,
      String status,
      String productFilterName,
      {String reprovedOrAll = 'all'}) async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      dio.options.headers["authorization"] = "Bearer " + value;
      dio.options.headers["reprovedOrAll"] = reprovedOrAll;

      var response = await dio.get(
        Constants.baseURL + "checklistAnswer/paginationFind",
        queryParameters: {
          'findBy': searchType,
          'value': parameter,
          'productId': productId,
          'limit': limit,
          'offset': offset,
          'status': status,
          'sector': Controller.to.user.sector!.value,
          'productFilterName': productFilterName
        },
      );

      if (response.statusCode == 200) {
        List<CheckListAnswerReactive> checklistReactiveList = [];
        List<CheckListAnswerRepositoryEntity> checklistEntityRepositoryList =
            [];
        List<QuestionAnswerReactive> questionList = [];
        List<InterestedPartiesEmailAnswerReactiveEntity> partyList = [];

        checklistEntityRepositoryList = (response.data as List)
            .map((x) => CheckListAnswerRepositoryEntity.fromMap(x))
            .toList();

        for (int i = 0; i < checklistEntityRepositoryList.length; i++) {
          CheckListAnswerRepositoryEntity checklistRepositoryEntity =
              checklistEntityRepositoryList[i];
          CheckListAnswerReactive checkListReactiveEntity =
              CheckListAnswerReactive();
          for (var questionRepositoryEntity
              in checklistRepositoryEntity.questionList!) {
            QuestionAnswerReactive question = new QuestionAnswerReactive(
                category: questionRepositoryEntity.category!.obs,
                description: questionRepositoryEntity.description!.obs,
                tooltip: questionRepositoryEntity.tooltip != null
                    ? questionRepositoryEntity.tooltip!.obs
                    : "".obs,
                position: questionRepositoryEntity.position != null
                    ? questionRepositoryEntity.position!.obs
                    : null,
                id: questionRepositoryEntity.id,
                approved: questionRepositoryEntity.approved!.obs,
                disapproved: questionRepositoryEntity.disapproved!.obs);

            questionList.add(question);
          }
          for (var partyRepositoryEntity
              in checklistRepositoryEntity.interestedPartiesEmailList!) {
            InterestedPartiesEmailAnswerReactiveEntity party =
                new InterestedPartiesEmailAnswerReactiveEntity(
              email: partyRepositoryEntity.email!.obs,
              id: partyRepositoryEntity.id,
            );
            partyList.add(party);
          }

          checkListReactiveEntity.id = checklistRepositoryEntity.id;
          checkListReactiveEntity.title = checklistRepositoryEntity.title!.obs;
          checkListReactiveEntity.sector =
              checklistRepositoryEntity.sector!.obs;
          checkListReactiveEntity.productId =
              checklistRepositoryEntity.productId!.obs;
          checkListReactiveEntity.questions = questionList;
          checkListReactiveEntity.interestedPartiesEmailList = partyList;
          checkListReactiveEntity.batch = checklistRepositoryEntity.batch!.obs;
          checkListReactiveEntity.cause = checklistRepositoryEntity.cause;
          checkListReactiveEntity.causeDescription =
              checklistRepositoryEntity.causeDescription;

          checkListReactiveEntity.date = checklistRepositoryEntity.date;
          checkListReactiveEntity.dateAssistance =
              checklistRepositoryEntity.dateAssistance;
          checkListReactiveEntity.redirectTo =
              checklistRepositoryEntity.redirectTo;
          checkListReactiveEntity.productVersion =
              checklistRepositoryEntity.productVersion!.obs;
          checkListReactiveEntity.serieNumber =
              checklistRepositoryEntity.serieNumber!.obs;
          checkListReactiveEntity.statusOfCheckList =
              checklistRepositoryEntity.statusOfCheckList;
          checkListReactiveEntity.statusOfProduct =
              checklistRepositoryEntity.statusOfProduct;
          checkListReactiveEntity.nameOfUser =
              checklistRepositoryEntity.nameOfUser!.obs;
          checkListReactiveEntity.nameOfUserAssistance =
              checklistRepositoryEntity.nameOfUserAssistance;
          checkListReactiveEntity.observation =
              checklistRepositoryEntity.observation != null
                  ? checklistRepositoryEntity.observation!.obs
                  : ''.obs;
          checkListReactiveEntity.origin =
              checklistRepositoryEntity.origin != null
                  ? checklistRepositoryEntity.origin!.obs
                  : ''.obs;
          checkListReactiveEntity.testEnvironment =
              checklistRepositoryEntity.testEnvironment != null
                  ? checklistRepositoryEntity.testEnvironment!.obs
                  : ''.obs;
          checklistReactiveList.add(checkListReactiveEntity);
          partyList = [];
          questionList = [];
        }

        return checklistReactiveList;
      }
      return [];
    } catch (e) {
      print(e);
      e.printError();
      return [];
    }
  }

  findByPaginationBatchOrSerialNumerReproved(int? productId, String searchType,
      String parameter, String limit, String offset, String productFilterName,
      {String reprovedOrAll = 'all'}) async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      dio.options.headers["authorization"] = "Bearer " + value;
      dio.options.headers["reprovedOrAll"] = reprovedOrAll;

      var response = await dio.get(
        Constants.baseURL + "checklistAnswer/paginationFindReproved",
        queryParameters: {
          'findBy': searchType,
          'value': parameter,
          'productId': productId,
          'limit': limit,
          'offset': offset,
          'sector': Controller.to.user.sector!.value,
          'productFilterName': productFilterName
        },
      );

      if (response.statusCode == 200) {
        List<CheckListAnswerReactive> checklistReactiveList = [];
        List<CheckListAnswerRepositoryEntity> checklistEntityRepositoryList =
            [];
        List<QuestionAnswerReactive> questionList = [];
        List<InterestedPartiesEmailAnswerReactiveEntity> partyList = [];

        checklistEntityRepositoryList = (response.data as List)
            .map((x) => CheckListAnswerRepositoryEntity.fromMap(x))
            .toList();

        for (int i = 0; i < checklistEntityRepositoryList.length; i++) {
          CheckListAnswerRepositoryEntity checklistRepositoryEntity =
              checklistEntityRepositoryList[i];
          CheckListAnswerReactive checkListReactiveEntity =
              CheckListAnswerReactive();
          for (var questionRepositoryEntity
              in checklistRepositoryEntity.questionList!) {
            QuestionAnswerReactive question = new QuestionAnswerReactive(
                category: questionRepositoryEntity.category!.obs,
                description: questionRepositoryEntity.description!.obs,
                tooltip: questionRepositoryEntity.tooltip != null
                    ? questionRepositoryEntity.tooltip!.obs
                    : "".obs,
                position: questionRepositoryEntity.position != null
                    ? questionRepositoryEntity.position!.obs
                    : null,
                id: questionRepositoryEntity.id,
                approved: questionRepositoryEntity.approved!.obs,
                disapproved: questionRepositoryEntity.disapproved!.obs);

            questionList.add(question);
          }
          for (var partyRepositoryEntity
              in checklistRepositoryEntity.interestedPartiesEmailList!) {
            InterestedPartiesEmailAnswerReactiveEntity party =
                new InterestedPartiesEmailAnswerReactiveEntity(
              email: partyRepositoryEntity.email!.obs,
              id: partyRepositoryEntity.id,
            );
            partyList.add(party);
          }

          checkListReactiveEntity.id = checklistRepositoryEntity.id;
          checkListReactiveEntity.title = checklistRepositoryEntity.title!.obs;
          checkListReactiveEntity.sector =
              checklistRepositoryEntity.sector!.obs;
          checkListReactiveEntity.productId =
              checklistRepositoryEntity.productId!.obs;
          checkListReactiveEntity.questions = questionList;
          checkListReactiveEntity.interestedPartiesEmailList = partyList;
          checkListReactiveEntity.batch = checklistRepositoryEntity.batch!.obs;
          checkListReactiveEntity.cause = checklistRepositoryEntity.cause;
          checkListReactiveEntity.causeDescription =
              checklistRepositoryEntity.causeDescription;

          checkListReactiveEntity.date = checklistRepositoryEntity.date;
          checkListReactiveEntity.dateAssistance =
              checklistRepositoryEntity.dateAssistance;
          checkListReactiveEntity.redirectTo =
              checklistRepositoryEntity.redirectTo;
          checkListReactiveEntity.productVersion =
              checklistRepositoryEntity.productVersion!.obs;
          checkListReactiveEntity.serieNumber =
              checklistRepositoryEntity.serieNumber!.obs;
          checkListReactiveEntity.statusOfCheckList =
              checklistRepositoryEntity.statusOfCheckList;
          checkListReactiveEntity.statusOfProduct =
              checklistRepositoryEntity.statusOfProduct;
          checkListReactiveEntity.nameOfUser =
              checklistRepositoryEntity.nameOfUser!.obs;
          checkListReactiveEntity.nameOfUserAssistance =
              checklistRepositoryEntity.nameOfUserAssistance;
          checkListReactiveEntity.observation =
              checklistRepositoryEntity.observation != null
                  ? checklistRepositoryEntity.observation!.obs
                  : ''.obs;
          checkListReactiveEntity.origin =
              checklistRepositoryEntity.origin != null
                  ? checklistRepositoryEntity.origin!.obs
                  : ''.obs;
          checkListReactiveEntity.testEnvironment =
              checklistRepositoryEntity.testEnvironment != null
                  ? checklistRepositoryEntity.testEnvironment!.obs
                  : ''.obs;
          checklistReactiveList.add(checkListReactiveEntity);
          partyList = [];
          questionList = [];
        }

        return checklistReactiveList;
      }
      return [];
    } catch (e) {
      print(e);
      e.printError();
      return [];
    }
  }

  findByPaginationBatchOrSerialNumerReport(
      int? productId,
      String searchType,
      String parameter,
      String limit,
      String offset,
      String status,
      String productFilterName,
      {String reprovedOrAll = 'all'}) async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      dio.options.headers["authorization"] = "Bearer " + value;
      dio.options.headers["reprovedOrAll"] = reprovedOrAll;

      var response = await dio.get(
        Constants.baseURL + "checklistAnswer/paginationFindReport",
        queryParameters: {
          'findBy': searchType,
          'value': parameter,
          'productId': productId,
          'limit': limit,
          'offset': offset,
          'sector': Controller.to.user.sector!.value,
          'status': status,
          'productFilterName': productFilterName
        },
      );

      if (response.statusCode == 200) {
        List<CheckListAnswerReactive> checklistReactiveList = [];
        List<CheckListAnswerRepositoryEntity> checklistEntityRepositoryList =
            [];
        List<QuestionAnswerReactive> questionList = [];
        List<InterestedPartiesEmailAnswerReactiveEntity> partyList = [];

        checklistEntityRepositoryList = (response.data as List)
            .map((x) => CheckListAnswerRepositoryEntity.fromMap(x))
            .toList();

        for (int i = 0; i < checklistEntityRepositoryList.length; i++) {
          CheckListAnswerRepositoryEntity checklistRepositoryEntity =
              checklistEntityRepositoryList[i];
          CheckListAnswerReactive checkListReactiveEntity =
              CheckListAnswerReactive();
          for (var questionRepositoryEntity
              in checklistRepositoryEntity.questionList!) {
            QuestionAnswerReactive question = new QuestionAnswerReactive(
                category: questionRepositoryEntity.category!.obs,
                description: questionRepositoryEntity.description!.obs,
                tooltip: questionRepositoryEntity.tooltip != null
                    ? questionRepositoryEntity.tooltip!.obs
                    : "".obs,
                position: questionRepositoryEntity.position != null
                    ? questionRepositoryEntity.position!.obs
                    : null,
                id: questionRepositoryEntity.id,
                approved: questionRepositoryEntity.approved!.obs,
                disapproved: questionRepositoryEntity.disapproved!.obs);

            questionList.add(question);
          }
          for (var partyRepositoryEntity
              in checklistRepositoryEntity.interestedPartiesEmailList!) {
            InterestedPartiesEmailAnswerReactiveEntity party =
                new InterestedPartiesEmailAnswerReactiveEntity(
              email: partyRepositoryEntity.email!.obs,
              id: partyRepositoryEntity.id,
            );
            partyList.add(party);
          }

          checkListReactiveEntity.id = checklistRepositoryEntity.id;
          checkListReactiveEntity.title = checklistRepositoryEntity.title!.obs;
          checkListReactiveEntity.sector =
              checklistRepositoryEntity.sector!.obs;
          checkListReactiveEntity.productId =
              checklistRepositoryEntity.productId!.obs;
          checkListReactiveEntity.questions = questionList;
          checkListReactiveEntity.interestedPartiesEmailList = partyList;
          checkListReactiveEntity.batch = checklistRepositoryEntity.batch!.obs;
          checkListReactiveEntity.cause = checklistRepositoryEntity.cause;
          checkListReactiveEntity.causeDescription =
              checklistRepositoryEntity.causeDescription;

          checkListReactiveEntity.date = checklistRepositoryEntity.date;
          checkListReactiveEntity.dateAssistance =
              checklistRepositoryEntity.dateAssistance;
          checkListReactiveEntity.redirectTo =
              checklistRepositoryEntity.redirectTo;
          checkListReactiveEntity.productVersion =
              checklistRepositoryEntity.productVersion!.obs;
          checkListReactiveEntity.serieNumber =
              checklistRepositoryEntity.serieNumber!.obs;
          checkListReactiveEntity.statusOfCheckList =
              checklistRepositoryEntity.statusOfCheckList;
          checkListReactiveEntity.statusOfProduct =
              checklistRepositoryEntity.statusOfProduct;
          checkListReactiveEntity.nameOfUser =
              checklistRepositoryEntity.nameOfUser!.obs;
          checkListReactiveEntity.nameOfUserAssistance =
              checklistRepositoryEntity.nameOfUserAssistance;
          checkListReactiveEntity.observation =
              checklistRepositoryEntity.observation != null
                  ? checklistRepositoryEntity.observation!.obs
                  : ''.obs;
          checkListReactiveEntity.origin =
              checklistRepositoryEntity.origin != null
                  ? checklistRepositoryEntity.origin!.obs
                  : ''.obs;
          checkListReactiveEntity.testEnvironment =
              checklistRepositoryEntity.testEnvironment != null
                  ? checklistRepositoryEntity.testEnvironment!.obs
                  : ''.obs;
          checklistReactiveList.add(checkListReactiveEntity);
          partyList = [];
          questionList = [];
        }

        return checklistReactiveList;
      }
      return [];
    } catch (e) {
      print(e);
      e.printError();
      return [];
    }
  }

  countResponseData(int? productId, DateTime? initialDate, DateTime? endDate,
      String status) async {
    Dio dio = Dio();
    final box = GetStorage();
    try {
      String value = (box.read('token'))!;
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + value;

      var response = await dio.post(
        Constants.baseURL + "checklistAnswer/countDateElements",
        data: {
          'initialDate': initialDate.toString(),
          'endDate': endDate.toString(),
          'productId': productId,
          'limit': null,
          'offset': null,
          'status': status,
          'sector': Controller.to.user.sector!.value == Constants.administrativo
              ? null
              : Controller.to.user.sector!.value
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return -1;
    } catch (e) {
      print(e);
      return -1;
    }
  }

  deleteChecklist(int? id) async {
    Dio dio = Dio();
    final box = GetStorage();

    try {
      String value = (box.read('token'))!;
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + value;

      var response =
          await dio.delete(Constants.baseURL + "checklistAnswer/delete/$id");
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
