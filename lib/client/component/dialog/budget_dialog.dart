// budget_dialog.dart
import 'package:flutter/material.dart';
import 'package:budgetman/server/data_model/budget.dart';
import 'package:budgetman/client/component/dialog/custom_alert_dialog.dart';

class BudgetDialog extends StatefulWidget {
  final Function(String) onBudgetAdded;
  final Budget? existingBudget;

  const BudgetDialog({Key? key, required this.onBudgetAdded, this.existingBudget}) : super(key: key);

  @override
  _BudgetDialogState createState() => _BudgetDialogState();
}

class _BudgetDialogState extends State<BudgetDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _budgetNameController;

  @override
  void initState() {
    super.initState();
    _budgetNameController = TextEditingController(
      text: widget.existingBudget?.name ?? '',
    );
  }

  @override
  void dispose() {
    _budgetNameController.dispose();
    super.dispose();
  }

void _submitForm() {
  if (_formKey.currentState!.validate()) {
    final budgetName = _budgetNameController.text.trim();

    // Close the dialog
    Navigator.of(context).pop();

    // Pass the budget name back to be handled by HomeBloc
    widget.onBudgetAdded(budgetName);
    final isEditing = widget.existingBudget != null;

    // Show success alert after adding or editing budget
    Future.microtask(() {
      if (context.mounted) {
        CustomAlertDialog.alertWithoutOptions(
          context,
          AlertType.success,
          'Success',
          isEditing
              ? 'Budget "$budgetName" successfully edited!'
              : 'Budget "$budgetName" successfully added!',
        );
      }
    });
  }
}


  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingBudget != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit Budget' : 'Add Budget'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _budgetNameController,
          decoration: const InputDecoration(
            labelText: 'Budget Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a budget name';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text(isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
