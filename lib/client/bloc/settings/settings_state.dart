part of 'settings_bloc.dart';


class SettingsState extends Equatable {
  final String name;
  final ThemeMode theme;

  const SettingsState({
    required this.name,
    required this.theme,
  });

  SettingsState copyWith({
    String? name,
    ThemeMode? theme,
  }) {
    return SettingsState(
      name: name ?? this.name,
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object> get props => [name, theme];
}