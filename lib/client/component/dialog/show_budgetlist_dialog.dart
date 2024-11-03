// lib/client/component/dialog/show_budgetlist_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetman/server/data_model/budget.dart';
import 'package:budgetman/client/component/dialog/budget_dialog.dart';
import 'package:budgetman/client/bloc/home/home_bloc.dart';

class BudgetListDialog extends StatefulWidget {
  const BudgetListDialog({Key? key}) : super(key: key);

  @override
  _BudgetListDialogState createState() => _BudgetListDialogState();
}

class _BudgetListDialogState extends State<BudgetListDialog> {
  late Future<List<Budget>> _budgetsFuture;

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  void _loadBudgets() {
    final homeBloc = context.read<HomeBloc>();
    _budgetsFuture = Future.value(homeBloc.state.budgets);
  }

  Future<void> _refreshBudgets() async {
    final homeBloc = context.read<HomeBloc>();
    await homeBloc.init();
    setState(() {
      _loadBudgets();
    });
  }

  void _openEditDialog(Budget budget) async {
    // Open BudgetDialog with the existing budget details for editing
    await showDialog(
      context: context,
      builder: (context) => BudgetDialog(
        existingBudget: budget, // Pass existing budget for editing
      ),
    );
    // Refresh budgets after editing
    _refreshBudgets();
  }

  void _deleteBudget(int budgetId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Budget'),
        content: const Text('Are you sure you want to delete this budget?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // Use HomeBloc to delete the budget
        await context.read<HomeBloc>().deleteBudget(budgetId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Budget deleted successfully')),
        );
        _refreshBudgets();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting budget: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('All Budgets'),
      content: SizedBox(
        width: double.maxFinite,
        child: FutureBuilder<List<Budget>>(
          future: _budgetsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No budgets found.'));
            } else {
              final budgets = snapshot.data!;
              return RefreshIndicator(
                onRefresh: _refreshBudgets,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: budgets.length,
                  itemBuilder: (context, index) {
                    final budget = budgets[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                          budget.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Start: ${budget.startDate.toLocal().toShortDateString()} - End: ${budget.endDate.toLocal().toShortDateString()}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Updated Edit Button
                            ElevatedButton(
                              onPressed: () => _openEditDialog(budget),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                textStyle: const TextStyle(fontSize: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Edit Budget'),
                            ),
                            const SizedBox(width: 8), // Spacing between button and icons
                            // Delete Icon Button
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteBudget(budget.id),
                              tooltip: 'Delete Budget',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (context) => BudgetDialog(),
            );
            _refreshBudgets();
          },
          child: const Text('Add Budget'),
        ),
      ],
    );
  }
}

// Extension to format DateTime
extension DateHelpers on DateTime {
  String toShortDateString() {
    return '${this.day}/${this.month}/${this.year}';
  }
}
