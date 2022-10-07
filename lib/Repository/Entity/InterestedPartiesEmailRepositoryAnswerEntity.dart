import 'dart:convert';

class InterestedPartiesEmailAnswerRepositoryEntity {
  int? id;
  String? email;
  int? checkListSkeletonId;
  InterestedPartiesEmailAnswerRepositoryEntity({
    this.id,
    this.email,
    this.checkListSkeletonId,
  });

  InterestedPartiesEmailAnswerRepositoryEntity copyWith({
    int? id,
    String? email,
    int? checkListSkeletonId,
  }) {
    return InterestedPartiesEmailAnswerRepositoryEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      checkListSkeletonId: checkListSkeletonId ?? this.checkListSkeletonId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'checkListSkeletonId': checkListSkeletonId,
    };
  }

  factory InterestedPartiesEmailAnswerRepositoryEntity.fromMap(
      Map<String, dynamic> map) {
    return InterestedPartiesEmailAnswerRepositoryEntity(
      id: map['id'],
      email: map['email'],
      checkListSkeletonId: map['checkListSkeletonId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory InterestedPartiesEmailAnswerRepositoryEntity.fromJson(
          String source) =>
      InterestedPartiesEmailAnswerRepositoryEntity.fromMap(json.decode(source));

  @override
  String toString() =>
      'InterestedPartiesEmailAnswerReactiveEntity(id: $id, email: $email, checkListSkeletonId: $checkListSkeletonId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InterestedPartiesEmailAnswerRepositoryEntity &&
        other.id == id &&
        other.email == email &&
        other.checkListSkeletonId == checkListSkeletonId;
  }

  @override
  int get hashCode =>
      id.hashCode ^ email.hashCode ^ checkListSkeletonId.hashCode;
}
