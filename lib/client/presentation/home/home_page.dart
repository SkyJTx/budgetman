import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetman/client/bloc/home/home_bloc.dart';
import 'package:budgetman/client/bloc/home/home_state.dart';
import 'package:budgetman/client/repository/global_repo.dart';
import 'widgets/header_widget.dart';
import 'widgets/overview_widget.dart';
import 'widgets/transaction_card.dart';
import 'widgets/budget_list_item.dart';
import 'package:budgetman/client/component/dialog/budget_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String pageName = 'Home';
  static const String routeName = '/home';

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late final HomeBloc homeBloc;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    homeBloc = HomeBloc();
    homeBloc.init();
  }

  @override
  void dispose() {
    homeBloc.close();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>.value(
      value: homeBloc,
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.error != null) {
            ClientRepository().showErrorSnackBar(
              context,
              message: TextSpan(
                text: state.error!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }
        },
        builder: (context, state) {
          if (!state.isInitialized) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Header Section
                    const HeaderWidget(),

                    // Overview Section
                    OverviewWidget(
                      totalBalance: state.totalBalance,
                      totalIncome: state.totalIncome,
                      totalExpense: state.totalExpense,
                      transactions: state.transactions,
                    ),

                    // Budgets Section
                    const SizedBox(height: 24),
                    Text(
                      'Budgets',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    if (state.budgets.isEmpty)
                      Center(
                        child: Text(
                          'No Budgets',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    else
                      ...state.budgets.map(
                        (budget) => BudgetListItem(
                          budget: budget,
                          onEdit: () {
                            // Show BudgetDialog for editing
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return BudgetDialog(
                                  existingBudget: budget,
                                  onBudgetAdded: (String budgetName) {
                                    // Update the budget using HomeBloc
                                    context.read<HomeBloc>().updateBudget(budget, budgetName);
                                  },
                                );
                              },
                            );
                          },
                          onDelete: () {
                            // Delete the budget using HomeBloc
                            context.read<HomeBloc>().deleteBudget(budget.id);
                          },
                        ),
                      ),

                    // Transaction List Section
                    const SizedBox(height: 24),
                    Text(
                      'Transactions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    if (state.transactions.isEmpty)
                      Center(
                        child: Text(
                          'No Transactions',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    else
                      ...state.transactions.map(
                        (transaction) => TransactionCard(budgetList: transaction),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
