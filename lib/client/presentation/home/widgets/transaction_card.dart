// transaction_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:budgetman/server/repository/budget/budget_repository.dart'; // Import BudgetRepository
import 'package:budgetman/server/data_model/budget_list.dart'; // Import BudgetList

class TransactionCard extends StatefulWidget {
  final BudgetList budgetList;

  const TransactionCard({Key? key, required this.budgetList}) : super(key: key);

  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  Future<Map<String, dynamic>> _fetchData() async {
    final budgetRepo = BudgetRepository();
    final budgetList = widget.budgetList;

    // Fetch the associated budget using the repository
    final associatedBudget = await budgetRepo.getBudgetForBudgetList(budgetList.id);

    return {
      'budgetList': budgetList,
      'associatedBudget': associatedBudget,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while fetching data
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle errors
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          // Handle the case where data is not found
          return const Text('No data available');
        } else {
          final budgetList = snapshot.data!['budgetList'] as BudgetList;
          final associatedBudget = snapshot.data!['associatedBudget'];

          // Determine accent color based on priority
          final Color accentColor = _getAccentColor(budgetList.priority);

          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              onTap: () {
                // Define behavior on tap if needed
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Deadline
                    Container(
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title
                          Expanded(
                            child: Text(
                              budgetList.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: accentColor,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Deadline with icon
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: accentColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('dd/MM/yyyy').format(budgetList.deadline),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: accentColor,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Amount
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${budgetList.budget.toStringAsFixed(2)} Baht',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Description
                    if (budgetList.description.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              budgetList.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'No description',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),
                    // Priority indicator
                    Row(
                      children: [
                        Icon(
                          Icons.flag,
                          color: accentColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Priority: ${_getPriorityText(budgetList.priority)}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: accentColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    // Budget section
                    Text(
                      'Budget name:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                    ),
                    const SizedBox(height: 8),
                    if (associatedBudget == null)
                      Text(
                        'No budget', // No budget assigned.
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                      )
                    else
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.account_balance_wallet,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(
                          associatedBudget.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        subtitle: Text(
                          'Date: ${DateFormat('dd/MM/yyyy').format(associatedBudget.startDate)} - ${DateFormat('dd/MM/yyyy').format(associatedBudget.endDate)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ).animate().fade().slideX();
        }
      },
    );
  }

  // Function to determine accent color based on priority
  Color _getAccentColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.redAccent; // High priority
      case 2:
        return Colors.orangeAccent; // Medium priority
      case 3:
        return Colors.green; // Low priority
      default:
        return Colors.blueAccent; // Default color
    }
  }

  // Function to get priority text from int value
  String _getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'High';
      case 2:
        return 'Medium';
      case 3:
        return 'Low';
      default:
        return 'Unknown';
    }
  }
}
