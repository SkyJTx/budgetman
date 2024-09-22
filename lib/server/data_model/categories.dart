
import 'dart:ui';

import 'package:isar/isar.dart';

part 'categories.g.dart';

@collection
class Category {
  Id id = Isar.autoIncrement;

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
    DateTime? createdDateTime,
    DateTime? updatedDateTime,
    required this.id,
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
}
