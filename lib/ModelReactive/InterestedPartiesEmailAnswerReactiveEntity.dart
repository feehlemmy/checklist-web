import 'package:get/get_rx/src/rx_types/rx_types.dart';

class InterestedPartiesEmailAnswerReactiveEntity {
  int? id;
  RxString? email;
  RxInt? checkListAnswerId;
  InterestedPartiesEmailAnswerReactiveEntity({
    this.id,
    this.email,
    this.checkListAnswerId,
  });

  InterestedPartiesEmailAnswerReactiveEntity copyWith({
    int? id,
    RxString? email,
    RxInt? checkListAnswerId,
  }) {
    return InterestedPartiesEmailAnswerReactiveEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      checkListAnswerId: checkListAnswerId ?? this.checkListAnswerId,
    );
  }

  @override
  String toString() =>
      'InterestedPartiesEmailReactiveEntity(id: $id, email: $email, checkListAnswerId: $checkListAnswerId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InterestedPartiesEmailAnswerReactiveEntity &&
        other.id == id &&
        other.email == email &&
        other.checkListAnswerId == checkListAnswerId;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ checkListAnswerId.hashCode;
}
