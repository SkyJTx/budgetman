import 'package:budgetman/server/data_model/budget.dart';
import 'package:isar/isar.dart';

class BudgetRepository {
  BudgetRepository();

  // Fetches the Isar instance
  Isar get isarInstance {
    Isar? isar = Isar.getInstance();
    if (isar == null) throw Exception('Isar instance is not initialized.');
    return isar;
  }

  // Add a new Budget entry + Check Unique
  Future<void> add(Budget budget) async {
    final existingBudget = await isarInstance.budgets.getByName(budget.name);
    if (existingBudget != null) {
      throw Exception('Budget with name "${budget.name}" already exists.');
    }
    await isarInstance.writeTxn(() async {
      await isarInstance.budgets.put(budget);
    });
  }


  // Update an existing Budget entry
  Future<void> update(Budget updatedBudget) async {
    updatedBudget.updatedAt = DateTime.now(); // Update the updatedAt field
    await isarInstance.writeTxn(() async {
      await isarInstance.budgets.put(updatedBudget); // Insert or update the object
    });
  }

  // Delete a Budget entry by its ID
  Future<void> delete(int id) async {
    await isarInstance.writeTxn(() async {
      final success = await isarInstance.budgets.delete(id);
      if (!success) {
        throw Exception('Failed to delete Budget with id $id');
      }
    });
  }
  

  // Retrieve all Budget entries
  Future<List<Budget>> getAll() async {
    return await isarInstance.budgets.where().findAll();
  }

  // Retrieve a Budget entry by its ID
  Future<Budget?> getById(int id) async {
    return await isarInstance.budgets.get(id);
  }
}
