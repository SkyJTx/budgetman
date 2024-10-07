import 'dart:developer';

import 'package:budgetman/server/repository/settings/settings_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_state.dart';

class SettingsBloc extends Cubit<SettingsState> {
  final _settingsRepository = SettingsRepository();

  SettingsBloc()
      : super(SettingsState(
          enabledTheme: SettingsRepository().theme.defaultEnabled,
          enabledUsername: SettingsRepository().name.defaultEnabled,
          enabledNotification: SettingsRepository().notification.defaultEnabled,
          enabledLocalNotification: SettingsRepository().localNotification.defaultEnabled,
          enabledDiscordWebhook: SettingsRepository().discordWebhook.defaultEnabled,
          enabledDiscordWebhookUrl: SettingsRepository().discordWebhookUri.defaultEnabled,
          theme: SettingsRepository().theme.defaultValue,
          username: SettingsRepository().name.defaultValue,
          notification: SettingsRepository().notification.defaultValue,
          localNotification: SettingsRepository().localNotification.defaultValue,
          discordWebhook: SettingsRepository().discordWebhook.defaultValue,
          discordWebhookUrl: SettingsRepository().discordWebhookUri.defaultValue,
        ));

  Future<void> init() async {
    try {
      late final bool nameEnabled;
      late final bool themeEnabled;
      late final bool notificationEnabled;
      late final bool localNotificationEnabled;
      late final bool discordWebhookEnabled;
      late final bool discordWebhookUrlEnabled;
      late final String name;
      late final ThemeMode theme;
      late final bool notification;
      late final bool localNotification;
      late final bool discordWebhook;
      late final String discordWebhookUrl;
      await Future.wait([
        _settingsRepository.name.getEnabled().then((value) => nameEnabled = value),
        _settingsRepository.theme.getEnabled().then((value) => themeEnabled = value),
        _settingsRepository.notification.getEnabled().then((value) => notificationEnabled = value),
        _settingsRepository.localNotification
            .getEnabled()
            .then((value) => localNotificationEnabled = value),
        _settingsRepository.discordWebhook
            .getEnabled()
            .then((value) => discordWebhookEnabled = value),
        _settingsRepository.discordWebhookUri
            .getEnabled()
            .then((value) => discordWebhookUrlEnabled = value),
        _settingsRepository.name.get().then((value) => name = value),
        _settingsRepository.theme.get().then((value) => theme = value),
        _settingsRepository.notification.get().then((value) => notification = value),
        _settingsRepository.localNotification.get().then((value) => localNotification = value),
        _settingsRepository.discordWebhook.get().then((value) => discordWebhook = value),
        _settingsRepository.discordWebhookUri.get().then((value) => discordWebhookUrl = value),
      ]);
      emit(state.copyWith(
        isInitialized: true,
        isReady: true,
        enabledTheme: themeEnabled,
        enabledUsername: nameEnabled,
        enabledNotification: notificationEnabled,
        enabledLocalNotification: localNotificationEnabled,
        enabledDiscordWebhook: discordWebhookEnabled,
        enabledDiscordWebhookUrl: discordWebhookUrlEnabled,
        username: name,
        theme: theme,
        notification: notification,
        localNotification: localNotification,
        discordWebhook: discordWebhook,
        discordWebhookUrl: discordWebhookUrl,
      ));
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }

  Future<void> setName(String name) async {
    emit(state.copyWith(
      isReady: false,
      enabledUsername: await _settingsRepository.name.getEnabled(),
      username: name,
    ));
    try {
      await _settingsRepository.name.set(name);
      emit(state.copyWith(isReady: true));
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }

  Future<void> setTheme(ThemeMode theme) async {
    emit(state.copyWith(
      isReady: false,
      enabledTheme: await _settingsRepository.theme.getEnabled(),
      theme: theme,
    ));
    try {
      await _settingsRepository.theme.set(theme);
      emit(state.copyWith(isReady: true));
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }

  Future<void> setNotification(bool value) async {
    emit(state.copyWith(
      isReady: false,
      enabledNotification: await _settingsRepository.notification.getEnabled(),
      notification: value,
    ));
    try {
      await _settingsRepository.notification.set(value);
      emit(state.copyWith(
        isReady: true,
        enabledLocalNotification: await _settingsRepository.localNotification.getEnabled(),
        enabledDiscordWebhook: await _settingsRepository.discordWebhook.getEnabled(),
        enabledDiscordWebhookUrl: await _settingsRepository.discordWebhookUri.getEnabled(),
      ));
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }

  Future<void> setLocalNotification(bool value) async {
    if (!state.enabledLocalNotification) return;
    emit(state.copyWith(
      isReady: false,
      enabledLocalNotification: await _settingsRepository.localNotification.getEnabled(),
      localNotification: value,
    ));
    try {
      await _settingsRepository.localNotification.set(value);
      emit(state.copyWith(isReady: true));
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }

  Future<void> setDiscordWebhook(bool value) async {
    if (!state.enabledDiscordWebhook) return;
    emit(state.copyWith(
      isReady: false,
      enabledDiscordWebhook: await _settingsRepository.discordWebhook.getEnabled(),
      discordWebhook: value,
    ));
    try {
      await _settingsRepository.discordWebhook.set(value);
      emit(state.copyWith(
        isReady: true,
        enabledDiscordWebhookUrl: await _settingsRepository.discordWebhookUri.getEnabled(),
      ));
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }

  Future<void> setDiscordWebhookUri(String value) async {
    if (!state.enabledDiscordWebhookUrl) return;
    emit(state.copyWith(
      isReady: false,
      enabledDiscordWebhookUrl: await _settingsRepository.discordWebhookUri.getEnabled(),
      discordWebhookUrl: value,
    ));
    try {
      await _settingsRepository.discordWebhookUri.set(value);
      emit(state.copyWith(isReady: true));
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }

  Future<void> resetName() async {
    emit(state.copyWith(
      isReady: false,
      enabledUsername: await _settingsRepository.name.getEnabled(),
      username: _settingsRepository.name.defaultValue,
    ));
    try {
      await _settingsRepository.name.reset();
      emit(state.copyWith(isReady: true));
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }

  Future<void> resetTheme() async {
    emit(state.copyWith(
      isReady: false,
      enabledTheme: await _settingsRepository.theme.getEnabled(),
      theme: _settingsRepository.theme.defaultValue,
    ));
    emit(state);
    try {
      await _settingsRepository.theme.reset();
      emit(state.copyWith(isReady: true));
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }

  Future<void> resetNotification() async {
    emit(state.copyWith(
      isReady: false,
      enabledNotification: await _settingsRepository.notification.getEnabled(),
      enabledLocalNotification: await _settingsRepository.localNotification.getEnabled(),
      enabledDiscordWebhook: await _settingsRepository.discordWebhook.getEnabled(),
      enabledDiscordWebhookUrl: await _settingsRepository.discordWebhookUri.getEnabled(),
      notification: _settingsRepository.notification.defaultValue,
    ));
    try {
      await _settingsRepository.notification.reset();
      emit(state.copyWith(isReady: true));
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }

  Future<void> resetLocalNotification() async {
    if (!state.enabledLocalNotification) return;
    emit(state.copyWith(
      isReady: false,
      enabledLocalNotification: await _settingsRepository.localNotification.getEnabled(),
      localNotification: _settingsRepository.localNotification.defaultValue,
    ));
    try {
      await _settingsRepository.localNotification.reset();
      emit(state.copyWith(isReady: true));
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }

  Future<void> resetDiscordWebhook() async {
    if (!state.enabledDiscordWebhook) return;
    emit(state.copyWith(
      isReady: false,
      enabledDiscordWebhook: await _settingsRepository.discordWebhook.getEnabled(),
      discordWebhook: _settingsRepository.discordWebhook.defaultValue,
    ));
    try {
      await _settingsRepository.discordWebhook.reset();
      emit(state.copyWith(isReady: true));
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }

  Future<void> resetDiscordWebhookUri() async {
    if (!state.enabledDiscordWebhookUrl) return;
    emit(state.copyWith(
      isReady: false,
      enabledDiscordWebhookUrl: await _settingsRepository.discordWebhookUri.getEnabled(),
      discordWebhookUrl: _settingsRepository.discordWebhookUri.defaultValue,
    ));
    try {
      await _settingsRepository.discordWebhookUri.reset();
      emit(state.copyWith(isReady: true));
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }

  Future<void> resetAll() async {
    emit(state.copyWith(isReady: false));
    try {
      await SettingsRepository().resetAll();
      await init();
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }
}
