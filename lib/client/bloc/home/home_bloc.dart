import 'package:budgetman/client/bloc/home/home_state.dart';
import 'package:budgetman/server/data_model/budget_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(const HomeState());

  final Isar isar = GetIt.instance<Isar>();

  Future<void> init() async {
    try {
      await loadTransactions();

      emit(state.copyWith(
        totalBalance: totalBalance,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        isInitialized: true,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> loadTransactions() async {
    try {
      final transactions = await isar.budgetLists
          .filter()
          .not()
          .isRemovedEqualTo(true)
          .sortByCreatedAtDesc()
          .findAll();

      emit(state.copyWith(transactions: transactions));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  double get totalBalance {
    return state.transactions.fold(0.0, (sum, transaction) => sum + transaction.budget);
  }

  double get totalIncome {
    return state.transactions
        .where((transaction) => transaction.budget > 0)
        .fold(0.0, (sum, transaction) => sum + transaction.budget);
  }

  double get totalExpense {
    return state.transactions
        .where((transaction) => transaction.budget < 0)
        .fold(0.0, (sum, transaction) => sum + transaction.budget.abs());
  }
}
