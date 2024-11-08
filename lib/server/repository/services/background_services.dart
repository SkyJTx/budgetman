import 'dart:convert';
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
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<void> sendBudgetNotification(
  String webhookUrl,
  String deadline, {
  String title = "⏳ Budget Deadline Alert",
  String description =
      "Your monthly budget is approaching its deadline. Please review remaining funds and allocate accordingly.",
  String avatarUrl = "https://i.imgur.com/ZZTOM2p.png",
}) async {
  try {
    final currentTime = DateTime.now().toUtc().add(const Duration(hours: 7));
    final DateFormat formatter = DateFormat("MMMM dd, yyyy 'at' HH:mm '(GMT+7)'");
    final formattedTime = formatter.format(currentTime);

    final embed = {
      "title": title,
      "description": description,
      "color": 16711680,
      "fields": [
        {"name": "🕒 Deadline", "value": deadline, "inline": false},
        {"name": "💰 Status", "value": "Approaching deadline, review budget!", "inline": false}
      ],
      "footer": {"text": "Budgetman Notification • $formattedTime", "icon_url": avatarUrl}
    };

    final data = {
      "username": "Budgetman",
      "avatar_url": avatarUrl,
      "embeds": [embed]
    };

    final response = await http.post(
      Uri.parse(webhookUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 204) {
      log("Notification sent successfully!");
    } else {
      log("Failed to send notification. Status code: ${response.statusCode}");
    }
  } catch (e, stackTrace) {
    log("Exception occurred while sending notification: $e", stackTrace: stackTrace);
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // log('Background task $task with input $inputData');
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

        log(
          'Notification: $isNotificationEnabled, Local Notification: $isLocalNotificationEnabled, Discord Webhook: $isDiscordWebhookEnabled, Discord Webhook URI: $discordWebhookUri',
        );

        if (isNotificationEnabled && isLocalNotificationEnabled) {
          await NotificationServices().showInstantNotification(
            'Summary for Today Budgets',
            'There are ${result.deadlineBudgetLists.length} budgets past deadline, ${result.resetBudgets.length} budgets with routine reset, ${result.deadlineBudgetLists.length} budget lists on deadline today.',
            payload: const NotificationPayload(
              path: HomePage.routeName,
            ).toJson(),
          );
        }
        if (isNotificationEnabled && isDiscordWebhookEnabled && discordWebhookUri.isNotEmpty) {
          try {
            log("Sending Discord webhook notification");
            String deadline = DateFormat('yyyy-MM-dd').format(DateTime.now());
            String title = "📊 Budget Summary for Today";
            String description =
                "There are:\n1. **${result.deadlineBudgetLists.length}** budgets past deadline\n2. **${result.resetBudgets.length}** budgets with routine reset\n3. **${result.deadlineBudgetLists.length}** budget lists on deadline today";

            await sendBudgetNotification(
              discordWebhookUri,
              deadline,
              title: title,
              description: description,
            );
          } catch (e, stackTrace) {
            log("Error sending Discord webhook: $e", stackTrace: stackTrace);
          }
        }
      default:
        log('Task $task is not implemented');
    }
    return true;
  });
}

class BackgroundServices {
  static final instance = BackgroundServices._internal();

  factory BackgroundServices() {
    return instance;
  }

  BackgroundServices._internal();

  /// Initializes the background services by setting up periodic tasks.
  Future<void> init() async {
    if (kDebugMode) {
      await Workmanager().cancelAll();
      await Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
      await Future.wait([
        for (final task in ['sync'].indexed)
          Workmanager().registerPeriodicTask(
            task.$1.toString(),
            task.$2,
            tag: task.$2,
            frequency: const Duration(minutes: 15),
            inputData: <String, dynamic>{'test': 'value'},
            backoffPolicy: BackoffPolicy.linear,
            backoffPolicyDelay: const Duration(minutes: 15),
          )
      ]);
      return;
    }
    await Workmanager().cancelAll();
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
    final current = TimeOfDay.now();
    await Future.wait([
      for (final task in ['sync'].indexed)
        Workmanager().registerPeriodicTask(
          task.$1.toString(),
          task.$2,
          tag: task.$2,
          initialDelay: Duration(
            hours: (Constant.backgroundCheckTime.hour - current.hour) % 24,
            minutes: (Constant.backgroundCheckTime.minute - current.minute) % 60,
          ),
          frequency: Constant.backgroundCheckInterval,
          backoffPolicy: BackoffPolicy.linear,
          backoffPolicyDelay: const Duration(minutes: 15),
        )
    ]);
  }
}
