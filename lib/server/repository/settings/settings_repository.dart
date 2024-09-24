import 'package:budgetman/server/repository/settings/settings_entries.dart';

class SettingsRepository {
  static final settings = <SettingsEntry>[
    NameSettingsEntry(),
    ThemeSettingEntry(),
  ];
  static final instance = SettingsRepository._internal();

  factory SettingsRepository() {
    return instance;
  }

  SettingsRepository._internal();

  NameSettingsEntry get name => NameSettingsEntry();
  ThemeSettingEntry get theme => ThemeSettingEntry();

  Future<void> init() async {
    await Future.wait(settings.map((e) => e.ensureInitialized()));
  }

  Future<void> resetAll() => Future.wait(settings.map((e) => e.reset()));

  @override
  String toString() {
    return 'SettingsRepository';
  }
}
