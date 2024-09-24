import 'dart:developer';

import 'package:isar/isar.dart';

import 'package:budgetman/server/data_model/categories.dart';

part 'budget_list.g.dart';

@collection
class BudgetList {
  Id id = Isar.autoIncrement;

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
    required Category category,
    required int priority,
    required int budget,
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
      budget: budget.toDouble(),
      deadline: deadline,
      isRemoved: isRemoved,
      createdDateTime: createdDateTime,
      updatedDateTime: updatedDateTime,
      image: image,
    );
    budgetList.category.value = category;
    return budgetList;
  }
}
