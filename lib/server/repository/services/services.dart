import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:developer' as developer;

import 'package:budgetman/server/data_model/budget.dart';
import 'package:budgetman/server/data_model/budget_list.dart';
import 'package:budgetman/server/data_model/categories.dart';
import 'package:budgetman/server/data_model/setting.dart';
import 'package:budgetman/server/repository/budget/budget_repository.dart';
import 'package:budgetman/server/repository/budget_list/budget_list_repository.dart';
import 'package:budgetman/server/repository/services/background_services.dart';
import 'package:budgetman/server/repository/services/notification_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class Services {
  static final Services _singleton = Services._internal();

  factory Services() {
    return _singleton;
  }

  Services._internal();

  Future<
      ({
        bool compatible,
        NotificationAppLaunchDetails? notificationAppLaunchDetails,
      })> init() async {
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
      }

      await Future.wait([
        for (final budget in await BudgetRepository().getAll())
          BudgetRepository().routineReset(budget, throwError: false),
      ]);

      final notificationServices = NotificationServices();
      await notificationServices.init();

      await BackgroundServices().init();

      getit.registerSingleton<Isar>(isar, dispose: (isar) => isar.close());

      return (
        compatible: Platform.isAndroid || Platform.isIOS,
        notificationAppLaunchDetails: await notificationServices.getNotificationAppLaunchDetails(),
      );
    } catch (e, s) {
      developer.log('Error initializing services: $e', name: 'Services', error: e, stackTrace: s);
      return (
        compatible: false,
        notificationAppLaunchDetails: null,
      );
    }
  }

  Future<void> backgroundInit() async {
    WidgetsFlutterBinding.ensureInitialized();

    final getit = GetIt.instance;

    // Initialize the database
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [BudgetSchema, BudgetListSchema, CategorySchema, SettingSchema],
      directory: dir.path,
      inspector: kDebugMode,
    );

    final notificationServices = NotificationServices();
    await notificationServices.init();

    getit.registerSingleton<Isar>(isar, dispose: (isar) => isar.close());
  }
}
