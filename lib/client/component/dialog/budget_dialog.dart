// budget_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetman/server/data_model/budget.dart';
import 'package:budgetman/client/bloc/home/home_bloc.dart';
import 'package:budgetman/client/component/dialog/custom_alert_dialog.dart';

class BudgetDialog extends StatefulWidget {
  final Budget? existingBudget;

  const BudgetDialog({Key? key, this.existingBudget}) : super(key: key);

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

void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    final budgetName = _budgetNameController.text.trim();
    final homeBloc = context.read<HomeBloc>();
    final isEditing = widget.existingBudget != null;

    try {
      if (isEditing) {
        // Update existing budget
        await homeBloc.updateBudget(widget.existingBudget!, budgetName);
      } else {
        // Add new budget
        await homeBloc.addBudget(budgetName);
      }

      // Close the dialog only if successful
      Navigator.of(context).pop();

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
    } catch (e) {
      // Show error dialog without closing the form
      Future.microtask(() {
        if (context.mounted) {
          CustomAlertDialog.alertWithoutOptions(
            context,
            AlertType.error,
            'Error',
            e.toString(),
          );
        }
      });
    }
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
