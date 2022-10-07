import 'dart:convert';

import 'Role.dart';

class UserRepositoryEntity {
  int? id;
  String? name;
  String? username;
  String? password;
  String? sector;
  String? status;
  List<Role>? roles;
  String? jwt;
  UserRepositoryEntity({
    this.id,
    this.name,
    this.username,
    this.password,
    this.sector,
    this.status,
    this.roles,
    this.jwt,
  });

  UserRepositoryEntity copyWith({
    int? id,
    String? name,
    String? username,
    String? password,
    String? sector,
    String? status,
    List<Role>? roles,
    String? jwt,
  }) {
    return UserRepositoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      sector: sector ?? this.sector,
      status: status ?? this.status,
      roles: roles ?? this.roles,
      jwt: jwt ?? this.jwt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
      'sector': sector,
      'status': status,
      'roles': roles,
      'jwt': jwt,
    };
  }

  factory UserRepositoryEntity.fromMap(Map<String, dynamic> map) {
    return UserRepositoryEntity(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      password: map['password'],
      sector: map['sector'],
      status: map['status'],
      jwt: map['jwt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRepositoryEntity.fromJson(String source) =>
      UserRepositoryEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserRepositoryEntity(id: $id, name: $name, username: $username, password: $password, sector: $sector, status: $status, roles: $roles, jwt: $jwt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserRepositoryEntity &&
        other.id == id &&
        other.name == name &&
        other.username == username &&
        other.password == password &&
        other.sector == sector &&
        other.status == status &&
        other.roles == roles &&
        other.jwt == jwt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        username.hashCode ^
        password.hashCode ^
        sector.hashCode ^
        status.hashCode ^
        roles.hashCode ^
        jwt.hashCode;
  }
}
