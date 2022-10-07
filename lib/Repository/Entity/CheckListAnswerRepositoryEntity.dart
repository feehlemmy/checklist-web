import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:projeto_kva/Repository/Entity/QuestionAnswerRepositoryEntity.dart';
import 'package:projeto_kva/Utils/WidgetsCommon.dart';

import 'InterestedPartiesEmailRepositoryAnswerEntity.dart';

class CheckListAnswerRepositoryEntity {
  int? id;
  String? title;
  int? productId;
  String? sector;
  String? batch;
  String? productVersion;
  String? serieNumber;
  DateTime? date;
  String? nameOfUser;
  DateTime? dateAssistance;
  String? nameOfUserAssistance;
  String? cause;
  String? redirectTo;
  String? causeDescription;
  String? statusOfCheckList;
  String? statusOfProduct;
  String? observation;
  String? origin;
  String? testEnvironment;
  List<InterestedPartiesEmailAnswerRepositoryEntity>?
      interestedPartiesEmailList;
  List<QuestionAnswerRepositoryEntity>? questionList;
  CheckListAnswerRepositoryEntity({
    this.id,
    this.title,
    this.productId,
    this.sector,
    this.batch,
    this.productVersion,
    this.serieNumber,
    this.date,
    this.redirectTo,
    this.nameOfUser,
    this.dateAssistance,
    this.nameOfUserAssistance,
    this.statusOfCheckList,
    this.statusOfProduct,
    this.observation,
    this.origin,
    this.testEnvironment,
    this.cause,
    this.causeDescription,
    this.questionList,
    this.interestedPartiesEmailList,
  });

  CheckListAnswerRepositoryEntity copyWith(
      {int? id,
      String? title,
      int? productId,
      String? sector,
      String? batch,
      String? productVersion,
      String? serieNumber,
      DateTime? date,
      String? redirectTo,
      String? nameOfUser,
      DateTime? dateAssistance,
      String? nameOfUserAssistance,
      String? statusOfCheckList,
      String? statusOfProduct,
      String? observation,
      String? origin,
      String? testEnvironment,
      String? cause,
      String? causeDescription,
      List<QuestionAnswerRepositoryEntity>? questionList,
      List<InterestedPartiesEmailAnswerRepositoryEntity>?
          interestedPartiesEmailList}) {
    return CheckListAnswerRepositoryEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      productId: productId ?? this.productId,
      sector: sector ?? this.sector,
      batch: batch ?? this.batch,
      productVersion: productVersion ?? this.productVersion,
      serieNumber: serieNumber ?? this.serieNumber,
      date: date ?? this.date,
      redirectTo: redirectTo ?? this.redirectTo,
      nameOfUser: nameOfUser ?? this.nameOfUser,
      dateAssistance: dateAssistance ?? this.dateAssistance,
      nameOfUserAssistance: nameOfUserAssistance ?? this.nameOfUserAssistance,
      statusOfCheckList: statusOfCheckList ?? this.statusOfCheckList,
      statusOfProduct: statusOfProduct ?? this.statusOfProduct,
      observation: observation ?? this.observation,
      origin: origin ?? this.origin,
      testEnvironment: testEnvironment ?? this.testEnvironment,
      cause: cause ?? this.cause,
      causeDescription: causeDescription ?? this.causeDescription,
      questionList: questionList ?? this.questionList,
      interestedPartiesEmailList:
          interestedPartiesEmailList ?? this.interestedPartiesEmailList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'productId': productId,
      'sector': sector,
      'batch': batch,
      'productVersion': productVersion,
      'serieNumber': serieNumber,
      'date': CommonWidgets.getFormatter().format(date!),
      'nameOfUser': nameOfUser,
      'dateAssistance': dateAssistance != null
          ? CommonWidgets.getFormatter().format(dateAssistance!)
          : null,
      'nameOfUserAssistance': nameOfUserAssistance,
      'statusOfCheckList': statusOfCheckList,
      'statusOfProduct': statusOfProduct,
      'observation': observation,
      'origin': origin,
      'redirectTo': redirectTo,
      'testEnvironment': testEnvironment,
      'cause': cause,
      'causeDescription': causeDescription,
      'questionList': questionList?.map((x) => x.toMap()).toList(),
      'interestedPartiesEmailList':
          interestedPartiesEmailList?.map((x) => x.toMap()).toList(),
    };
  }

  factory CheckListAnswerRepositoryEntity.fromMap(Map<String, dynamic> map) {
    return CheckListAnswerRepositoryEntity(
      id: map['id'],
      title: map['title'],
      productId: map['productId'],
      sector: map['sector'],
      batch: map['batch'],
      productVersion: map['productVersion'],
      serieNumber: map['serieNumber'],
      date: (CommonWidgets.getFormatter().parse(map['date'])),
      nameOfUser: map['nameOfUser'],
      dateAssistance: map['dateAssistance'] != null
          ? CommonWidgets.getFormatter().parse(map['dateAssistance'])
          : null,
      nameOfUserAssistance: map['nameOfUserAssistance'],
      statusOfCheckList: map['statusOfCheckList'],
      statusOfProduct: map['statusOfProduct'],
      observation: map['observation'],
      origin: map['origin'],
      redirectTo: map['redirectTo'],
      testEnvironment: map['testEnvironment'],
      cause: map['cause'],
      causeDescription: map['causeDescription'],
      questionList: List<QuestionAnswerRepositoryEntity>.from(
          map['questionList']
              ?.map((x) => QuestionAnswerRepositoryEntity.fromMap(x))),
      interestedPartiesEmailList:
          List<InterestedPartiesEmailAnswerRepositoryEntity>.from(
              map['interestedPartiesEmailList']?.map((x) =>
                  InterestedPartiesEmailAnswerRepositoryEntity.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckListAnswerRepositoryEntity.fromJson(String source) =>
      CheckListAnswerRepositoryEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CheckListAnswerRepositoryEntity(id: $id, title: $title, productId: $productId, redirectTo: $redirectTo,  testEnvironment: $testEnvironment,sector: $sector, batch: $batch, productVersion: $productVersion, serieNumber: $serieNumber, date: $date, nameOfUser: $nameOfUser, dateAssistance: $dateAssistance, nameOfUserAssistance: $nameOfUserAssistance, statusOfCheckList: $statusOfCheckList, statusOfProduct: $statusOfProduct, observation: $observation, origin: $origin, cause: $cause, questionList: $questionList)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CheckListAnswerRepositoryEntity &&
        other.id == id &&
        other.title == title &&
        other.productId == productId &&
        other.sector == sector &&
        other.batch == batch &&
        other.productVersion == productVersion &&
        other.serieNumber == serieNumber &&
        other.date == date &&
        other.redirectTo == redirectTo &&
        other.nameOfUser == nameOfUser &&
        other.dateAssistance == dateAssistance &&
        other.nameOfUserAssistance == nameOfUserAssistance &&
        other.statusOfCheckList == statusOfCheckList &&
        other.statusOfProduct == statusOfProduct &&
        other.observation == observation &&
        other.origin == origin &&
        other.testEnvironment == testEnvironment &&
        other.cause == cause &&
        listEquals(other.questionList, questionList);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        productId.hashCode ^
        sector.hashCode ^
        batch.hashCode ^
        productVersion.hashCode ^
        serieNumber.hashCode ^
        date.hashCode ^
        redirectTo.hashCode ^
        nameOfUser.hashCode ^
        dateAssistance.hashCode ^
        nameOfUserAssistance.hashCode ^
        statusOfCheckList.hashCode ^
        statusOfProduct.hashCode ^
        observation.hashCode ^
        origin.hashCode ^
        testEnvironment.hashCode ^
        cause.hashCode ^
        questionList.hashCode;
  }
}
