import 'package:budgetman/server/data_model/budget_list.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final bool isInitialized;
  final List<BudgetList> transactions;
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final String? error;

  const HomeState({
    this.isInitialized = false,
    this.transactions = const [],
    this.totalBalance = 0.0,
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
    this.error,
  });

  HomeState copyWith({
    bool? isInitialized,
    List<BudgetList>? transactions,
    double? totalBalance,
    double? totalIncome,
    double? totalExpense,
    String? error,
  }) {
    return HomeState(
      isInitialized: isInitialized ?? this.isInitialized,
      transactions: transactions ?? this.transactions,
      totalBalance: totalBalance ?? this.totalBalance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isInitialized,
        transactions,
        totalBalance,
        totalIncome,
        totalExpense,
        error,
      ];
}
