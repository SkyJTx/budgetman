import 'package:budgetman/server/data_model/setting.dart';
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

  const SettingsEntry(this.defaultValue);

  Future<void> ensureInitialized();

  Future<T> get();

  Future<void> set(T value);

  Future<void> remove();

  Future<void> reset();
}
