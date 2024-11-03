import 'dart:async';

import 'package:budgetman/server/data_model/setting.dart';
import 'package:budgetman/server/repository/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'entries/name.dart';
part 'entries/theme.dart';
part 'entries/notification.dart';
part 'entries/discord_webhook.dart';
part 'entries/local_notification.dart';
part 'entries/discord_webhook_uri.dart';

abstract interface class SettingsEntry<T extends Object> {
  final T defaultValue;
  final bool defaultEnabled;

  Future<bool> getEnabled() async => true;

  SettingsEntry(this.defaultValue, {this.defaultEnabled = true});

  Future<void> ensureInitialized();

  Future<T> get();

  Future<void> set(T value);

  Future<void> remove();

  Future<void> reset();
}
