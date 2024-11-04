import 'package:budgetman/server/data_model/budget.dart';
import 'package:budgetman/server/data_model/budget_list.dart';
import 'package:budgetman/server/repository/budget_list/budget_list_repository.dart';
import 'package:isar/isar.dart';

class BudgetRepository {
  static get instance => BudgetRepository._internal();

  factory BudgetRepository() {
    return instance;
  }

  BudgetRepository._internal();

  Isar get isarInstance {
    Isar? isar = Isar.getInstance();
    if (isar == null) throw Exception('Isar instance is not initialized.');
    return isar;
  }

  Future<Budget> getById(int id) async {
    return isarInstance.txn(() async {
      final budget = await isarInstance.budgets.get(id);
      if (budget == null) {
        throw Exception('Failed to get Budget with id $id');
      }
      return budget;
    });
  }

  Future<Budget> getByName(String name) async {
    return isarInstance.txn(() async {
      final budget = await isarInstance.budgets.where().filter().nameEqualTo(name).findFirst();
      if (budget == null) {
        throw Exception('Failed to get Budget with name $name');
      }
      return budget;
    });
  }

  Future<Budget> add({
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
  }) async {
    final newBudget = Budget(
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
    await isarInstance.writeTxn(() async {
      await isarInstance.budgets.put(newBudget);
      newBudget.budgetList.addAll(budgetList);
      await newBudget.budgetList.save();
    });
    return newBudget;
  }

  Future<Budget> update(
    Budget budget, {
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
  }) async {
    budget.name = name ?? budget.name;
    budget.description = description ?? budget.description;
    budget.startDate = startDate ?? budget.startDate;
    budget.endDate = endDate ?? budget.endDate;
    budget.isRoutine = isRoutine ?? budget.isRoutine;
    budget.routineInterval = routineInterval ?? budget.routineInterval;
    budget.isCompleted = isCompleted ?? budget.isCompleted;
    budget.isRemoved = isRemoved ?? budget.isRemoved;
    budget.updatedAt = updatedDateTime ?? DateTime.now();
    await isarInstance.writeTxn(() async {
      await isarInstance.budgets.put(budget);
      if (budgetList != null) {
        budget.budgetList.clear();
        budget.budgetList.addAll(budgetList);
        await budget.budgetList.save();
      }
    });
    return budget;
  }

  Future<void> delete(int id) async {
    await isarInstance.writeTxn(() async {
      final success = await isarInstance.budgets.delete(id);
      if (!success) {
        throw Exception('Failed to delete Budget with id $id');
      }
    });
  }

  Future<void> deleteAll() async {
    await isarInstance.writeTxn(() async {
      await isarInstance.budgets.clear();
    });
  }

  Future<List<Budget>> getAll() async {
    return isarInstance.txn(() async {
      return isarInstance.budgets.where().filter().isRemovedEqualTo(false).findAll();
    });
  }

  Future<Budget> routineReset(Budget budget, {bool throwError = true}) async {
    Future<Budget> inside() async {
      if (!budget.isRoutine || budget.routineInterval == null) {
        throw Exception('Budget is not routine mode');
      }

      final newStartDate = budget.startDate.add(Duration(days: budget.routineInterval!));

      if (budget.isCompleted) {
        throw Exception('Budget is already completed');
      }
      if (budget.isRemoved) {
        throw Exception('Budget is removed');
      }
      if (DateTime.now().isBefore(newStartDate)) {
        throw Exception('Budget is not ended yet');
      }

      final newBudget = await update(
        budget,
        startDate: newStartDate,
        endDate: newStartDate.add(budget.intervalDuration!),
        updatedDateTime: DateTime.now(),
      );
      return isarInstance.writeTxn(() async {
        await Future.wait([
          for (final budgetList in newBudget.budgetList)
            if (!budgetList.isRemoved)
              BudgetListRepository().update(
                budgetList,
                isCompleted: false,
                updatedDateTime: DateTime.now(),
                deadline: newStartDate.add(newBudget.intervalDuration!),
                image: [],
              ),
        ]);
        return budget;
      });
    }

    if (throwError) {
      return await inside();
    } else {
      try {
        return await inside();
      } catch (e) {
        return budget;
      }
    }
  }

  Future<
      ({
        List<Budget> expiredBudgets,
        List<Budget> resetBudgets,
        List<BudgetList> deadlineBudgetLists,
      })> backgroundTask() async {
    final expiredBudgets = <Budget>[];
    final resetBudgets = <Budget>[];
    final deadlineBudgetLists = <BudgetList>[];

    final budgets = await getAll();
    for (final budget in budgets) {
      if (budget.isRemoved) {
        continue;
      }

      if (DateTime.now().isAfter(budget.endDate)) {
        expiredBudgets.add(budget);
      }

      try {
        final resetBudget = await routineReset(budget, throwError: true);
        resetBudgets.add(resetBudget);
      } catch (e) {
        // Do nothing
      }

      for (final budgetList in budget.budgetList) {
        if (budgetList.isRemoved) {
          continue;
        }

        if (DateTime.now().isAfter(budgetList.deadline)) {
          deadlineBudgetLists.add(budgetList);
        }
      }
    }

    return (
      expiredBudgets: expiredBudgets,
      resetBudgets: resetBudgets,
      deadlineBudgetLists: deadlineBudgetLists,
    );
  }

  Future<double> getTotalAmountForBudget(int budgetId) async {
    final budget = await getById(budgetId);
    await budget.budgetList.load();
    double totalAmount = 0.0;
    for (var budgetListItem in budget.budgetList) {
      totalAmount += budgetListItem.budget;
    }
    return totalAmount;
  }

  Future<Budget?> getBudgetForBudgetList(int budgetListId) async {
    return await isarInstance.budgets
        .filter()
        .budgetList((q) => q.idEqualTo(budgetListId))
        .findFirst();
  }
}
