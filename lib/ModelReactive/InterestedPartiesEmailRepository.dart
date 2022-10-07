import 'package:get/get_rx/src/rx_types/rx_types.dart';

class InterestedPartiesEmailReactiveEntity {
  int? id;
  RxString? email;
  RxInt? checkListSkeletonId;
  InterestedPartiesEmailReactiveEntity({
    this.id,
    this.email,
    this.checkListSkeletonId,
  });

  InterestedPartiesEmailReactiveEntity copyWith({
    int? id,
    RxString? email,
    RxInt? checkListSkeletonId,
  }) {
    return InterestedPartiesEmailReactiveEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      checkListSkeletonId: checkListSkeletonId ?? this.checkListSkeletonId,
    );
  }

  @override
  String toString() =>
      'InterestedPartiesEmailReactiveEntity(id: $id, email: $email, checkListSkeletonId: $checkListSkeletonId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InterestedPartiesEmailReactiveEntity &&
        other.id == id &&
        other.email == email &&
        other.checkListSkeletonId == checkListSkeletonId;
  }

  @override
  int get hashCode =>
      id.hashCode ^ email.hashCode ^ checkListSkeletonId.hashCode;
}
