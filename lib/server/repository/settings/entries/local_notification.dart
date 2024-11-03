part of '../settings_entries.dart';

class LocalNotification extends SettingsEntry<bool> {
  final key = 'local_notification';
  static final instance = LocalNotification._internal();

  @override
  Future<bool> getEnabled() => NotificationEntry().get();

  factory LocalNotification() {
    return instance;
  }

  LocalNotification._internal() : super(false, defaultEnabled: false);

  Isar get isarInstance {
    Isar? isar = Isar.getInstance();
    if (isar == null) throw Exception('Isar instance is not initialized.');
    return isar;
  }

  @override
  Future<void> ensureInitialized() => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final localNotification = await setting.getByKey(key);
        if (localNotification == null) {
          await setting.put(Setting(key: key, value: '$defaultValue'));
        }
      });

  @override
  Future<bool> get() => isarInstance.txn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final localNotification = await setting.getByKey(key);
        if (localNotification == null) {
          return defaultValue;
        }
        final value = bool.tryParse(localNotification.value) ?? defaultValue;
        if (value) {
          await NotificationServices().requestPermissions();
        }
        return value;
      });

  @override
  Future<void> set(bool value) => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final localNotification = await setting.getByKey(key);
        if (localNotification == null) {
          await setting.put(Setting(key: key, value: '$value'));
        } else {
          await setting.put(localNotification..value = '$value');
        }
      });

  @override
  Future<void> remove() => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final localNotification = await setting.getByKey(key);
        if (localNotification != null) {
          await setting.deleteByKey(key);
        }
      });

  @override
  Future<void> reset() => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final localNotification = await setting.getByKey(key);
        if (localNotification != null) {
          await setting.put(localNotification..value = '$defaultValue');
        } else {
          await setting.put(Setting(key: key, value: '$defaultValue'));
        }
      });
}
