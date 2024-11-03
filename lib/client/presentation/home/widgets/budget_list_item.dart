// budget_list_item.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budgetman/client/component/dialog/confirmation_dialog.dart';
import 'package:budgetman/client/component/dialog/custom_alert_dialog.dart';
import 'package:budgetman/server/repository/budget/budget_repository.dart';
import 'edit_budget_button.dart';

class BudgetListItem extends StatefulWidget {
  final int budgetId;
  final Future<void> Function() onEdit;
  final VoidCallback onDelete;

  const BudgetListItem({
    Key? key,
    required this.budgetId,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  _BudgetListItemState createState() => _BudgetListItemState();
}

class _BudgetListItemState extends State<BudgetListItem> {
  late Future<Map<String, dynamic>> _budgetDataFuture;

  @override
  void initState() {
    super.initState();
    _budgetDataFuture = _fetchBudgetData();
  }

  Future<Map<String, dynamic>> _fetchBudgetData() async {
    final budgetRepo = BudgetRepository();
    final budget = await budgetRepo.getById(widget.budgetId);

    // Fetch the total amount using the repository
    double totalAmount = await budgetRepo.getTotalAmountForBudget(widget.budgetId);

    return {
      'budget': budget,
      'totalAmount': totalAmount,
    };
  }

  Future<void> _handleEdit() async {
    await widget.onEdit();
    setState(() {
      _budgetDataFuture = _fetchBudgetData(); // Refresh the data
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('MM/dd/yyyy');

    return FutureBuilder<Map<String, dynamic>>(
      future: _budgetDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle errors
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          // Case data not found
          return const Text('Budget data not found');
        } else {
          final budget = snapshot.data!['budget'];
          final totalAmount = snapshot.data!['totalAmount'] as double;

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFa8e063), Color(0xFF56ab2f)],
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
                      fontSize: 20,
                      color: Colors.white, 
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black26,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
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
                  // Bottom Row with Total Amount and Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Total Amount
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Text(
                          'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 2.0,
                                color: Colors.black26,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Action Buttons
                      Row(
                        children: [
                          // EditBudgetButton
                          EditBudgetButton(
                            onPressed: _handleEdit,
                          ),
                          const SizedBox(width: 8),
                          // Edit Icon Button
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: _handleEdit,
                            tooltip: 'Edit Budget',
                          ),
                          // Delete Icon Button
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: () async {
                              // Show confirmation dialog before deleting
                              final confirmed = await ConfirmationDialog.show(
                                context: context,
                                title: 'Delete Budget',
                                content: 'Are you sure you want to delete this budget?',
                              );

                              if (confirmed) {
                                // Perform the delete operation
                                widget.onDelete();

                                // Show warning alert after successful deletion
                                Future.microtask(() {
                                  if (context.mounted) {
                                    CustomAlertDialog.alertWithoutOptions(
                                      context,
                                      AlertType.warning,
                                      'Budget Deleted',
                                      'The budget "${budget.name}" has been deleted.',
                                    );
                                  }
                                });
                              }
                            },
                            tooltip: 'Delete Budget',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
