import 'dart:convert';
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
    int id = Isar.autoIncrement,
    required String name,
    required String description,
    required int colorValue,
    DateTime? createdDateTime,
    DateTime? updatedDateTime,
    bool isRemoved = false,
  }) {
    return Category(
      id: id,
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

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category.create(
      id: map['id'] ?? Isar.autoIncrement,
      name: map['name'] as String,
      description: map['description'] as String,
      colorValue: map['colorValue'] as int,
      createdDateTime: DateTime.parse(map['createdDateTime'] as String),
      updatedDateTime: DateTime.parse(map['updatedDateTime'] as String),
      isRemoved: map['isRemoved'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'colorValue': colorValue,
      'createdDateTime': createdAt.toIso8601String(),
      'updatedDateTime': updatedAt.toIso8601String(),
      'isRemoved': isRemoved,
    };
  }

  factory Category.fromJson(String source) => Category.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());
}
