part of '../settings_entries.dart';

final class NotificationEntry extends SettingsEntry<bool> {
  final key = 'notification';
  static final instance = NotificationEntry._internal();

  factory NotificationEntry() {
    return instance;
  }

  NotificationEntry._internal() : super(false);

  Isar get isarInstance {
    Isar? isar = Isar.getInstance();
    if (isar == null) throw Exception('Isar instance is not initialized.');
    return isar;
  }

  @override
  Future<void> ensureInitialized() => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final notification = await setting.getByKey(key);
        if (notification == null) {
          await setting.put(Setting(key: key, value: '$defaultValue'));
        }
      });

  @override
  Future<bool> get() => isarInstance.txn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final notification = await setting.getByKey(key);
        if (notification == null) {
          return defaultValue;
        }
        final value = bool.tryParse(notification.value) ?? defaultValue;
        if (value) {
          await NotificationServices().requestPermissions();
        }
        return value;
      });

  @override
  Future<void> set(bool value) => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final notification = await setting.getByKey(key);
        if (notification == null) {
          await setting.put(Setting(key: key, value: '$value'));
        } else {
          await setting.put(notification..value = '$value');
        }
      });

  @override
  Future<void> remove() => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final notification = await setting.getByKey(key);
        if (notification != null) {
          await setting.deleteByKey(key);
        }
      });

  @override
  Future<void> reset() => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final notification = await setting.getByKey(key);
        if (notification != null) {
          await setting.put(notification..value = '$defaultValue');
        } else {
          await setting.put(Setting(key: key, value: '$defaultValue'));
        }
      });
}
