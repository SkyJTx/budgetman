import 'package:budgetman/server/data_model/budget.dart';
import 'package:budgetman/server/data_model/budget_list.dart';
import 'package:budgetman/server/data_model/categories.dart';
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

  Future<BudgetList> getById(int id) async {
    return isarInstance.txn(() async {
      final budgetList = await isarInstance.budgetLists.get(id);
      if (budgetList == null) {
        throw Exception('Failed to get BudgetList with id $id');
      }
      return budgetList;
    });
  }

  Future<Budget> add(
    Budget budget, {
    Id id = Isar.autoIncrement,
    bool isCompleted = false,
    required String title,
    required String description,
    Category? category,
    required int priority,
    required double amount,
    required DateTime deadline,
    required bool isRemoved,
    DateTime? createdDateTime,
    DateTime? updatedDateTime,
    List<byte>? image,
  }) async {
    return await isarInstance.writeTxn(() async {
      final newBudgetList = BudgetList(
        id: id,
        isCompleted: isCompleted,
        title: title,
        description: description,
        priority: priority,
        budget: amount,
        deadline: deadline,
        isRemoved: isRemoved,
        createdDateTime: createdDateTime,
        updatedDateTime: updatedDateTime,
        image: image,
      );
      await isarInstance.budgetLists.put(newBudgetList);
      if (category != null) {
        newBudgetList.category.value = category;
        await newBudgetList.category.save();
      }
      budget.budgetList.add(newBudgetList);
      await budget.budgetList.save();
      return budget;
    });
  }

  Future<BudgetList> update(
    BudgetList budgetList, {
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
  }) async {
    return await isarInstance.writeTxn(() async {
      budgetList.isCompleted = isCompleted ?? budgetList.isCompleted;
      budgetList.title = title ?? budgetList.title;
      budgetList.description = description ?? budgetList.description;
      budgetList.priority = priority ?? budgetList.priority;
      budgetList.budget = budget ?? budgetList.budget;
      budgetList.deadline = deadline ?? budgetList.deadline;
      budgetList.isRemoved = isRemoved ?? budgetList.isRemoved;
      budgetList.createdAt = createdDateTime ?? budgetList.createdAt;
      budgetList.updatedAt = updatedDateTime ?? DateTime.now();
      budgetList.imagesBytes = image ?? budgetList.imagesBytes;
      if (category != null) {
        budgetList.category.value = category;
        await budgetList.category.save();
      }
      await isarInstance.budgetLists.put(budgetList);
      return budgetList;
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

  Future<void> deleteAll({required Budget budget}) async {
    await isarInstance.writeTxn(() async {
      budget.budgetList.clear();
      await budget.budgetList.save();
    });
  }

  Future<List<BudgetList>> getAllinBudget(Budget budget) async {
    final id = budget.id;
    return await isarInstance.txn(() async {
      final budget = await isarInstance.budgets.get(id);
      if (budget == null) {
        throw Exception('Failed to get budget with id $id');
      }
      return budget.budgetList.toList();
    });
  }
}
