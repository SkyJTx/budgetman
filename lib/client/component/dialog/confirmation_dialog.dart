import 'package:budgetman/client/component/dialog/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends CustomAlertDialog {
  ConfirmationDialog(
      {super.key,
      required BuildContext context,
      required String title,
      required String content,
      void Function(bool isConfirmed)? onPressAction})
      : super(
          type: AlertType.warning,
          title: title,
          content: content,
          actions: [
            ElevatedButton(
              onPressed: onPressAction == null
                  ? () {
                      Navigator.of(context).pop(true);
                    }
                  : () {
                      onPressAction(true);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm'),
            ),
            ElevatedButton(
              onPressed: onPressAction == null
                  ? () {
                      Navigator.of(context).pop(false);
                    }
                  : () {
                      onPressAction(false);
                    },
              child: const Text('Cancel'),
            ),
          ],
        );
}
