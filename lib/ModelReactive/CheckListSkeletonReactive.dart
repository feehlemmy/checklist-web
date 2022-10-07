import 'package:flutter/foundation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'package:projeto_kva/ModelReactive/InterestedPartiesEmailRepository.dart';
import 'package:projeto_kva/ModelReactive/QuestionSkeletonReactive.dart';

class CheckListSkeletonReactive {
  int? id;
  RxString? title;
  RxInt? productId;
  RxString? sector;
  RxString? status;
  List<QuestionSkeletonReactive>? questions;
  List<InterestedPartiesEmailReactiveEntity>? interestedPartiesEmailList;
  CheckListSkeletonReactive({
    this.id,
    this.title,
    this.productId,
    this.sector,
    this.status,
    this.questions,
    this.interestedPartiesEmailList,
  });

  CheckListSkeletonReactive copyWith({
    int? id,
    RxString? title,
    RxInt? productId,
    RxString? sector,
    RxString? status,
    List<QuestionSkeletonReactive>? questions,
    List<InterestedPartiesEmailReactiveEntity>? interestedPartiesEmailList,
  }) {
    return CheckListSkeletonReactive(
      id: id ?? this.id,
      title: title ?? this.title,
      productId: productId ?? this.productId,
      status: status ?? this.status,
      sector: sector ?? this.sector,
      questions: questions ?? this.questions,
      interestedPartiesEmailList:
          interestedPartiesEmailList ?? this.interestedPartiesEmailList,
    );
  }

  @override
  String toString() {
    return 'CheckListSkeletonReactive(id: $id, title: $title, productId: $productId, sector: $sector,status: $status, questions: $questions, interestedPartiesEmailList: $interestedPartiesEmailList)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CheckListSkeletonReactive &&
        other.id == id &&
        other.title == title &&
        other.productId == productId &&
        other.sector == sector &&
        other.status == status &&
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
        status.hashCode ^
        questions.hashCode ^
        interestedPartiesEmailList.hashCode;
  }
}
