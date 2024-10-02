import 'package:isar/isar.dart';
import 'package:budgetman/server/data_model/categories.dart'; // ตรวจสอบให้แน่ใจว่าใช้ path ที่ถูกต้อง

class CategoryRepository {
  final Isar _isar;

  CategoryRepository(this._isar);

  /// Adds a new category to the database.
  /// Throws an exception if a category with the same name already exists.
  Future<void> addCategory(Category category) async {
    // Check if a category with the same name already exists
    final existingCategory = await _isar.categorys.getByName(category.name);
    if (existingCategory != null) {
      throw Exception('Category with name "${category.name}" already exists.');
    }

    // Set creation and update timestamps
    category.createdAt = DateTime.now();
    category.updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.categorys.put(category);
    });
  }

  /// Edits an existing category identified by [id].
  /// Throws an exception if the category does not exist or if the new name conflicts.
  Future<void> editCategory({
    required Id id,
    int? colorValue,
    String? description,
    String? name,
  }) async {
    final category = await _isar.categorys.get(id);
    if (category == null) {
      throw Exception('Category with id $id does not exist.');
    }

    // If the name is being updated, ensure it's unique
    if (name != null && name != category.name) {
      final existingCategory = await _isar.categorys.getByName(name);
      if (existingCategory != null) {
        throw Exception('Another category with name "$name" already exists.');
      }
      category.name = name;
    }

    // Update other fields if provided
    if (colorValue != null) category.colorValue = colorValue;
    if (description != null) category.description = description;

    // Update the updatedAt timestamp
    category.updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.categorys.put(category);
    });
  }

  /// Removes a category identified by [id].
  /// This performs a hard delete, removing the category from the database.
  Future<void> removeCategory(Id id) async {
    final category = await _isar.categorys.get(id);
    if (category == null) {
      throw Exception('Category with id $id does not exist.');
    }

    await _isar.writeTxn(() async {
      await _isar.categorys.delete(id);
    });
  }

  /// Retrieves a category by its unique [name].
  Future<Category?> getCategoryByName(String name) {
    return _isar.categorys.getByName(name);
  }

  /// Retrieves all categories from the database, including those that may have been removed.
  Future<List<Category>> getAllCategories() {
    return _isar.categorys.where().findAll();
  }
}