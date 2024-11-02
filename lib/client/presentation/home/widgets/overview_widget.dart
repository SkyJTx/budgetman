// overview_widget.dart
import 'package:flutter/material.dart';
import 'package:budgetman/server/data_model/budget_list.dart';
import 'budget_deadline_graph.dart';

class OverviewWidget extends StatelessWidget {
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final List<BudgetList> transactions;

  const OverviewWidget({
    Key? key,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Balance and Savings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Total Balance
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Budget',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${totalBalance.toStringAsFixed(2)} Baht',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              // Icon กระปุกเงิน ขวาบน
              Column(
                children: [
                  Icon(
                    Icons.savings,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    'Edit Budget',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Chart Title
          Center(
            child: Text(
              'Budget vs Deadline',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          // Graph
          Container(
            height: 400,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: BudgetDeadlineGraph(transactions: transactions),
          ),
          const SizedBox(height: 16),
          // Income and Expense Summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                context,
                'Budget',
                totalIncome.toStringAsFixed(2),
                Colors.green,
              ),
              _buildSummaryItem(
                context,
                'Spendings',
                totalExpense.toStringAsFixed(2),
                const Color.fromARGB(255, 7, 159, 219),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String title, String amount, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          '$amount Baht',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
