import 'dart:async';

import 'package:budgetman/client/repository/global_repo.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends Dialog {
  LoadingOverlay({super.key})
      : super(
          backgroundColor: Colors.black.withOpacity(0.5),
          alignment: Alignment.center,
          child: const PopScope(
            canPop: false,
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        );

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingOverlay(),
    );
  }

  static Future<T> wait<T>(BuildContext context, FutureOr<T> future) async {
    show(context);
    final result = await future;
    ClientRepository.navigatorKey.currentState?.pop();
    return result;
  }
}
