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

  Future<Category> getById(Id id) async {
    return isarInstance.txn(() async {
      final category = await isarInstance.categorys.get(id);
      if (category == null) {
        throw Exception('Failed to get Category with id $id');
      }
      return category;
    });
  }

  Future<Category> getByName(String name) async {
    return isarInstance.txn(() async {
      final category = await isarInstance.categorys
          .where()
          .filter()
          .nameEqualTo(name)
          .findFirst();
      if (category == null) {
        throw Exception('Failed to get Category with name $name');
      }
      return category;
    });
  }

  Future<void> add({
    int id = Isar.autoIncrement,
    required String name,
    required String description,
    required int colorValue,
    DateTime? createdDateTime,
    DateTime? updatedDateTime,
    bool isRemoved = false,
  }) async {
    final category = Category(
      id: id,
      name: name,
      description: description,
      colorValue: colorValue,
      isRemoved: isRemoved,
      createdDateTime: createdDateTime,
      updatedDateTime: updatedDateTime,
    );
    await isarInstance.writeTxn(() async {
      await isarInstance.categorys.put(category);
    });
  }

  Future<void> update(
    Category category, {
    String? name,
    String? description,
    int? colorValue,
    DateTime? createdDateTime,
    DateTime? updatedDateTime,
    bool? isRemoved,
  }) async {
    category.name = name ?? category.name;
    category.description = description ?? category.description;
    category.colorValue = colorValue ?? category.colorValue;
    category.isRemoved = isRemoved ?? category.isRemoved;
    if (createdDateTime != null && updatedDateTime != null) {
      if (createdDateTime.isAfter(updatedDateTime)) {
        throw ArgumentError.value(
          createdDateTime,
          'createdDateTime',
          'createdDateTime must be before updatedDateTime',
        );
      }
    }
    category.createdAt = createdDateTime ?? category.createdAt;
    category.updatedAt = updatedDateTime ?? DateTime.now();
    await isarInstance.writeTxn(() async {
      await isarInstance.categorys.put(category);
    });
  }

  Future<void> delete(Category category) async {
    await isarInstance.writeTxn(() async {
      final success = await isarInstance.categorys.delete(category.id);
      if (!success) {
        throw Exception('Failed to delete Category with id ${category.id}');
      }
    });
  }

  Future<void> deleteById(Id id) async {
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
