import 'package:flutter/material.dart';
import 'value_change_notifier.dart';

class MultipleValueChangeNotifierSelector<T> extends StatefulWidget {
  final List<ValueChangeNotifier> valueChangeNotifiers;
  final T Function() selector;
  final Widget Function(BuildContext context, T state) builder;

  const MultipleValueChangeNotifierSelector({
    super.key,
    required this.valueChangeNotifiers,
    required this.selector,
    required this.builder,
  });

  @override
  State<MultipleValueChangeNotifierSelector<T>> createState() =>
      MultipleValueChangeNotifierSelectorState<T>();
}

class MultipleValueChangeNotifierSelectorState<T>
    extends State<MultipleValueChangeNotifierSelector<T>> {
  late T state;

  @override
  void initState() {
    state = widget.selector();
    for (final notifier in widget.valueChangeNotifiers) {
      notifier.addListener(_onValueChanged);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(MultipleValueChangeNotifierSelector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.valueChangeNotifiers != widget.valueChangeNotifiers) {
      for (final notifier in oldWidget.valueChangeNotifiers) {
        notifier.listeners.clear();
      }
      for (final notifier in widget.valueChangeNotifiers) {
        notifier.addListener(_onValueChanged);
      }
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void dispose() {
    for (final notifier in widget.valueChangeNotifiers) {
      notifier.removeListener(_onValueChanged);
    }
    super.dispose();
  }

  void _onValueChanged(ValueChangeNotifier notifier) {
    setState(() {
      state = widget.selector();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, state);
  }
}
