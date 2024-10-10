import 'package:budgetman/server/data_model/budget.dart';
import 'package:flutter/material.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({
    super.key,
    required this.budget,
  });

  final Budget budget;

  static const String pageName = 'Budget';
  static const String routeName = '/budget';

  @override
  State<BudgetPage> createState() => BudgetPageState();
}

class BudgetPageState extends State<BudgetPage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );
  }
}
