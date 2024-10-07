import 'package:budgetman/server/repository/settings/settings_entries.dart';

class SettingsRepository {
  static final settings = <SettingsEntry>[
    NameSettingsEntry(),
    ThemeSettingEntry(),
    NotificationEntry(),
    LocalNotification(),
    DiscordWebhook(),
  ];
  static final instance = SettingsRepository._internal();

  factory SettingsRepository() {
    return instance;
  }

  SettingsRepository._internal();

  NameSettingsEntry get name => NameSettingsEntry();
  ThemeSettingEntry get theme => ThemeSettingEntry();
  NotificationEntry get notification => NotificationEntry();
  LocalNotification get localNotification => LocalNotification();
  DiscordWebhook get discordWebhook => DiscordWebhook();

  Future<void> init() async {
    await Future.wait(settings.map((e) => e.ensureInitialized()));
  }

  Future<void> resetAll() => Future.wait(settings.map((e) => e.reset()));

  @override
  String toString() {
    return 'Settings Repository';
  }
}
