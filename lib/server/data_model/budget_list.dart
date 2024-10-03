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
}
