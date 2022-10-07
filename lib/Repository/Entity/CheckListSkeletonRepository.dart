import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:projeto_kva/Repository/Entity/InterestedPartiesEmailRepository.dart';
import 'package:projeto_kva/Repository/Entity/QuestionSkeletonRepository.dart';

class CheckListSkeletonRepositoryEntity {
  int? id;
  String? title;
  int? productId;
  String? sector;
  String? status;

  List<QuestionSkeletonRepositoryEntity>? questionList;
  List<InterestedPartiesEmailRepositoryEntity>? interestedPartiesEmailList;
  CheckListSkeletonRepositoryEntity({
    this.id,
    this.title,
    this.productId,
    this.sector,
    this.status,
    this.questionList,
    this.interestedPartiesEmailList,
  });

  CheckListSkeletonRepositoryEntity copyWith({
    int? id,
    String? title,
    int? productId,
    String? sector,
    String? status,
    List<QuestionSkeletonRepositoryEntity>? questionList,
    List<InterestedPartiesEmailRepositoryEntity>? interestedPartiesEmailList,
  }) {
    return CheckListSkeletonRepositoryEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      productId: productId ?? this.productId,
      sector: sector ?? this.sector,
      status: status ?? this.status,
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
      'status': status,
      'questionList': questionList?.map((x) => x.toMap()).toList(),
      'interestedPartiesEmailList':
          interestedPartiesEmailList?.map((x) => x.toMap()).toList(),
    };
  }

  factory CheckListSkeletonRepositoryEntity.fromMap(Map<String, dynamic> map) {
    return CheckListSkeletonRepositoryEntity(
      id: map['id'],
      title: map['title'],
      productId: map['productId'],
      sector: map['sector'],
      status: map['status'],
      questionList: List<QuestionSkeletonRepositoryEntity>.from(
          map['questionList']
              ?.map((x) => QuestionSkeletonRepositoryEntity.fromMap(x))),
      interestedPartiesEmailList:
          List<InterestedPartiesEmailRepositoryEntity>.from(
              map['interestedPartiesEmailList']?.map(
                  (x) => InterestedPartiesEmailRepositoryEntity.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckListSkeletonRepositoryEntity.fromJson(String source) =>
      CheckListSkeletonRepositoryEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CheckListSkeletonRepositoryEntity(id: $id, title: $title, productId: $productId, sector: $sector, status: $status, questionList: $questionList, interestedPartiesEmailList: $interestedPartiesEmailList)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is CheckListSkeletonRepositoryEntity &&
        other.id == id &&
        other.title == title &&
        other.productId == productId &&
        other.sector == sector &&
        other.status == status &&
        listEquals(other.questionList, questionList) &&
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
        questionList.hashCode ^
        interestedPartiesEmailList.hashCode;
  }
}
