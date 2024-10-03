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

  Future<void> add(BudgetList budgetList, {required Budget budget}) =>
      isarInstance.writeTxn(() async {
        budget.budgetList.add(budgetList);
      });

  Future<void> update(BudgetList updatedBudgetList) async {
    updatedBudgetList.updatedAt = DateTime.now();
    await isarInstance.writeTxn(() async {
      await isarInstance.budgetLists.put(updatedBudgetList);
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
