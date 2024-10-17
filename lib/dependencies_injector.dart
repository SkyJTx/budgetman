import 'dart:io';
import 'dart:math';

import 'package:budgetman/server/data_model/budget.dart';
import 'package:budgetman/server/data_model/budget_list.dart';
import 'package:budgetman/server/data_model/categories.dart';
import 'package:budgetman/server/data_model/setting.dart';
import 'package:budgetman/server/repository/budget/budget_repository.dart';
import 'package:budgetman/server/repository/budget_list/budget_list_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

Future<bool> init() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    final getit = GetIt.instance;

    // Initialize the database
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [BudgetSchema, BudgetListSchema, CategorySchema, SettingSchema],
      directory: dir.path,
      inspector: kDebugMode,
    );

    if (kDebugMode) {
      await isar.writeTxn(() async {
        await Future.wait([
          isar.budgets.clear(),
          isar.budgetLists.clear(),
          isar.categorys.clear(),
        ]);
      });
      var budget = await BudgetRepository().add(
        name: 'Budget 1',
        description: 'Budget 1 Description',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(30.days),
        isRoutine: true,
        routineInterval: 10.days.inSeconds,
        isCompleted: false,
        isRemoved: false,
      );
      for (int i = 1; i <= 30; i++) {
        await BudgetListRepository().add(
          budget,
          title: 'Budget List $i',
          description: 'Budget List $i Description',
          priority: 1,
          amount: Random().nextDouble() * 100000,
          deadline: DateTime.now().add(i.days),
          isCompleted: i % 2 == 0,
        );
      }
    }

    getit.registerSingleton<Isar>(isar, dispose: (isar) => isar.close());

    return Platform.isAndroid || Platform.isIOS;
  } catch (e, _) {
    return false;
  }
}
