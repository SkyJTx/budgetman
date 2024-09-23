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
          name: SettingsRepository().name.defaultValue,
          theme: SettingsRepository().theme.defaultValue,
        ));

  Future<void> init() async {
    try {
      late final String name;
      late final ThemeMode theme;
      await Future.wait([
        _settingsRepository.name.get().then((value) => name = value),
        _settingsRepository.theme.get().then((value) => theme = value),
      ]);
      emit(SettingsState(name: name, theme: theme));
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }

  Future<void> setName(String name) async {
    emit(state.copyWith(name: name));
    try {
      await _settingsRepository.name.set(name);
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }

  Future<void> setTheme(ThemeMode theme) async {
    emit(state.copyWith(theme: theme));
    try {
      await _settingsRepository.theme.set(theme);
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }

  Future<void> toggleTheme() async {
    final deviceBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (state.theme == ThemeMode.system) {
      emit(state.copyWith(
        theme: deviceBrightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark
      ));
    } else {
      emit(state.copyWith(
        theme: state.theme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark
      ));
    }

    try {
      await _settingsRepository.theme.set(state.theme);
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }

  Future<void> resetName() async {
    emit(state.copyWith(name: SettingsRepository().name.defaultValue));
    try {
      await _settingsRepository.name.reset();
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }

  Future<void> resetTheme() async {
    emit(state.copyWith(theme: SettingsRepository().theme.defaultValue));
    try {
      await _settingsRepository.theme.reset();
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }

  Future<void> resetAll() async {
    emit(SettingsState(
      name: SettingsRepository().name.defaultValue,
      theme: SettingsRepository().theme.defaultValue,
    ));
    try {
      await Future.wait([
        _settingsRepository.name.reset(),
        _settingsRepository.theme.reset(),
      ]);
    } catch (e, s) {
      log('$e', error: e, stackTrace: s);
    }
  }
}
