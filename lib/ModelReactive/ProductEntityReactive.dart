import 'package:get/get.dart';

class ProductEntityReactive {
  int? id;
  RxString? name;
  RxString? category;
  RxString? status;

  ProductEntityReactive({this.id, this.name, this.category, this.status});

  ProductEntityReactive copyWith(
      {int? id, RxString? name, RxString? categoria, RxString? status}) {
    return ProductEntityReactive(
        id: id ?? this.id,
        name: name ?? this.name,
        category: categoria ?? this.category,
        status: status ?? this.status);
  }

  @override
  String toString() =>
      'ProductEntityReactive(id: $id, name: $name, categoria: $category, status: $status)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductEntityReactive &&
        other.id == id &&
        other.name == name &&
        other.category == category &&
        other.status == status;
  }

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ category.hashCode ^ status.hashCode;
}
