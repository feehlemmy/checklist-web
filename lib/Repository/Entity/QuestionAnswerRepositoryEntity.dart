import 'dart:convert';

class QuestionAnswerRepositoryEntity {
  int? id;
  String? description;
  String? category;
  String? tooltip;
  bool? approved;
  bool? disapproved;
  String? position;
  QuestionAnswerRepositoryEntity({
    this.id,
    this.description,
    this.category,
    this.tooltip,
    this.approved,
    this.disapproved,
    this.position,
  });

  QuestionAnswerRepositoryEntity copyWith({
    int? id,
    String? description,
    String? category,
    String? tooltip,
    bool? approved,
    bool? disapproved,
    String? position,
  }) {
    return QuestionAnswerRepositoryEntity(
      id: id ?? this.id,
      description: description ?? this.description,
      category: category ?? this.category,
      tooltip: tooltip ?? this.tooltip,
      approved: approved ?? this.approved,
      disapproved: disapproved ?? this.disapproved,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'category': category,
      'tooltip': tooltip,
      'approved': approved,
      'disapproved': disapproved,
      'position': position,
    };
  }

  factory QuestionAnswerRepositoryEntity.fromMap(Map<String, dynamic> map) {
    return QuestionAnswerRepositoryEntity(
      id: map['id'],
      description: map['description'],
      category: map['category'],
      tooltip: map['tooltip'],
      approved: map['approved'],
      disapproved: map['disapproved'],
      position: map['position'],
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionAnswerRepositoryEntity.fromJson(String source) =>
      QuestionAnswerRepositoryEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QuestionAnswerRepositoryEntity(id: $id, description: $description, category: $category, tooltip: $tooltip, approved: $approved, disapproved: $disapproved, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionAnswerRepositoryEntity &&
        other.id == id &&
        other.description == description &&
        other.category == category &&
        other.tooltip == tooltip &&
        other.approved == approved &&
        other.disapproved == disapproved &&
        other.position == position;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        category.hashCode ^
        tooltip.hashCode ^
        approved.hashCode ^
        disapproved.hashCode ^
        position.hashCode;
  }
}
