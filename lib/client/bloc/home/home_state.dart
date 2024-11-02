import 'package:budgetman/server/data_model/budget.dart';
import 'package:budgetman/server/data_model/budget_list.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final bool isInitialized;
  final List<BudgetList> transactions;
  final List<Budget> budgets;
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final String? error;
  final int refreshTrigger; // Added field to force refresh

  const HomeState({
    this.isInitialized = false,
    this.transactions = const [],
    this.budgets = const [],
    this.totalBalance = 0.0,
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
    this.error,
    this.refreshTrigger = 0, // Initialize with 0
  });

  HomeState copyWith({
    bool? isInitialized,
    List<BudgetList>? transactions,
    List<Budget>? budgets,
    double? totalBalance,
    double? totalIncome,
    double? totalExpense,
    String? error,
    int? refreshTrigger,
  }) {
    return HomeState(
      isInitialized: isInitialized ?? this.isInitialized,
      transactions: transactions ?? this.transactions,
      budgets: budgets ?? this.budgets,
      totalBalance: totalBalance ?? this.totalBalance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      error: error, // Intentionally not using ?? to allow setting to null
      refreshTrigger: refreshTrigger ?? this.refreshTrigger,
    );
  }

  @override
  List<Object?> get props => [
        isInitialized,
        List<BudgetList>.from(transactions),
        List<Budget>.from(budgets),
        totalBalance,
        totalIncome,
        totalExpense,
        error,
        refreshTrigger,
      ];

  @override
  String toString() {
    return 'HomeState(initialized: $isInitialized, budgets: ${budgets.length}, transactions: ${transactions.length}, balance: $totalBalance, income: $totalIncome, expense: $totalExpense, error: $error, refreshTrigger: $refreshTrigger)';
  }
}
