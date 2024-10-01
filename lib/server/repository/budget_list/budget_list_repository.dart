import 'package:budgetman/server/data_model/budget_list.dart';
import 'package:isar/isar.dart';

class BudgetListRepository {
  BudgetListRepository();

  Isar get isarInstance {
    Isar? isar = Isar.getInstance();
    if (isar == null) throw Exception('Isar instance is not initialized.');
    return isar;
  }

  Future<void> add(BudgetList budgetList) async {
    await isarInstance.writeTxn(() async {
      await isarInstance.budgetLists.put(budgetList);
    });
  }

  Future<void> update(BudgetList updatedBudgetList) async {
    updatedBudgetList.updatedAt = DateTime.now(); // Update the updatedAt field
    await isarInstance.writeTxn(() async {
      await isarInstance.budgetLists
          .put(updatedBudgetList); // Insert or update the object
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

  Future<List<BudgetList>> getAll() async {
    return await isarInstance.budgetLists.where().findAll();
  }

  Future<BudgetList?> getById(int id) async {
    return await isarInstance.budgetLists.get(id);
  }
}
