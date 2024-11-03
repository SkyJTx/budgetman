import 'dart:math';

import 'package:budgetman/server/data_model/budget.dart';
import 'package:budgetman/server/data_model/budget_list.dart';
import 'package:budgetman/server/data_model/categories.dart';
import 'package:budgetman/server/data_model/setting.dart';
import 'package:budgetman/server/repository/budget/budget_repository.dart';
import 'package:budgetman/server/repository/budget_list/budget_list_repository.dart';
import 'package:budgetman/server/repository/categories/categories_repository.dart';
import 'package:budgetman/server/repository/settings/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

void main() async {
  group('Database Test', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final getit = GetIt.instance;

      // Initialize the database
      const dir = '/';
      final isar = await Isar.open(
        [BudgetSchema, BudgetListSchema, CategorySchema, SettingSchema],
        directory: dir,
      );

      getit.registerSingleton<Isar>(isar, dispose: (isar) => isar.close());
    });

    tearDownAll(() async {
      final getit = GetIt.instance;
      final isar = getit.get<Isar>();
      await isar.writeTxn(() async {
        await isar.clear();
      });
      await isar.close();
    });

    test('Add Budget', () async {
      await GetIt.I.get<Isar>().writeTxn(() async {
        await GetIt.I.get<Isar>().clear();
      });

      final budget = await BudgetRepository().add(
        name: 'Budget 1',
        description: 'Budget 1 Description',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(365.days),
        isRoutine: true,
        routineInterval: 365.days.inSeconds,
        isCompleted: false,
        isRemoved: false,
      );

      expect(budget.name, 'Budget 1');
      expect(budget.description, 'Budget 1 Description');
      expect(budget.startDate, isNotNull);
      expect(budget.endDate, isNotNull);
      expect(budget.isRoutine, true);
      expect(budget.routineInterval, 365.days.inSeconds);
      expect(budget.isCompleted, false);
    });

    test('Edit Budget', () async {
      await GetIt.I.get<Isar>().writeTxn(() async {
        await GetIt.I.get<Isar>().clear();
      });

      final budget = await BudgetRepository().add(
        name: 'Budget 1',
        description: 'Budget 1 Description',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(365.days),
        isRoutine: true,
        routineInterval: 365.days.inSeconds,
        isCompleted: false,
        isRemoved: false,
      );
      final firstBudgetId = budget.id;

      final updateBudget = await BudgetRepository().update(
        budget,
        name: 'Budget 2',
        description: 'Budget 2 Description',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(365.days),
        isRoutine: false,
        routineInterval: 30.days.inSeconds,
        isCompleted: true,
        isRemoved: true,
      );
      final secondBudgetId = updateBudget.id;

      expect(firstBudgetId, secondBudgetId);
      expect(updateBudget.name, 'Budget 2');
      expect(updateBudget.description, 'Budget 2 Description');
      expect(updateBudget.startDate, isNotNull);
      expect(updateBudget.endDate, isNotNull);
      expect(updateBudget.isRoutine, false);
      expect(updateBudget.routineInterval, 30.days.inSeconds);
      expect(updateBudget.isCompleted, true);
    });

    test('Delete Budget', () async {
      await GetIt.I.get<Isar>().writeTxn(() async {
        await GetIt.I.get<Isar>().clear();
      });

      final budget = await BudgetRepository().add(
        name: 'Budget 1',
        description: 'Budget 1 Description',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(365.days),
        isRoutine: true,
        routineInterval: 365.days.inSeconds,
        isCompleted: false,
        isRemoved: false,
      );

      await BudgetRepository().delete(budget.id);

      expect(() async => await BudgetRepository().getById(budget.id), throwsException);
    });

    test('Add Budget List', () async {
      await GetIt.I.get<Isar>().writeTxn(() async {
        await GetIt.I.get<Isar>().clear();
      });

      final budget = await BudgetRepository().add(
        name: 'Budget 1',
        description: 'Budget 1 Description',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(365.days),
        isRoutine: true,
        routineInterval: 365.days.inSeconds,
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

      final updateBudget = await BudgetRepository().getById(budget.id);

      for (final budgetList in updateBudget.budgetList) {
        expect(budgetList.title, isA<String>());
        expect(budgetList.description, isA<String>());
        expect(budgetList.priority, isPositive);
        expect(budgetList.budget, isPositive);
        expect(budgetList.deadline, isA<DateTime>());
        expect(budgetList.isCompleted, isA<bool>());
      }
    });

    test('Edit Budget List', () async {
      await GetIt.I.get<Isar>().writeTxn(() async {
        await GetIt.I.get<Isar>().clear();
      });

      final budget = await BudgetRepository().add(
        name: 'Budget 1',
        description: 'Budget 1 Description',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(365.days),
        isRoutine: true,
        routineInterval: 365.days.inSeconds,
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

      final updateBudget = await BudgetRepository().getById(budget.id);

      for (final budgetList in updateBudget.budgetList) {
        final firstBudgetListId = budgetList.id;

        final updateBudgetList = await BudgetListRepository().update(
          budgetList,
          title: 'Budget List 1',
          description: 'Budget List 1 Description',
          priority: 2,
          budget: Random().nextDouble() * 100000,
          deadline: DateTime.now().add(1.days),
          isCompleted: true,
        );
        final secondBudgetListId = updateBudgetList.id;

        expect(firstBudgetListId, secondBudgetListId);
        expect(updateBudgetList.title, isA<String>());
        expect(updateBudgetList.description, isA<String>());
        expect(updateBudgetList.priority, 2);
        expect(updateBudgetList.budget, isPositive);
        expect(updateBudgetList.deadline, isA<DateTime>());
        expect(updateBudgetList.isCompleted, true);
      }
    });

    test('Delete Budget List', () async {
      await GetIt.I.get<Isar>().writeTxn(() async {
        await GetIt.I.get<Isar>().clear();
      });

      final budget = await BudgetRepository().add(
        name: 'Budget 1',
        description: 'Budget 1 Description',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(365.days),
        isRoutine: true,
        routineInterval: 365.days.inSeconds,
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

      final updateBudget = await BudgetRepository().getById(budget.id);

      for (final budgetList in updateBudget.budgetList) {
        await BudgetListRepository().delete(budgetList.id);
      }

      final updateBudget2 = await BudgetRepository().getById(budget.id);

      expect(updateBudget2.budgetList, isEmpty);
    });

    test('Add Category', () async {
      await GetIt.I.get<Isar>().writeTxn(() async {
        await GetIt.I.get<Isar>().clear();
      });

      final category = await CategoryRepository().add(
        name: 'Category 1',
        description: 'Category 1 Description',
        colorValue: Colors.pink.value,
      );

      expect(category.name, 'Category 1');
      expect(category.description, 'Category 1 Description');
      expect(category.colorValue, Colors.pink.value);
    });

    test('Edit Category', () async {
      await GetIt.I.get<Isar>().writeTxn(() async {
        await GetIt.I.get<Isar>().clear();
      });

      final category = await CategoryRepository().add(
        name: 'Category 1',
        description: 'Category 1 Description',
        colorValue: Colors.pink.value,
      );
      final firstCategoryId = category.id;

      final updateCategory = await CategoryRepository().update(
        category,
        name: 'Category 2',
        description: 'Category 2 Description',
        colorValue: Colors.blue.value,
      );
      final secondCategoryId = updateCategory.id;

      expect(firstCategoryId, secondCategoryId);
      expect(updateCategory.name, 'Category 2');
      expect(updateCategory.description, 'Category 2 Description');
      expect(updateCategory.colorValue, Colors.blue.value);
    });

    test('Delete Category', () async {
      await GetIt.I.get<Isar>().writeTxn(() async {
        await GetIt.I.get<Isar>().clear();
      });

      final category = await CategoryRepository().add(
        name: 'Category 1',
        description: 'Category 1 Description',
        colorValue: Colors.pink.value,
      );

      await CategoryRepository().delete(category);

      expect(() async => await CategoryRepository().getById(category.id), throwsException);
    });

    test('Settings Get/Set/Reset', () async {
      await GetIt.I.get<Isar>().writeTxn(() async {
        await GetIt.I.get<Isar>().clear();
      });

      final settings = SettingsRepository();

      await settings.init();

      for (final setting in SettingsRepository.settings) {
        expect(await setting.get(), setting.defaultValue);
      }

      await settings.name.set('Test Name');
      expect(await settings.name.get(), 'Test Name');

      await settings.theme.set(ThemeMode.dark);
      expect(await settings.theme.get(), ThemeMode.dark);

      await settings.notification.set(true);
      expect(await settings.notification.get(), true);

      await settings.localNotification.set(true, requestPermission: false);
      expect(await settings.localNotification.get(), true);

      await settings.discordWebhook.set(true);
      expect(await settings.discordWebhook.get(), true);

      await settings.discordWebhookUri.set('https://discord.com');
      expect(await settings.discordWebhookUri.get(), 'https://discord.com');

      await settings.resetAll();
      for (final setting in SettingsRepository.settings) {
        expect(await setting.get(), setting.defaultValue);
      }
    });
  });
}
