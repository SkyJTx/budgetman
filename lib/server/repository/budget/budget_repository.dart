import 'package:budgetman/server/data_model/budget.dart';
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

  Future<void> add(Budget budget) async {
    await isarInstance.writeTxn(() async {
      await isarInstance.budgets.put(budget);
    });
  }

  Future<void> update(Budget updatedBudget) async {
    updatedBudget.updatedAt = DateTime.now();
    await isarInstance.writeTxn(() async {
      await isarInstance.budgets.put(updatedBudget);
    });
  }

  Future<void> delete(int id) async {
    await isarInstance.writeTxn(() async {
      final success = await isarInstance.budgets.delete(id);
      if (!success) {
        throw Exception('Failed to delete Budget with id $id');
      }
    });
  }

  Future<List<Budget>> getAll() async {
    return isarInstance.txn(() async {
      return isarInstance.budgets.where().findAll();
    });
  }
}