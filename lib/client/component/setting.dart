import 'dart:async';

import 'package:budgetman/client/component/value_notifier/value_change_notifier.dart';

class Setting<T> {
  final String key;
  late final ValueChangeNotifier<bool> _enabled;
  late final ValueChangeNotifier<T> _value;
  final FutureOr<void> Function(ValueChangeNotifier<bool>, ValueChangeNotifier<T>) getter;
  final FutureOr<void> Function(ValueChangeNotifier<bool>, ValueChangeNotifier<T>) setter;

  Setting({
    required this.key,
    required ValueChangeNotifier<bool> enabled,
    required ValueChangeNotifier<T> value,
    required this.getter,
    required this.setter,
  }) {
    _enabled = enabled;
    _value = value;
  }

  bool get enabled {
    return _enabled.value;
  }

  T get value {
    return _value.value;
  }

  Future<bool> getEnabled() async {
    await getter(_enabled, _value);
    return _enabled.value;
  }

  Future<T> getValue() async {
    await getter(_enabled, _value);
    return _value.value;
  }

  Future<void> setEnabled(bool enabled) async {
    await setter(this._enabled, this._value);
  }

  Future<void> setValue(T value) async {
    await setter(this._enabled, this._value);
  }
}
