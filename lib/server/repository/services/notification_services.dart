import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:budgetman/client/presentation/budget/budget_page.dart';
import 'package:budgetman/client/presentation/categories/categories_page.dart';
import 'package:budgetman/client/presentation/home/home_page.dart';
import 'package:budgetman/client/presentation/setting/setting_page.dart';
import 'package:budgetman/client/repository/global_repo.dart';
import 'package:budgetman/server/repository/budget/budget_repository.dart';
import 'package:budgetman/server/repository/services/notification_payload.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String channelId = 'Notification';
  static const String channelName = 'Local Notification';

  NotificationServices._();

  static final NotificationServices instance = NotificationServices._();

  factory NotificationServices() {
    return instance;
  }

  Future<void> init() async {
    const initAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initIOS = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: initAndroid,
      iOS: initIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      late bool exactAlarmPermission;
      late bool notificationPermission;
      await Future.wait([
        _flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
                ?.requestExactAlarmsPermission()
                .then(
                  (value) => exactAlarmPermission = value ?? false,
                )
                .onError(
                  (error, stackTrace) => exactAlarmPermission = false,
                ) ??
            Future(
              () => exactAlarmPermission = false,
            ),
        _flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
                ?.requestNotificationsPermission()
                .then(
                  (value) => notificationPermission = value ?? false,
                )
                .onError(
                  (error, stackTrace) => notificationPermission = false,
                ) ??
            Future(
              () => notificationPermission = false,
            ),
      ]);
      return exactAlarmPermission && notificationPermission;
    } else if (Platform.isIOS) {
      late bool alertPermission;
      await _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(
                alert: true,
                badge: true,
                sound: true,
              )
              .then(
                (value) => alertPermission = value ?? false,
              )
              .onError(
                (error, stackTrace) => alertPermission = false,
              ) ??
          Future(
            () => alertPermission = false,
          );
      return alertPermission;
    }
    throw UnsupportedError('Unsupported platform');
  }

  Future<void> showInstantNotification(String title, String body, {String? payload}) async {
    const android = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.high,
      priority: Priority.high,
    );
    const iOS = DarwinNotificationDetails();
    const platform = NotificationDetails(
      android: android,
      iOS: iOS,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platform,
      payload: payload,
    );
  }

  Future<NotificationAppLaunchDetails?> getNotificationAppLaunchDetails() async {
    return _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  }

  @pragma('vm:entry-point')
  FutureOr<void> onDidReceiveNotificationResponse(NotificationResponse res) async {
    try {
      final payload = NotificationPayload.fromJson(res.payload ?? '');
      if (payload.path == '/${BudgetPage.routeName}') {
        final budget = await BudgetRepository().getById(int.parse(payload.extra as String));
        ClientRepository().router.go('/${BudgetPage.routeName}', extra: budget);
      } else if (payload.path == HomePage.routeName) {
        ClientRepository().router.go(BudgetPage.routeName);
      } else if (payload.path == '/${CategoriesPage.routeName}') {
        ClientRepository().router.go('/${CategoriesPage.routeName}');
      } else if (payload.path == '/${SettingPage.routeName}') {
        ClientRepository().router.go('/${SettingPage.routeName}');
      } else {
        log('Unknown path: ${payload.path}', name: 'NotificationServices');
      }
    } catch (e, s) {
      log('Error: $e\n$s', name: 'NotificationServices', error: e, stackTrace: s);
    }
  }
}
