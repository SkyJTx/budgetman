import 'dart:async';
import 'dart:developer';

import 'package:budgetman/client/repository/global_repo.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetman/server/data_model/budget.dart';
import 'package:budgetman/server/data_model/budget_list.dart';
import 'package:budgetman/server/repository/budget/budget_repository.dart';
import 'package:budgetman/client/bloc/home/home_state.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(const HomeState()) {
    ClientRepository().router.routeInformationProvider.addListener(routerChanged);
  }

  // Use the singleton instance
  final BudgetRepository _budgetRepository = BudgetRepository.instance;

  void routerChanged() {
    init();
  }

  Future<bool> backButtonPressed() {
    debugPrint('Back button pressed');
    return Future.value(true);
  }

  @override
  Future<void> close() async {
    ClientRepository().router.routeInformationProvider.removeListener(routerChanged);
    await super.close();
  }

  Future<void> init() async {
    try {
      print('Initializing HomeBloc...');
      final data = await _loadData();
      emit(state.copyWith(
        budgets: data.$1,
        transactions: data.$2,
        totalBalance: calculateTotal(data.$2),
        totalIncome: calculateIncome(data.$2),
        totalExpense: calculateExpense(data.$2),
        isInitialized: true,
      ));
      print('HomeBloc initialized with ${data.$1.length} budgets');
    } catch (e) {
      print('Error initializing HomeBloc: $e');
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Loads all data (budgets and transactions) and returns them as a tuple
  Future<(List<Budget>, List<BudgetList>)> _loadData() async {
    log('Loading data...');
    final budgets = await _budgetRepository.getAll();
    // for (var budget in budgets) {
    //   await budget.budgetList.load();
    // }

    final transactions = [for (var budget in budgets) ...budget.budgetList]
        .where((transaction) => !transaction.isRemoved)
        .sortedBy((transaction) => transaction.createdAt)
        .reversed
        .toList();

    log('Loaded ${budgets.length} budgets and ${transactions.length} transactions');
    return (List<Budget>.from(budgets), List<BudgetList>.from(transactions));
  }

  /// Adds a new Budget and refreshes the data
  Future<void> addBudget(String budgetName) async {
    try {
      print('Adding new budget: $budgetName');

      // Create and add the budget
      await _budgetRepository.add(
        name: budgetName,
        description: '', // Default description
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
        isRoutine: false,
        isCompleted: false,
        isRemoved: false,
      );

      // Load fresh data
      final data = await _loadData();

      // Emit new state with all updated data
      emit(state.copyWith(
        budgets: data.$1,
        transactions: data.$2,
        totalBalance: calculateTotal(data.$2),
        totalIncome: calculateIncome(data.$2),
        totalExpense: calculateExpense(data.$2),
        refreshTrigger: state.refreshTrigger + 1,
      ));

      print(
          'State updated after adding budget. Current budgets: ${data.$1.length}, refreshTrigger: ${state.refreshTrigger + 1}');
    } catch (e) {
      print('Error adding budget: $e');
      emit(state.copyWith(error: e.toString()));
      rethrow; // Rethrow the exception to propagate it to the UI
    }
  }

  Future<void> updateBudget(Budget budget, String newName) async {
    try {
      print('Updating budget with ID: ${budget.id}');
      // Update the budget
      await _budgetRepository.update(
        budget,
        name: newName,
      );

      // Load fresh data
      final data = await _loadData();

      // Emit new state with all updated data
      emit(state.copyWith(
        budgets: data.$1,
        transactions: data.$2,
        totalBalance: calculateTotal(data.$2),
        totalIncome: calculateIncome(data.$2),
        totalExpense: calculateExpense(data.$2),
        refreshTrigger: state.refreshTrigger + 1,
      ));

      print('Budget updated. Current budgets: ${data.$1.length}');
    } catch (e) {
      print('Error updating budget: $e');
      emit(state.copyWith(error: e.toString()));
      rethrow;
    }
  }

  /// Deletes a Budget by its ID
  Future<void> deleteBudget(int budgetId) async {
    try {
      print('Deleting budget with ID: $budgetId');
      await _budgetRepository.delete(budgetId);

      // Load fresh data
      final data = await _loadData();

      // Emit new state with all updated data
      emit(state.copyWith(
        budgets: data.$1,
        transactions: data.$2,
        totalBalance: calculateTotal(data.$2),
        totalIncome: calculateIncome(data.$2),
        totalExpense: calculateExpense(data.$2),
        refreshTrigger: state.refreshTrigger + 1,
      ));

      print(
          'Budget deleted and state updated. Current budgets: ${data.$1.length}, refreshTrigger: ${state.refreshTrigger + 1}');
    } catch (e, s) {
      print('Error deleting budget: $e');
      log('Error deleting budget: $e', error: e, stackTrace: s);
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Helper method to calculate total balance
  double calculateTotal(List<BudgetList> transactions) {
    return transactions.fold(0.0, (sum, transaction) => sum + transaction.budget);
  }

  /// Helper method to calculate total income
  double calculateIncome(List<BudgetList> transactions) {
    return transactions
        .where((transaction) => transaction.budget > 0)
        .fold(0.0, (sum, transaction) => sum + transaction.budget);
  }

  /// Helper method to calculate total expense
  double calculateExpense(List<BudgetList> transactions) {
    return transactions
        .where((transaction) => transaction.budget < 0)
        .fold(0.0, (sum, transaction) => sum + transaction.budget.abs());
  }
}
