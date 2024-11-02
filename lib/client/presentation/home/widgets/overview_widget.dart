// overview_widget.dart
import 'package:flutter/material.dart';
import 'package:budgetman/server/repository/budget/budget_repository.dart';
import 'package:budgetman/server/data_model/budget_list.dart';
import 'budget_deadline_graph.dart';

class OverviewWidget extends StatefulWidget {
  const OverviewWidget({Key? key}) : super(key: key);

  @override
  _OverviewWidgetState createState() => _OverviewWidgetState();
}

class _OverviewWidgetState extends State<OverviewWidget> {
  late Future<Map<String, dynamic>> _overviewDataFuture;

  @override
  void initState() {
    super.initState();
    _overviewDataFuture = _fetchOverviewData();
  }

  Future<Map<String, dynamic>> _fetchOverviewData() async {
    final budgetRepo = BudgetRepository();

    // Fetch all budgets
    final budgets = await budgetRepo.getAll();

    // Calculate total cumulative budget
    double totalCumulativeBudget = 0.0;
    int totalBudgets = budgets.length;

    for (var budget in budgets) {
      // Get the total amount for each budget
      double budgetTotal = await budgetRepo.getTotalAmountForBudget(budget.id);
      totalCumulativeBudget += budgetTotal;
    }

    // Fetch transactions or budget lists for the graph
    List<BudgetList> transactions = [];
    for (var budget in budgets) {
      await budget.budgetList.load();
      transactions.addAll(budget.budgetList);
    }

    return {
      'totalCumulativeBudget': totalCumulativeBudget,
      'totalBudgets': totalBudgets,
      'transactions': transactions,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _overviewDataFuture,
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
          final totalCumulativeBudget = snapshot.data!['totalCumulativeBudget'] as double;
          final totalBudgets = snapshot.data!['totalBudgets'] as int;
          final transactions = snapshot.data!['transactions'] as List<BudgetList>;

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
                      'Total Budget list',
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
