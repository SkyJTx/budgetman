// overview_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetman/server/data_model/budget.dart';
import 'package:budgetman/client/bloc/home/home_bloc.dart';
import 'package:budgetman/client/bloc/home/home_state.dart';
import 'budget_deadline_graph.dart';

class OverviewWidget extends StatelessWidget {
  const OverviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (!state.isInitialized) {
          // Show a loading indicator while initializing
          return const Center(child: CircularProgressIndicator());
        } else if (state.error != null) {
          // Handle errors
          return Text('Error: ${state.error}');
        } else {
          final totalCumulativeBudget = _calculateTotalCumulativeBudget(state.budgets);
          final totalBudgets = state.budgets.length;
          final transactions = state.transactions;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Cumulative Budget
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Total Cumulative Budget
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Cumulative Budget',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '${totalCumulativeBudget.toStringAsFixed(2)} Baht',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
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
                // Summary Items
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      context,
                      'Total Budgets',
                      '$totalBudgets Budgets',
                      Colors.green,
                    ),
                    _buildSummaryItem(
                      context,
                      'Total Budget Items',
                      '${transactions.length} Items',
                      const Color.fromARGB(255, 7, 159, 219),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }

  double _calculateTotalCumulativeBudget(List<Budget> budgets) {
    double total = 0.0;
    for (var budget in budgets) {
      for (var budgetListItem in budget.budgetList) {
        total += budgetListItem.budget;
      }
    }
    return total;
  }

  Widget _buildSummaryItem(BuildContext context, String title, String subtitle, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
