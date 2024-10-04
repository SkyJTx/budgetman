import 'dart:convert';

import 'package:budgetman/server/data_model/budget_list.dart';
import 'package:isar/isar.dart';

part 'budget.g.dart';

@collection
class Budget {
  Id id;

  @Index(
    unique: true,
    type: IndexType.value,
    caseSensitive: true,
  )
  String name;

  String description;

  @Index(
    unique: false,
    type: IndexType.value,
  )
  late DateTime startDate;

  late DateTime endDate;

  bool isRoutine;

  int? routineInterval;

  final budgetList = IsarLinks<BudgetList>();

  bool isCompleted;

  bool isRemoved;

  late DateTime createdAt;

  late DateTime updatedAt;

  Budget({
    this.id = Isar.autoIncrement,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.isRoutine,
    this.routineInterval,
    required this.isCompleted,
    required this.isRemoved,
    DateTime? createdDateTime,
    DateTime? updatedDateTime,
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
    if (isRoutine) {
      if (routineInterval == null) {
        throw ArgumentError.value(
          routineInterval,
          'routineInterval',
          'routineInterval must not be null when isRoutine is true',
        );
      }
    }
    if (startDate.isAfter(endDate)) {
      throw ArgumentError.value(
        startDate,
        'startDate',
        'startDate must be before endDate',
      );
    }
    createdAt = createdDateTime ?? DateTime.now();
    updatedAt = updatedDateTime ?? DateTime.now();
  }

  factory Budget.create({
    int id = Isar.autoIncrement,
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required bool isRoutine,
    int? routineInterval,
    List<BudgetList> budgetList = const <BudgetList>[],
    required bool isCompleted,
    required bool isRemoved,
    DateTime? createdDateTime,
    DateTime? updatedDateTime,
  }) {
    final budget = Budget(
      id: id,
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
      isRoutine: isRoutine,
      routineInterval: routineInterval,
      isCompleted: isCompleted,
      isRemoved: isRemoved,
      createdDateTime: createdDateTime,
      updatedDateTime: updatedDateTime,
    );
    
    budget.budgetList.addAll(budgetList);
    
    return budget;
  }

  Budget update({
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isRoutine,
    int? routineInterval,
    List<BudgetList>? budgetList,
    bool? isCompleted,
    bool? isRemoved,
    DateTime? createdDateTime,
    DateTime? updatedDateTime,
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
    if (isRoutine != null) {
      if (isRoutine) {
        if (routineInterval == null) {
          throw ArgumentError.value(
            routineInterval,
            'routineInterval',
            'routineInterval must not be null when isRoutine is true',
          );
        }
      }
    }
    if (startDate != null && endDate != null) {
      if (startDate.isAfter(endDate)) {
        throw ArgumentError.value(
          startDate,
          'startDate',
          'startDate must be before endDate',
        );
      }
    }
    this.name = name ?? this.name;
    this.description = description ?? this.description;
    this.startDate = startDate ?? this.startDate;
    this.endDate = endDate ?? this.endDate;
    this.isRoutine = isRoutine ?? this.isRoutine;
    this.routineInterval = routineInterval ?? this.routineInterval;
    this.isCompleted = isCompleted ?? this.isCompleted;
    this.isRemoved = isRemoved ?? this.isRemoved;
    createdAt = createdDateTime ?? createdAt;
    updatedAt = updatedDateTime ?? updatedAt;
    if (budgetList != null) {
      this.budgetList.clear();
      this.budgetList.addAll(budgetList);
    }
    return this;
  }

  Budget copyWith({
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isRoutine,
    int? routineInterval,
    List<BudgetList>? budgetList,
    bool? isCompleted,
    bool? isRemoved,
    DateTime? createdDateTime,
    DateTime? updatedDateTime,
  }) {
    return Budget.create(
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isRoutine: isRoutine ?? this.isRoutine,
      routineInterval: routineInterval ?? this.routineInterval,
      budgetList: budgetList ?? this.budgetList.toList(),
      isCompleted: isCompleted ?? this.isCompleted,
      isRemoved: isRemoved ?? this.isRemoved,
      createdDateTime: createdDateTime ?? createdAt,
      updatedDateTime: updatedDateTime ?? updatedAt,
    );
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget.create(
      id: map['id'] ?? Isar.autoIncrement,
      name: map['name'],
      description: map['description'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      isRoutine: map['isRoutine'],
      routineInterval: map['routineInterval'],
      budgetList: [
        for (final budgetList in map['budgetList'])
          BudgetList.fromMap(budgetList),
      ],
      isCompleted: map['isCompleted'],
      isRemoved: map['isRemoved'],
      createdDateTime: map['createdDateTime'],
      updatedDateTime: map['updatedDateTime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'isRoutine': isRoutine,
      'routineInterval': routineInterval,
      'budgetList': [
        for (final budgetList in budgetList)
          budgetList.toMap(),
      ],
      'isCompleted': isCompleted,
      'isRemoved': isRemoved,
      'createdDateTime': createdAt,
      'updatedDateTime': updatedAt,
    };
  }

  factory Budget.fromJson(String source) => Budget.fromMap(json.decode(source));

  toJson() => json.encode(toMap());
}
