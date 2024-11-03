import 'dart:developer';

import 'package:budgetman/client/presentation/home/home_page.dart';
import 'package:budgetman/server/constant/constant.dart';
import 'package:budgetman/server/repository/budget/budget_repository.dart';
import 'package:budgetman/server/repository/services/notification_payload.dart';
import 'package:budgetman/server/repository/services/notification_services.dart';
import 'package:budgetman/server/repository/services/services.dart';
import 'package:budgetman/server/repository/settings/settings_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundServices {
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
      for (final taskName in ['sync'])
        Workmanager().registerPeriodicTask(
          taskName,
          taskName,
          initialDelay: Duration(
            hours: (Constant.backgroundCheckTime.hour - current.hour) % 24,
            minutes: (Constant.backgroundCheckTime.minute - current.minute) % 60,
          ),
          frequency: Constant.backgroundCheckInterval,
          inputData: <String, dynamic>{'test': 'value'},
        )
    ]);
  }

  @pragma('vm:entry-point')
  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      log('Background task $task with input $inputData');
      switch (task) {
        case 'sync':
          await Services().backgroundInit();
          final result = await BudgetRepository().backgroundTask();

          late final bool isNotificationEnabled;
          late final bool isLocalNotificationEnabled;
          late final bool isDiscordWebhookEnabled;
          late final String discordWebhookUri;

          await Future.wait([
            SettingsRepository().notification.get().then((value) => isNotificationEnabled = value),
            SettingsRepository()
                .localNotification
                .get()
                .then((value) => isLocalNotificationEnabled = value),
            SettingsRepository()
                .discordWebhook
                .get()
                .then((value) => isDiscordWebhookEnabled = value),
            SettingsRepository().discordWebhookUri.get().then((value) => discordWebhookUri = value),
          ]);

          if (isNotificationEnabled && isLocalNotificationEnabled) {
            await NotificationServices().showInstantNotification(
              'Summary for Today Budgets',
              'There are \n 1. ${result.deadlineBudgetLists.length} budgets past deadline\n 2. ${result.resetBudgets.length} budgets with routine reset \n 3. ${result.deadlineBudgetLists.length} budget lists on deadline today',
              payload: const NotificationPayload(
                path: HomePage.routeName,
              ).toJson(),
            );
          } else if (isNotificationEnabled &&
              isDiscordWebhookEnabled &&
              discordWebhookUri.isNotEmpty) {
            //TODO: Implement Discord Webhook
          }
        default:
          log('Task $task is not implemented');
      }
      return true;
    });
  }
}
