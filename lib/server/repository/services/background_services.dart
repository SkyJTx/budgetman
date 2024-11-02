import 'dart:developer';

import 'package:budgetman/client/presentation/home/home_page.dart';
import 'package:budgetman/server/constant/constant.dart';
import 'package:budgetman/server/repository/budget/budget_repository.dart';
import 'package:budgetman/server/repository/services/notification_payload.dart';
import 'package:budgetman/server/repository/services/notification_services.dart';
import 'package:budgetman/server/repository/settings/settings_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
class BackgroundServices {
  static final periodicServiceEntries =
      <String, Future<bool> Function(Map<String, dynamic>? inputData)>{
    'sync': (inputData) async {
      final result = await BudgetRepository().backgroundTask();
      if (await SettingsRepository().notification.get()) {
        await NotificationServices().showInstantNotification(
          'Summary for Today Budgets',
          'There are \n 1. ${result.deadlineBudgetLists.length} budgets past deadline\n 2. ${result.resetBudgets.length} budgets with routine reset \n 3. ${result.deadlineBudgetLists.length} budget lists on deadline today',
          payload: const NotificationPayload(
            path: HomePage.routeName,
          ).toJson(),
        );
      }
      return true;
    },
  };

  static final instance = BackgroundServices._internal();

  factory BackgroundServices() {
    return instance;
  }

  BackgroundServices._internal();

  Future<void> init() async {
    Workmanager().cancelAll();
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
    final current = TimeOfDay.now();
    await Future.wait([
      for (final entry in periodicServiceEntries.entries)
        Workmanager().registerPeriodicTask(
          entry.key,
          entry.key,
          frequency: 1.hours,
          // initialDelay: Duration(
          //   hours: (Constant.backgroundCheckTime.hour - current.hour) % 24,
          //   minutes: (Constant.backgroundCheckTime.minute - current.minute) % 60,
          // ),
          // frequency: Constant.backgroundCheckInterval,
        )
    ]);
  }

  @pragma('vm:entry-point')
  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      // final entry = periodicServiceEntries[task];
      // if (entry != null) {
      //   return await entry(inputData);
      // }
      log('Task $task is doing...');
      return true;
    });
  }
}
