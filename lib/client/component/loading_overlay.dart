import 'dart:async';

import 'package:budgetman/server/component/extension.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final double size;
  final bool isPopup;

  const LoadingOverlay({
    super.key,
    this.size = 50,
    this.isPopup = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isPopup ? Colors.black.withOpacity(0.5) : context.theme.colorScheme.surface,
      body: Center(
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            color: isPopup ? Colors.white : context.theme.colorScheme.primary,
            strokeWidth: size / 12.5,
          ),
        ),
      ),
    );
  }

  static void show(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, _, __) => const LoadingOverlay(
          isPopup: true,
        ),
      ),
    );
  }

  static Future<T> wait<T>(BuildContext context, FutureOr<T> future) async {
    final navigator = Navigator.of(context);
    show(context);
    final result = await future;
    navigator.pop();
    return result;
  }
}
