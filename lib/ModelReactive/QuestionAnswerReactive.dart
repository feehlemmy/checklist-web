import 'package:get/get.dart';

class QuestionAnswerReactive {
  int? id;
  RxString? description;
  RxString? category;
  RxString? tooltip;
  RxString? position;
  RxBool? approved;
  RxBool? disapproved;
  QuestionAnswerReactive({
    this.id,
    this.description,
    this.category,
    this.tooltip,
    this.position,
    this.approved,
    this.disapproved,
  });

  QuestionAnswerReactive copyWith({
    int? id,
    RxString? description,
    RxString? category,
    RxString? tooltip,
    RxString? position,
    RxBool? approved,
    RxBool? disapproved,
  }) {
    return QuestionAnswerReactive(
      id: id ?? this.id,
      description: description ?? this.description,
      category: category ?? this.category,
      tooltip: tooltip ?? this.tooltip,
      position: position ?? this.position,
      approved: approved ?? this.approved,
      disapproved: disapproved ?? this.disapproved,
    );
  }

  @override
  String toString() {
    return 'QuestionAnswerReactive(id: $id, description: $description, category: $category, tooltip: $tooltip,position: $position,  approved: $approved, disapproved: $disapproved)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionAnswerReactive &&
        other.id == id &&
        other.description == description &&
        other.category == category &&
        other.tooltip == tooltip &&
        other.position == position &&
        other.approved == approved &&
        other.disapproved == disapproved;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        category.hashCode ^
        tooltip.hashCode ^
        position.hashCode ^
        approved.hashCode ^
        disapproved.hashCode;
  }
}
