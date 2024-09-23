part of '../settings_entries.dart';

final class ThemeSettingEntry extends SettingsEntry<ThemeMode> {
  static const key = 'theme';
  static final instance = ThemeSettingEntry._internal();

  factory ThemeSettingEntry() => instance;

  ThemeSettingEntry._internal() : super(ThemeMode.system);

  Isar get isarInstance {
    Isar? isar = Isar.getInstance();
    if (isar == null) throw Exception('Isar instance is not initialized.');
    return isar;
  }

  @override
  Future<void> ensureInitialized() => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final theme = await setting.getByKey(key);
        if (theme == null) {
          await setting.put(Setting(key: key, value: defaultValue.name));
        }
      });

  @override
  Future<ThemeMode> get() => isarInstance.txn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final theme = await setting.getByKey(key);
        if (theme == null) {
          return defaultValue;
        }
        return {for (final i in ThemeMode.values) i.name: i}[theme.value] ?? defaultValue;
      });

  @override
  Future<void> set(ThemeMode value) => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final theme = await setting.getByKey(key);
        if (theme == null) {
          await setting.put(Setting(key: key, value: value.name));
        } else {
          await setting.put(theme..value = value.name);
        }
      });

  @override
  Future<void> remove() => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final theme = await setting.getByKey(key);
        if (theme != null) {
          await setting.deleteByKey(key);
        }
      });

  @override
  Future<void> reset() => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final theme = await setting.getByKey(key);
        if (theme != null) {
          await setting.put(theme..value = defaultValue.name);
        } else {
          await setting.put(Setting(key: key, value: defaultValue.name));
        }
      });
}
