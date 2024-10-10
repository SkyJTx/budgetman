import 'package:budgetman/server/data_model/budget.dart';
import 'package:budgetman/server/data_model/budget_list.dart';
import 'package:isar/isar.dart';

class BudgetListRepository {
  static get instance => BudgetListRepository._internal();

  factory BudgetListRepository() {
    return instance;
  }

  BudgetListRepository._internal();

  Isar get isarInstance {
    Isar? isar = Isar.getInstance();
    if (isar == null) throw Exception('Isar instance is not initialized.');
    return isar;
  }

  Future<BudgetList> get(int id) async {
    return isarInstance.txn(() async {
      final budgetList = await isarInstance.budgetLists.get(id);
      if (budgetList == null) {
        throw Exception('Failed to get BudgetList with id $id');
      }
      return budgetList;
    });
  }

  Future<Budget> add(BudgetList budgetList, {required Budget budget}) async {
    return isarInstance.writeTxn(() async {
      budget.budgetList.add(budgetList);
      int id = await isarInstance.budgets.put(budget);
      final updatedBudget = await isarInstance.budgets.get(id);
      if (updatedBudget == null) {
        throw Exception('Failed to get budget with id $id');
      }
      return updatedBudget;
    });
  }

  Future<BudgetList> update(BudgetList updatedBudgetList) async {
    updatedBudgetList.updatedAt = DateTime.now();
    return await isarInstance.writeTxn(() async {
      int id = await isarInstance.budgetLists.put(updatedBudgetList);
      final result = await isarInstance.budgetLists.get(id);
      if (result == null) {
        throw Exception('Failed to get BudgetList with id $id');
      }
      return result;
    });
  }

  Future<void> delete(int id) async {
    await isarInstance.writeTxn(() async {
      final success = await isarInstance.budgetLists.delete(id);
      if (!success) {
        throw Exception('Failed to delete BudgetList with id $id');
      }
    });
  }

  Future<List<BudgetList>> getAllinBudget(int budgetId) async {
    return isarInstance.txn(() async {
      final budget = await isarInstance.budgets.get(budgetId);
      if (budget == null) {
        throw Exception('Failed to get budget with id $budgetId');
      }
      return budget.budgetList.toList();
    });
  }
}
