import 'dart:convert';

class InterestedPartiesEmailRepositoryEntity {
  int? id;
  String? email;
  int? checkListSkeletonId;
  InterestedPartiesEmailRepositoryEntity({
    this.id,
    this.email,
    this.checkListSkeletonId,
  });

  InterestedPartiesEmailRepositoryEntity copyWith({
    int? id,
    String? email,
    int? checkListSkeletonId,
  }) {
    return InterestedPartiesEmailRepositoryEntity(
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

  factory InterestedPartiesEmailRepositoryEntity.fromMap(
      Map<String, dynamic> map) {
    return InterestedPartiesEmailRepositoryEntity(
      id: map['id'],
      email: map['email'],
      checkListSkeletonId: map['checkListSkeletonId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory InterestedPartiesEmailRepositoryEntity.fromJson(String source) =>
      InterestedPartiesEmailRepositoryEntity.fromMap(json.decode(source));

  @override
  String toString() =>
      'InterestedPartiesEmail(id: $id, email: $email, checkListSkeletonId: $checkListSkeletonId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InterestedPartiesEmailRepositoryEntity &&
        other.id == id &&
        other.email == email &&
        other.checkListSkeletonId == checkListSkeletonId;
  }

  @override
  int get hashCode =>
      id.hashCode ^ email.hashCode ^ checkListSkeletonId.hashCode;
}
