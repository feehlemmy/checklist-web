import 'dart:convert';

class ProducRepositoryEntity {
  int? id;
  String? name;
  String? category;
  String? status;
  ProducRepositoryEntity({
    this.id,
    this.name,
    this.category,
    this.status,
  });

  ProducRepositoryEntity copyWith({
    int? id,
    String? name,
    String? category,
    String? status,
  }) {
    return ProducRepositoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'status': status,
    };
  }

  factory ProducRepositoryEntity.fromMap(Map<String, dynamic> map) {
    return ProducRepositoryEntity(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProducRepositoryEntity.fromJson(String source) =>
      ProducRepositoryEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProducRepositoryEntity(id: $id, name: $name, category: $category, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProducRepositoryEntity &&
        other.id == id &&
        other.name == name &&
        other.category == category &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ category.hashCode ^ status.hashCode;
  }
}
