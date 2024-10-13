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
    return Budget(
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isRoutine: isRoutine ?? this.isRoutine,
      routineInterval: routineInterval ?? this.routineInterval,
      isCompleted: isCompleted ?? this.isCompleted,
      isRemoved: isRemoved ?? this.isRemoved,
      createdDateTime: createdDateTime ?? createdAt,
      updatedDateTime: updatedDateTime ?? updatedAt,
    )..budgetList.clear()..budgetList.addAll(budgetList ?? []);
  }
}
