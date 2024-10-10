
import 'package:budgetman/server/data_model/budget.dart';
import 'package:budgetman/server/data_model/budget_list.dart';
import 'package:budgetman/server/data_model/categories.dart';
import 'package:budgetman/server/repository/budget/budget_repository.dart';
import 'package:budgetman/server/repository/budget_list/budget_list_repository.dart';
import 'package:budgetman/server/repository/categories/categories_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'budget_state.dart';
part 'budget_error_object.dart';

class BudgetBloc extends Cubit<BudgetState> {
  final BudgetRepository _budgetRepository = BudgetRepository();
  final BudgetListRepository _budgetListRepository = BudgetListRepository();
  final CategoryRepository _categoryRepository = CategoryRepository();

  BudgetBloc(Budget budget) : super(BudgetState(budget: budget, categories: const []));

  Future<void> init() async {
    try {
      final categories = await _categoryRepository.getAll();
      emit(state.copyWith(
        isInitialized: true,
        isReady: true,
        categories: categories,
      ));
    } catch (e, _) {
      emit(state.copyWith(
        isInitialized: false,
        isReady: true,
        error: const BudgetErrorObject(
          message: "Failed to initialize budget, Please try again.",
        ),
      ));
    }
  }

  Future<void> updateBudget(Budget budget) async {
    final prevState = state;
    emit(state.copyWith(
      isReady: false,
      budget: budget,
    ));
    try {
      final updatedBudget = await _budgetRepository.update(budget);
      emit(state.copyWith(
        isReady: true,
        budget: updatedBudget,
      ));
    } catch (e, _) {
      emit(prevState.copyWith(
        isReady: true,
        error: const BudgetErrorObject(
          message: "Failed to update budget, Revert changes.",
        ),
      ));
    }
  }

  Future<void> addBudgetList(BudgetList budgetList) async {
    final prevState = state;
    emit(state.copyWith(
      isReady: false,
    ));
    try {
      final result = await _budgetListRepository.add(budgetList, budget: state.budget);
      emit(state.copyWith(
        isReady: true,
        budget: result,
      ));
    } catch (e, _) {
      emit(prevState.copyWith(
        isReady: true,
        error: const BudgetErrorObject(
          message: "Failed to add budget list, Please try again.",
        ),
      ));
    }
  }

  Future<void> updateBudgetList(BudgetList budgetList) async {
    final prevState = state;
    emit(state.copyWith(
      isReady: false,
    ));
    try {
      await _budgetListRepository.update(budgetList);
      final result = await _budgetRepository.get(state.budget.id);
      emit(state.copyWith(
        isReady: true,
        budget: result,
      ));
    } catch (e, _) {
      emit(prevState.copyWith(
        isReady: true,
        error: const BudgetErrorObject(
          message: "Failed to update budget list, Please try again.",
        ),
      ));
    }
  }

  Future<void> removeBudgetList(BudgetList budgetList) async {
    final prevState = state;
    emit(state.copyWith(
      isReady: false,
    ));
    try {
      await _budgetListRepository.delete(budgetList.id);
      final result = await _budgetRepository.get(state.budget.id);
      emit(state.copyWith(
        isReady: true,
        budget: result,
      ));
    } catch (e, _) {
      emit(prevState.copyWith(
        isReady: true,
        error: const BudgetErrorObject(
          message: "Failed to remove budget list, Please try again.",
        ),
      ));
    }
  }

  Future<void> removeBudget() async {
    final prevState = state;
    emit(state.copyWith(
      isReady: false,
    ));
    try {
      await _budgetRepository.delete(state.budget.id);
      emit(state.copyWith(
        isDeleted: true,
        isReady: true,
      ));
    } catch (e, _) {
      emit(prevState.copyWith(
        isReady: true,
        error: const BudgetErrorObject(
          message: "Failed to delete budget, Please try again.",
        ),
      ));
    }
  }
}
