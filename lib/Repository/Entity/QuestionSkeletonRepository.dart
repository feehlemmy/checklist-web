import 'dart:convert';

class QuestionSkeletonRepositoryEntity {
  int? id;
  String? description;
  String? category;
  String? tooltip;
  String? position;
  QuestionSkeletonRepositoryEntity({
    this.id,
    this.description,
    this.category,
    this.tooltip,
    this.position,
  });

  QuestionSkeletonRepositoryEntity copyWith({
    int? id,
    String? description,
    String? category,
    String? tooltip,
    String? position,
  }) {
    return QuestionSkeletonRepositoryEntity(
      id: id ?? this.id,
      description: description ?? this.description,
      category: category ?? this.category,
      tooltip: tooltip ?? this.tooltip,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'category': category,
      'tooltip': tooltip,
      'position': position,
    };
  }

  factory QuestionSkeletonRepositoryEntity.fromMap(Map<String, dynamic> map) {
    return QuestionSkeletonRepositoryEntity(
      id: map['id'],
      description: map['description'],
      category: map['category'],
      tooltip: map['tooltip'],
      position: map['position'],
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionSkeletonRepositoryEntity.fromJson(String source) =>
      QuestionSkeletonRepositoryEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QuestionSkeletonRepositoryEntity(id: $id, description: $description, category: $category, tooltip: $tooltip, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionSkeletonRepositoryEntity &&
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
        tooltip.hashCode ^
        position.hashCode;
  }
}
