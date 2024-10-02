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

  final budgets = IsarLinks<Budget>();

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
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required bool isRoutine,
    int? routineInterval,
    List<Budget>? budgets,
    required bool isCompleted,
    required bool isRemoved,
    DateTime? createdDateTime,
    DateTime? updatedDateTime,
  }) {
    final budget = Budget(
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
    if (budgets != null) {
      budget.budgets.addAll(budgets);
    }
    return budget;
  }
}
