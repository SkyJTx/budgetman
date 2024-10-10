import 'package:isar/isar.dart';
import 'package:budgetman/server/data_model/categories.dart'; // ตรวจสอบให้แน่ใจว่าใช้ path ที่ถูกต้อง

class CategoryRepository {
  static get instance => CategoryRepository._internal();

  factory CategoryRepository() => instance;

  CategoryRepository._internal();

  Isar get isarInstance {
    final isar = Isar.getInstance();
    if (isar == null) {
      throw Exception('Isar instance is not initialized.');
    }
    return isar;
  }

  Future<Category> get(Id id) async {
    return isarInstance.txn(() async {
      final category = await isarInstance.categorys.get(id);
      if (category == null) {
        throw Exception('Failed to get Category with id $id');
      }
      return category;
    });
  }

  Future<void> add(Category category) async {
    await isarInstance.writeTxn(() async {
      await isarInstance.categorys.put(category);
    });
  }

  Future<void> update(Category updatedCategory) async {
    updatedCategory.updatedAt = DateTime.now();
    await isarInstance.writeTxn(() async {
      await isarInstance.categorys.put(updatedCategory);
    });
  }

  Future<void> delete(Id id) async {
    await isarInstance.writeTxn(() async {
      final success = await isarInstance.categorys.delete(id);
      if (!success) {
        throw Exception('Failed to delete Category with id $id');
      }
    });
  }

  Future<List<Category>> getAll() {
    return isarInstance.txn(() async {
      return isarInstance.categorys.where().findAll();
    });
  }
}
