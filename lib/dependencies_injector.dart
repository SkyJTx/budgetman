import 'package:budgetman/server/data_model/budget.dart';
import 'package:budgetman/server/data_model/budget_list.dart';
import 'package:budgetman/server/data_model/categories.dart';
import 'package:budgetman/server/data_model/setting.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  final getit = GetIt.instance;

  // Initialize the database
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [BudgetSchema, BudgetListSchema, CategorySchema, SettingSchema],
    directory: dir.path,
  );

  getit.registerSingleton<Isar>(isar, dispose: (isar) => isar.close());
}
