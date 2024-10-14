import 'package:budgetman/extension.dart';
import 'package:flutter/material.dart';

enum AlertType {
  success,
  error,
  warning,
  info;

  IconData get icon {
    switch (this) {
      case AlertType.success:
        return Icons.check_circle;
      case AlertType.error:
        return Icons.error;
      case AlertType.warning:
        return Icons.warning;
      case AlertType.info:
        return Icons.info;
    }
  }

  Color get color {
    switch (this) {
      case AlertType.success:
        return Colors.green;
      case AlertType.error:
        return Colors.red;
      case AlertType.warning:
        return Colors.orange;
      case AlertType.info:
        return Colors.blue;
    }
  }

  String get title {
    switch (this) {
      case AlertType.success:
        return 'Success';
      case AlertType.error:
        return 'Error';
      case AlertType.warning:
        return 'Warning';
      case AlertType.info:
        return 'Info';
    }
  }

  double get size => 50;

}

class CustomAlertDialog<T> extends StatefulWidget {
  const CustomAlertDialog({
    super.key,
    required this.type,
    this.title,
    this.content,
    this.actions = const <Widget>[],
  });

  final AlertType type;
  final String? title;
  final String? content;
  final List<Widget> actions;

  @override
  State<CustomAlertDialog> createState() => CustomAlertDialogState<T>();
}

class CustomAlertDialogState<T> extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              widget.type.icon,
              size: widget.type.size,
              color: widget.type.color,
            ),
            Text(
              widget.title ?? widget.type.title,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(widget.content ?? 'No content'),
        actions: [
          ...widget.actions,
          if (widget.actions.isEmpty) ...[
            TextButton(
              onPressed: () => Navigator.of(context).pop<T>(),
              child: const Text('OK'),
            ),
          ],
        ],
      ),
    );
  }
}
