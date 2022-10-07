import 'package:get/get.dart';

class UserEntityReactive {
  int? id;
  RxString? name;
  RxString? username;
  RxString? password;
  RxString? sector;
  RxString? status;
  UserEntityReactive({
    this.id,
    this.name,
    this.username,
    this.password,
    this.sector,
    this.status,
  });

  UserEntityReactive copyWith({
    int? id,
    RxString? name,
    RxString? username,
    RxString? password,
    RxString? sector,
    RxString? status,
  }) {
    return UserEntityReactive(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      sector: sector ?? this.sector,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'UserEntityReactive(id: $id, name: $name, username: $username, password: $password, sector: $sector, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserEntityReactive &&
        other.id == id &&
        other.name == name &&
        other.username == username &&
        other.password == password &&
        other.sector == sector &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        username.hashCode ^
        password.hashCode ^
        sector.hashCode ^
        status.hashCode;
  }
}
