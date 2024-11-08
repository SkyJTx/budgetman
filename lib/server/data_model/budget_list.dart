import 'package:isar/isar.dart';

import 'package:budgetman/server/data_model/categories.dart';

part 'budget_list.g.dart';

@collection
class BudgetList {
  Id id;

  @Index(
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
    return BudgetList(
      isCompleted: isCompleted ?? this.isCompleted,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      budget: budget ?? this.budget,
      deadline: deadline ?? this.deadline,
      isRemoved: isRemoved ?? this.isRemoved,
      createdDateTime: createdDateTime ?? createdAt,
      updatedDateTime: updatedDateTime ?? updatedAt,
      image: image ?? imagesBytes,
    )..category.value = category ?? this.category.value;
  }
}

