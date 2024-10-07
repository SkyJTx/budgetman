part of '../settings_entries.dart';

class DiscordWebhook extends SettingsEntry<bool> {
  static const key = 'discord_webhook';
  static final instance = DiscordWebhook._internal();

  factory DiscordWebhook() {
    return instance;
  }

  DiscordWebhook._internal() : super(false);

  Isar get isarInstance {
    Isar? isar = Isar.getInstance();
    if (isar == null) throw Exception('Isar instance is not initialized.');
    return isar;
  }

  @override
  Future<void> ensureInitialized() => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final discordWebhook = await setting.getByKey(key);
        if (discordWebhook == null) {
          await setting.put(Setting(key: key, value: '$defaultValue'));
        }
      });

  @override
  Future<bool> get() => isarInstance.txn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final discordWebhook = await setting.getByKey(key);
        if (discordWebhook == null) {
          return defaultValue;
        }
        final value = bool.tryParse(discordWebhook.value);
        return value ?? defaultValue;
      });

  @override
  Future<void> set(bool value) => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final discordWebhook = await setting.getByKey(key);
        if (discordWebhook == null) {
          await setting.put(Setting(key: key, value: '$value'));
        } else {
          await setting.put(discordWebhook..value = '$value');
        }
      });

  @override
  Future<void> remove() => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final discordWebhook = await setting.getByKey(key);
        if (discordWebhook != null) {
          await setting.deleteByKey(key);
        }
      });
  
  @override
  Future<void> reset() => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final discordWebhook = await setting.getByKey(key);
        if (discordWebhook != null) {
          await setting.put(discordWebhook..value = '$defaultValue');
        } else {
          await setting.put(Setting(key: key, value: '$defaultValue'));
        }
      });
}