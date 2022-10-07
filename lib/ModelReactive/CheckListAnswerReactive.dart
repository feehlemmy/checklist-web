import 'package:flutter/foundation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'package:projeto_kva/ModelReactive/QuestionAnswerReactive.dart';

import 'InterestedPartiesEmailAnswerReactiveEntity.dart';

class CheckListAnswerReactive {
  int? id;
  RxString? title;
  RxInt? productId;
  RxString? sector;
  RxString? batch;
  RxString? productVersion;
  RxString? serieNumber;
  DateTime? date;
  RxString? nameOfUser;
  String? statusOfProduct;
  String? statusOfCheckList;
  String? redirectTo;
  RxString? origin;
  RxString? testEnvironment;
  RxString? observation;
  DateTime? dateAssistance;
  String? nameOfUserAssistance;
  String? cause;
  String? causeDescription;

  List<QuestionAnswerReactive>? questions;
  List<InterestedPartiesEmailAnswerReactiveEntity>? interestedPartiesEmailList;
  CheckListAnswerReactive({
    this.id,
    this.title,
    this.productId,
    this.sector,
    this.batch,
    this.productVersion,
    this.serieNumber,
    this.date,
    this.nameOfUser,
    this.redirectTo,
    this.statusOfProduct,
    this.statusOfCheckList,
    this.origin,
    this.testEnvironment,
    this.observation,
    this.dateAssistance,
    this.nameOfUserAssistance,
    this.cause,
    this.causeDescription,
    this.questions,
    this.interestedPartiesEmailList,
  });

  CheckListAnswerReactive copyWith({
    int? id,
    RxString? title,
    RxInt? productId,
    RxString? sector,
    RxString? batch,
    RxString? productVersion,
    RxString? serieNumber,
    DateTime? date,
    RxString? nameOfUser,
    String? statusOfProduct,
    String? statusOfCheckList,
    String? redirectTo,
    RxString? origin,
    RxString? testEnvironment,
    RxString? observation,
    DateTime? dateAssistance,
    String? nameOfUserAssistance,
    String? cause,
    String? causeDescription,
    List<QuestionAnswerReactive>? questions,
    List<InterestedPartiesEmailAnswerReactiveEntity>?
        interestedPartiesEmailList,
  }) {
    return CheckListAnswerReactive(
      id: id ?? this.id,
      title: title ?? this.title,
      productId: productId ?? this.productId,
      sector: sector ?? this.sector,
      batch: batch ?? this.batch,
      productVersion: productVersion ?? this.productVersion,
      serieNumber: serieNumber ?? this.serieNumber,
      date: date ?? this.date,
      nameOfUser: nameOfUser ?? this.nameOfUser,
      statusOfProduct: statusOfProduct ?? this.statusOfProduct,
      statusOfCheckList: statusOfCheckList ?? this.statusOfCheckList,
      redirectTo: redirectTo ?? this.redirectTo,
      origin: origin ?? this.origin,
      testEnvironment: testEnvironment ?? this.testEnvironment,
      observation: observation ?? this.observation,
      dateAssistance: dateAssistance ?? this.dateAssistance,
      nameOfUserAssistance: nameOfUserAssistance ?? this.nameOfUserAssistance,
      cause: cause ?? this.cause,
      causeDescription: causeDescription ?? this.causeDescription,
      questions: questions ?? this.questions,
      interestedPartiesEmailList:
          interestedPartiesEmailList ?? this.interestedPartiesEmailList,
    );
  }

  @override
  String toString() {
    return 'CheckListAnswerReactive(id: $id, title: $title, productId: $productId, sector: $sector, batch: $batch, productVersion: $productVersion, serieNumber: $serieNumber, redirectTo: $redirectTo,  date: $date, nameOfUser: $nameOfUser, statusOfProduct: $statusOfProduct, statusOfCheckList: $statusOfCheckList, origin: $origin, observation: $observation, dateAssistance: $dateAssistance, nameOfUserAssistance: $nameOfUserAssistance, cause: $cause, causeDescription: $causeDescription, testEnvironment: $testEnvironment, questions: $questions, interestedPartiesEmailList: $interestedPartiesEmailList)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CheckListAnswerReactive &&
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
        other.statusOfProduct == statusOfProduct &&
        other.statusOfCheckList == statusOfCheckList &&
        other.origin == origin &&
        other.testEnvironment == testEnvironment &&
        other.observation == observation &&
        other.dateAssistance == dateAssistance &&
        other.nameOfUserAssistance == nameOfUserAssistance &&
        other.cause == cause &&
        other.causeDescription == causeDescription &&
        listEquals(other.questions, questions) &&
        listEquals(
            other.interestedPartiesEmailList, interestedPartiesEmailList);
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
        nameOfUser.hashCode ^
        redirectTo.hashCode ^
        statusOfProduct.hashCode ^
        statusOfCheckList.hashCode ^
        origin.hashCode ^
        observation.hashCode ^
        dateAssistance.hashCode ^
        nameOfUserAssistance.hashCode ^
        cause.hashCode ^
        testEnvironment.hashCode ^
        causeDescription.hashCode ^
        questions.hashCode ^
        interestedPartiesEmailList.hashCode;
  }
}
