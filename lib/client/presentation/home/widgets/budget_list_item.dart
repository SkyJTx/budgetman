// lib/client/presentation/home/budget_list_item.dart

import 'package:flutter/material.dart';
import 'package:budgetman/server/data_model/budget.dart';
import 'edit_budget_button.dart';
import 'package:intl/intl.dart';

class BudgetListItem extends StatelessWidget {
  final Budget budget;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BudgetListItem({
    Key? key,
    required this.budget,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('MM/dd/yyyy');

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Budget Name
            Text(
              budget.name,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // Budget Dates
            Text(
              'Start: ${formatter.format(budget.startDate.toLocal())}',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            Text(
              'End: ${formatter.format(budget.endDate.toLocal())}',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Custom Edit Budget Button
                EditBudgetButton(
                  onPressed: onEdit,
                ),
                const SizedBox(width: 8),
                // Edit Icon Button
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: onEdit,
                  tooltip: 'Edit Budget',
                ),
                // Delete Icon Button
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: onDelete,
                  tooltip: 'Delete Budget',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
