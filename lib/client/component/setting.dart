import 'package:budgetman/client/component/value_notifier/value_change_notifier.dart';

class Setting<T> {
  final String key;
  late final ValueChangeNotifier<bool> enabledNotifier;
  late final ValueChangeNotifier<T> valueNotifier;

  Setting({
    required this.key,
    required this.enabledNotifier,
    required this.valueNotifier,
  });

  bool get enabled {
    return enabledNotifier.value;
  }

  T get value {
    return valueNotifier.value;
  }

  set enabled(bool enabled) {
    enabledNotifier.value = enabled;
  }

  set value(T value) {
    valueNotifier.value = value;
  }

  void providePrerequisite(void Function(ValueChangeNotifier<bool>) prerequisites) {
    enabledNotifier.addListener(prerequisites);
  }

  void provideChain(void Function(ValueChangeNotifier<T>) chain) {
    valueNotifier.addListener(chain);
  }
}
