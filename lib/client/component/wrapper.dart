import 'package:flutter/material.dart';

class WrapperBuilder extends StatefulWidget {
  const WrapperBuilder({
    super.key,
    required this.builder,
    this.child,
  });
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  @override
  State<WrapperBuilder> createState() => WrapperBuilderState();
}

class WrapperBuilderState extends State<WrapperBuilder> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.child);
  }
}
