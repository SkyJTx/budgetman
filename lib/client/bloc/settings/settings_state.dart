part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final bool isInitialized;
  final bool isReady;
  final bool enabledTheme;
  final bool enabledUsername;
  final bool enabledNotification;
  final bool enabledLocalNotification;
  final bool enabledDiscordWebhook;
  final bool enabledDiscordWebhookUrl;
  final ThemeMode theme;
  final String username;
  final bool notification;
  final bool localNotification;
  final bool discordWebhook;
  final String discordWebhookUrl;

  const SettingsState({
    this.isInitialized = false,
    this.isReady = false,
    required this.enabledTheme,
    required this.enabledUsername,
    required this.enabledNotification,
    required this.enabledLocalNotification,
    required this.enabledDiscordWebhook,
    required this.enabledDiscordWebhookUrl,
    required this.theme,
    required this.username,
    required this.notification,
    required this.localNotification,
    required this.discordWebhook,
    required this.discordWebhookUrl,
  });

  SettingsState copyWith({
    bool? isInitialized,
    bool? isReady,
    bool? enabledTheme,
    bool? enabledUsername,
    bool? enabledNotification,
    bool? enabledLocalNotification,
    bool? enabledDiscordWebhook,
    bool? enabledDiscordWebhookUrl,
    ThemeMode? theme,
    String? username,
    bool? notification,
    bool? localNotification,
    bool? discordWebhook,
    String? discordWebhookUrl,
  }) {
    return SettingsState(
      isInitialized: isInitialized ?? this.isInitialized,
      isReady: isReady ?? this.isReady,
      enabledTheme: enabledTheme ?? this.enabledTheme,
      enabledUsername: enabledUsername ?? this.enabledUsername,
      enabledNotification: enabledNotification ?? this.enabledNotification,
      enabledLocalNotification: enabledLocalNotification ?? this.enabledLocalNotification,
      enabledDiscordWebhook: enabledDiscordWebhook ?? this.enabledDiscordWebhook,
      enabledDiscordWebhookUrl: enabledDiscordWebhookUrl ?? this.enabledDiscordWebhookUrl,
      theme: theme ?? this.theme,
      username: username ?? this.username,
      notification: notification ?? this.notification,
      localNotification: localNotification ?? this.localNotification,
      discordWebhook: discordWebhook ?? this.discordWebhook,
      discordWebhookUrl: discordWebhookUrl ?? this.discordWebhookUrl,
    );
  }

  @override
  List<Object> get props => [
        isInitialized,
        isReady,
        enabledTheme,
        enabledUsername,
        enabledNotification,
        enabledLocalNotification,
        enabledDiscordWebhook,
        enabledDiscordWebhookUrl,
        theme,
        username,
        notification,
        localNotification,
        discordWebhook,
        discordWebhookUrl,
      ];

  @override
  String toString() {
    return 'Settings ${{
      'isInitialized': isInitialized,
      'isReady': isReady,
      'enabledTheme': enabledTheme,
      'enabledUsername': enabledUsername,
      'enabledNotification': enabledNotification,
      'enabledLocalNotification': enabledLocalNotification,
      'enabledDiscordWebhook': enabledDiscordWebhook,
      'enabledDiscordWebhookUrl': enabledDiscordWebhookUrl,
      'theme': theme,
      'username': username,
      'notification': notification,
      'localNotification': localNotification,
      'discordWebhook': discordWebhook,
      'discordWebhookUrl': discordWebhookUrl,
    }}';
  }
}
