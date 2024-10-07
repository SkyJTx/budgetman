import 'package:budgetman/client/component/value_notifier/multiple_value_change_notifier_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/v4.dart';

class ValueChangeNotifier<T> extends Cubit<T> {
  late final String name;

  List<void Function(ValueChangeNotifier<T>)> listeners = [];

  ValueChangeNotifier(super.state, {String? name}) {
    this.name = name ?? const UuidV4().generate();
  }

  T get value => state;

  set value(T value) {
    emit(value);
  }

  void addListener(void Function(ValueChangeNotifier<T>) listener) {
    listeners.add(listener);
  }

  void removeListener(void Function(ValueChangeNotifier<T>) listener) {
    listeners.remove(listener);
  }

  void notifyListeners() {
    for (final listener in listeners) {
      listener(this);
    }
  }

  BlocListener listen(void Function(BuildContext context, T state) listener) {
    return BlocListener<ValueChangeNotifier<T>, T>(
      bloc: this,
      listener: listener,
    );
  }

  BlocBuilder build(Widget Function(BuildContext context, T state) builder) {
    return BlocBuilder<ValueChangeNotifier<T>, T>(
      bloc: this,
      builder: builder,
    );
  }

  BlocConsumer consume({
    required void Function(BuildContext context, T state) listener,
    required Widget Function(BuildContext context, T state) builder,
  }) {
    return BlocConsumer<ValueChangeNotifier<T>, T>(
      bloc: this,
      listener: listener,
      builder: builder,
    );
  }

  BlocSelector select<R>({
    required BlocWidgetSelector<T, R> selector,
    required Widget Function(BuildContext context, R state) builder,
  }) {
    return BlocSelector<ValueChangeNotifier<T>, T, R>(
      bloc: this,
      selector: selector,
      builder: builder,
    );
  }

  MultipleValueChangeNotifierSelector<T> selectMultiple({
    required List<ValueChangeNotifier> valueChangeNotifiers,
    required T Function() selector,
    required Widget Function(BuildContext context, T state) builder,
  }) {
    return MultipleValueChangeNotifierSelector<T>(
      valueChangeNotifiers: valueChangeNotifiers,
      selector: selector,
      builder: builder,
    );
  }

  @override
  void emit(T state) {
    super.emit(state);
    notifyListeners();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValueChangeNotifier<T> && runtimeType == other.runtimeType && state == other.state;

  @override
  int get hashCode => state.hashCode;
}
