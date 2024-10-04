import 'dart:convert';

import 'package:isar/isar.dart';

import 'package:budgetman/server/data_model/categories.dart';

part 'budget_list.g.dart';

@collection
class BudgetList {
  Id id;

  @Index(
    unique: true,
    type: IndexType.value,
    caseSensitive: true,
  )
  String title;

  String description;

  final category = IsarLink<Category>();

  late List<byte> imagesBytes;

  @Index(
    unique: false,
    type: IndexType.value,
  )
  int priority;

  double budget;

  late DateTime createdAt;

  late DateTime updatedAt;

  @Index(
    unique: false,
    type: IndexType.value,
  )
  DateTime deadline;

  @Index(
    unique: false,
    type: IndexType.value,
  )
  bool isCompleted;

  bool isRemoved;

  BudgetList({
    this.id = Isar.autoIncrement,
    required this.isCompleted,
    required this.title,
    required this.description,
    required this.priority,
    required this.budget,
    required this.deadline,
    required this.isRemoved,
    DateTime? createdDateTime,
    DateTime? updatedDateTime,
    List<byte>? image,
  }) {
    if (createdDateTime != null && updatedDateTime != null) {
      if (createdDateTime.isAfter(updatedDateTime)) {
        throw ArgumentError.value(
          createdAt,
          'createdAt',
          'createdAt must be before updatedAt',
        );
      }
    }
    createdAt = createdDateTime ?? DateTime.now();
    updatedAt = updatedDateTime ?? DateTime.now();
    imagesBytes = image ?? [];
  }

  factory BudgetList.create({
    Id id = Isar.autoIncrement,
    bool isCompleted = false,
    required String title,
    required String description,
    Category? category,
    required int priority,
    required double budget,
    required DateTime deadline,
    required bool isRemoved,
    DateTime? createdDateTime,
    DateTime? updatedDateTime,
    List<byte>? image,
  }) {
    final budgetList = BudgetList(
      id: id,
      isCompleted: isCompleted,
      title: title,
      description: description,
      priority: priority,
      budget: budget,
      deadline: deadline,
      isRemoved: isRemoved,
      createdDateTime: createdDateTime,
      updatedDateTime: updatedDateTime,
      image: image,
    );
    budgetList.category.value = category;
    return budgetList;
  }

  BudgetList update({
    bool? isCompleted,
    String? title,
    String? description,
    Category? category,
    int? priority,
    double? budget,
    DateTime? deadline,
    bool? isRemoved,
    DateTime? createdDateTime,
    DateTime? updatedDateTime,
    List<byte>? image,
  }) {
    if (createdDateTime != null && updatedDateTime != null) {
      if (createdDateTime.isAfter(updatedDateTime)) {
        throw ArgumentError.value(
          createdAt,
          'createdAt',
          'createdAt must be before updatedAt',
        );
      }
    }
    this.isCompleted = isCompleted ?? this.isCompleted;
    this.title = title ?? this.title;
    this.description = description ?? this.description;
    this.category.value = category;
    this.priority = priority ?? this.priority;
    this.budget = budget ?? this.budget;
    this.deadline = deadline ?? this.deadline;
    this.isRemoved = isRemoved ?? this.isRemoved;
    createdAt = createdDateTime ?? createdAt;
    updatedAt = updatedDateTime ?? updatedAt;
    imagesBytes = image ?? imagesBytes;
    return this;
  }

  BudgetList copyWith({
    bool? isCompleted,
    String? title,
    String? description,
    Category? category,
    int? priority,
    double? budget,
    DateTime? deadline,
    bool? isRemoved,
    DateTime? createdDateTime,
    DateTime? updatedDateTime,
    List<byte>? image,
  }) {
    return BudgetList.create(
      isCompleted: isCompleted ?? this.isCompleted,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category.value,
      priority: priority ?? this.priority,
      budget: budget ?? this.budget,
      deadline: deadline ?? this.deadline,
      isRemoved: isRemoved ?? this.isRemoved,
      createdDateTime: createdDateTime ?? createdAt,
      updatedDateTime: updatedDateTime ?? updatedAt,
      image: image ?? imagesBytes,
    );
  }

  factory BudgetList.fromMap(Map<String, dynamic> map) {
    return BudgetList.create(
      id: map['id'] ?? Isar.autoIncrement,
      isCompleted: map['isCompleted'] as bool,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] != null ? Category.fromMap(map['category']) : null,
      priority: map['priority'] as int,
      budget: map['budget'] as double,
      deadline: map['deadline'] as DateTime,
      isRemoved: map['isRemoved'] as bool,
      createdDateTime: map['createdAt'] as DateTime,
      updatedDateTime: map['updatedAt'] as DateTime,
      image: map['imagesBytes'] as List<byte>,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isCompleted': isCompleted,
      'title': title,
      'description': description,
      'category': category.value?.toMap(),
      'priority': priority,
      'budget': budget,
      'deadline': deadline,
      'isRemoved': isRemoved,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'imagesBytes': imagesBytes,
    };
  }

  factory BudgetList.fromJson(String source) => BudgetList.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isCompleted': isCompleted,
      'title': title,
      'description': description,
      'category': category.value?.toMap(),
      'priority': priority,
      'budget': budget,
      'deadline': deadline.toIso8601String(),
      'isRemoved': isRemoved,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'imagesBytes': imagesBytes,
    };
  }
}
