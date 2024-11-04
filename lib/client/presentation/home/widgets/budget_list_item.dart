import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budgetman/client/component/dialog/confirmation_dialog.dart';
import 'package:budgetman/client/component/dialog/custom_alert_dialog.dart';
import 'package:budgetman/server/repository/budget/budget_repository.dart';

class BudgetListItem extends StatefulWidget {
  final int budgetId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BudgetListItem({
    super.key,
    required this.budgetId,
    required this.onEdit,
    required this.onDelete,
  });

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

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('MM/dd/yyyy');

    return FutureBuilder<Map<String, dynamic>>(
      future: _budgetDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while fetching data
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle errors
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          // Handle the case where data is not found
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
                  colors: [Color(0xFFa8e063), Color(0xFF56ab2f)], // Adjusted gradient colors
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: widget.onEdit,
                child: Padding(
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
                          color: Colors.white, // Use white text with shadow
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
                          Flexible(
                            child: Container(
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
                          ),
                          const SizedBox(width: 8),
                          // Action Buttons
                          Row(
                            children: [
                              // EditBudgetButton
                              // EditBudgetButton(
                              //   onPressed: widget.onEdit,
                              // ),
                              // const SizedBox(width: 8),
                              // // Edit Icon Button
                              // IconButton(
                              //   icon: const Icon(Icons.edit, color: Colors.white),
                              //   onPressed: widget.onEdit,
                              //   tooltip: 'Edit Budget',
                              // ),
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
              ),
            ),
          );
        }
      },
    );
  }
}
