part of '../settings_entries.dart';

class DiscordWebhookUri extends SettingsEntry<String> {
  static const key = 'discord_webhook_uri';
  static final instance = DiscordWebhookUri._internal();

  factory DiscordWebhookUri() {
    return instance;
  }

  DiscordWebhookUri._internal() : super('');

  Isar get isarInstance {
    Isar? isar = Isar.getInstance();
    if (isar == null) throw Exception('Isar instance is not initialized.');
    return isar;
  }

  @override
  Future<void> ensureInitialized() => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final discordWebhookUri = await setting.getByKey(key);
        if (discordWebhookUri == null) {
          await setting.put(Setting(key: key, value: defaultValue));
        }
      });
  
  @override
  Future<String> get() => isarInstance.txn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final discordWebhookUri = await setting.getByKey(key);
        if (discordWebhookUri == null) {
          return defaultValue;
        }
        return discordWebhookUri.value;
      });
  
  @override
  Future<void> set(String value) => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final discordWebhookUri = await setting.getByKey(key);
        if (discordWebhookUri == null) {
          await setting.put(Setting(key: key, value: value));
        } else {
          await setting.put(discordWebhookUri..value = value);
        }
      });
  
  @override
  Future<void> remove() => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final discordWebhookUri = await setting.getByKey(key);
        if (discordWebhookUri != null) {
          await setting.deleteByKey(key);
        }
      });
  
  @override
  Future<void> reset() => isarInstance.writeTxn(() async {
        final isar = isarInstance;
        final setting = isar.settings;
        final discordWebhookUri = await setting.getByKey(key);
        if (discordWebhookUri != null) {
          await setting.put(discordWebhookUri..value = defaultValue);
        } else {
          await setting.put(Setting(key: key, value: defaultValue));
        }
      });
}