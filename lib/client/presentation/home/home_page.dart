// home_page.dart
import 'package:budgetman/client/presentation/budget/budget_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetman/client/bloc/home/home_bloc.dart';
import 'package:budgetman/client/bloc/home/home_state.dart';
import 'package:budgetman/client/repository/global_repo.dart';
import 'package:go_router/go_router.dart';
// import 'widgets/header_widget.dart';
import 'widgets/overview_widget.dart';
import 'widgets/transaction_card.dart';
import 'widgets/budget_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String pageName = 'Home';
  static const String routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize the TabController
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // Dispose the TabController
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeBloc, HomeState>(
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

          return SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                const SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16),
                      //   width: double.infinity,
                      //   child: const HeaderWidget(),
                      // ),

                      // Overview Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: OverviewWidget(),
                      ),
                    ],
                  ),
                ),
              ],
              body: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.transparent,
                    tabs: [
                      Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: _tabController.index == 0 ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Budgets',
                            style: TextStyle(
                              color: _tabController.index == 0 ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: _tabController.index == 1 ? Colors.green : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Recent Activities',
                            style: TextStyle(
                              color: _tabController.index == 1 ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                    onTap: (index) {
                      setState(() {
                        _tabController.index = index;
                      });
                    },
                  ),
                  Flexible(
                    child: Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // Budgets Page
                          state.budgets.isEmpty
                              ? Center(
                                  child: Text(
                                    'No Budgets',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  itemCount: state.budgets.length,
                                  itemBuilder: (context, index) {
                                    final budget = state.budgets[index];
                                    return BudgetListItem(
                                      budgetId: budget.id,
                                      onEdit: () {
                                        context.go('/${BudgetPage.routeName}', extra: budget);
                                      },
                                      onDelete: () {
                                        context.read<HomeBloc>().deleteBudget(budget.id);
                                      },
                                    );
                                  },
                                ),

                          // Transactions Page
                          state.transactions.isEmpty
                              ? Center(
                                  child: Text(
                                    'No Activities',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  itemCount: state.transactions.length,
                                  itemBuilder: (context, index) {
                                    final transaction = state.transactions[index];
                                    return TransactionCard(budgetList: transaction);
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
