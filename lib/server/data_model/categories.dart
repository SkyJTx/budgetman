import 'dart:ui';

import 'package:isar/isar.dart';

part 'categories.g.dart';

@collection
class Category {
  Id id;

  @Index(
    unique: true,
    type: IndexType.value,
    caseSensitive: true,
  )
  String name;

  String description;

  int colorValue;

  late DateTime createdAt;

  late DateTime updatedAt;

  bool isRemoved;

  @ignore
  Color get color => Color(colorValue);

  Category({
    this.id = Isar.autoIncrement,
    DateTime? createdDateTime,
    DateTime? updatedDateTime,
    required this.name,
    required this.description,
    required this.colorValue,
    this.isRemoved = false,
  }) {
    if (createdDateTime != null && updatedDateTime != null) {
      if (createdDateTime.isAfter(updatedDateTime)) {
        throw ArgumentError.value(
          createdDateTime,
          'createdDateTime',
          'createdDateTime must be before updatedDateTime',
        );
      }
    }
    createdAt = createdDateTime ?? DateTime.now();
    updatedAt = updatedDateTime ?? DateTime.now();
  }

  Category copyWith({
    String? name,
    String? description,
    int? colorValue,
    DateTime? createdDateTime,
    DateTime? updatedDateTime,
    bool? isRemoved,
  }) {
    return Category(
      name: name ?? this.name,
      description: description ?? this.description,
      colorValue: colorValue ?? this.colorValue,
      createdDateTime: createdDateTime ?? createdAt,
      updatedDateTime: updatedDateTime ?? updatedAt,
      isRemoved: isRemoved ?? this.isRemoved,
    );
  }
}
