import 'dart:convert';

import 'ERole.dart';

class Role {
  late ERole name;
  late int id;
  Role({
    required this.name,
    required this.id,
  });

  Role copyWith({
    ERole? name,
    int? id,
  }) {
    return Role(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      name: map['name'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Role.fromJson(String source) => Role.fromMap(json.decode(source));

  @override
  String toString() => 'Role(name: $name, id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Role && other.name == name && other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
