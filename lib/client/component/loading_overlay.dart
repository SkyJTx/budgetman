import 'dart:async';

import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final double size;

  const LoadingOverlay({
    super.key,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            color: Colors.white,
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
        pageBuilder: (context, _, __) => const LoadingOverlay(),
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
