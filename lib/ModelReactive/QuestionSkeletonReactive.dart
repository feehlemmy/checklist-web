import 'package:get/get.dart';

class QuestionSkeletonReactive {
  int? id;
  RxString? description;
  RxString? category;
  RxString? tooltip;
  RxString? position;
  QuestionSkeletonReactive(
      {this.id, this.description, this.category, this.tooltip, this.position});

  QuestionSkeletonReactive copyWith({
    int? id,
    RxString? description,
    RxString? category,
    RxString? tooltip,
    RxString? position,
  }) {
    return QuestionSkeletonReactive(
      id: id ?? this.id,
      description: description ?? this.description,
      category: category ?? this.category,
      tooltip: tooltip ?? this.tooltip,
      position: position ?? this.position,
    );
  }

  @override
  String toString() {
    return 'QuestionSkeletonReactive(id: $id, description: $description, category: $category, tooltip: $tooltip, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionSkeletonReactive &&
        other.id == id &&
        other.description == description &&
        other.category == category &&
        other.tooltip == tooltip &&
        other.position == position;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        category.hashCode ^
        position.hashCode ^
        tooltip.hashCode;
  }
}
