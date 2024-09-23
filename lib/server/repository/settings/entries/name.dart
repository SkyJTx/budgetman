part of '../settings_entries.dart';

final class NameSettingsEntry extends SettingsEntry<String> {
  static const key = 'name';
  static final instance = NameSettingsEntry._internal();

  factory NameSettingsEntry() {
    return instance;
  }

  NameSettingsEntry._internal() : super('User');

  Isar get isarInstance {
    Isar? isar = Isar.getInstance();
    if (isar == null) throw Exception('Isar instance is not initialized.');
    return isar;
  }

  @override
  Future<void> ensureInitialized() async {
    final isar = isarInstance;
    final setting = isar.settings;
    final name = await setting.getByKey(key);
    if (name == null) {
      await setting.put(Setting(key: key, value: defaultValue));
    }
  }

  @override
  Future<String> get() async {
    final isar = isarInstance;
    final setting = isar.settings;
    final name = await setting.getByKey(key);
    if (name == null) {
      return defaultValue;
    }
    return name.value;
  }

  @override
  Future<void> set(String value) async {
    final isar = isarInstance;
    final setting = isar.settings;
    final name = await setting.getByKey(key);
    if (name == null) {
      await setting.put(Setting(key: key, value: value));
    } else {
      await setting.put(name..value = value);
    }
  }

  @override
  Future<void> remove() async {
    final isar = isarInstance;
    final setting = isar.settings;
    final name = await setting.getByKey(key);
    if (name != null) {
      await setting.deleteByKey(key);
    }
  }

  @override
  Future<void> reset() async {
    final isar = isarInstance;
    final setting = isar.settings;
    final name = await setting.getByKey(key);
    if (name != null) {
      await setting.put(name..value = defaultValue);
    } else {
      await setting.put(Setting(key: key, value: defaultValue));
    }
  }
}
