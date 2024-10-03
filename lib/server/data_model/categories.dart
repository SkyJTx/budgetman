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

  factory Category.create({
    required String name,
    required String description,
    required int colorValue,
    DateTime? createdDateTime,
    DateTime? updatedDateTime,
    bool isRemoved = false,
  }) {
    return Category(
      name: name,
      description: description,
      colorValue: colorValue,
      createdDateTime: createdDateTime,
      updatedDateTime: updatedDateTime,
      isRemoved: isRemoved,
    );
  }

  Category update({
    String? name,
    String? description,
    int? colorValue,
    DateTime? createdDateTime,
    DateTime? updatedDateTime,
    bool? isRemoved,
  }) {
    this.name = name ?? this.name;
    this.description = description ?? this.description;
    this.colorValue = colorValue ?? this.colorValue;
    this.isRemoved = isRemoved ?? this.isRemoved;
    if (createdDateTime != null && updatedDateTime != null) {
      if (createdDateTime.isAfter(updatedDateTime)) {
        throw ArgumentError.value(
          createdDateTime,
          'createdDateTime',
          'createdDateTime must be before updatedDateTime',
        );
      }
    }
    createdAt = createdDateTime ?? createdAt;
    updatedAt = updatedDateTime ?? updatedAt;
    return this;
  }
}
