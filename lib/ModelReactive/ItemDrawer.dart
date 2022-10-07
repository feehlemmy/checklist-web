import 'package:flutter/material.dart';

class ItemDrawer {
  late String name;
  late IconData iconData;
  late int index;
  ItemDrawer({
    required this.name,
    required this.iconData,
    required this.index,
  });

  ItemDrawer copyWith({
    String? name,
    IconData? iconData,
    int? index,
  }) {
    return ItemDrawer(
      name: name ?? this.name,
      iconData: iconData ?? this.iconData,
      index: index ?? this.index,
    );
  }

  @override
  String toString() =>
      'ItemDrawer(name: $name, iconData: $iconData, index: $index)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemDrawer &&
        other.name == name &&
        other.iconData == iconData &&
        other.index == index;
  }

  @override
  int get hashCode => name.hashCode ^ iconData.hashCode ^ index.hashCode;
}
