// home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetman/client/bloc/home/home_bloc.dart';
import 'package:budgetman/client/bloc/home/home_state.dart';
import 'package:budgetman/client/repository/global_repo.dart';
import 'package:budgetman/server/data_model/budget_list.dart';

// Import the new widgets
import 'widgets/header_widget.dart';
import 'widgets/overview_widget.dart';
import 'widgets/transaction_card.dart';
import 'widgets/nav_button.dart';

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

                    // Transaction List Section
                    const SizedBox(height: 24),
                    Text(
                      'รายการล่าสุด',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    if (state.transactions.isEmpty)
                      Center(
                        child: Text(
                          'ไม่มีรายการ',
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
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NavButton(
                    icon: Icons.arrow_upward,
                    label: 'โอนเงินเข้า',
                    color: Colors.green,
                    onPressed: () {},
                  ),
                  NavButton(
                    icon: Icons.arrow_downward,
                    label: 'โอนเงินออก',
                    color: Colors.red,
                    onPressed: () {},
                  ),
                  NavButton(
                    icon: Icons.savings,
                    label: 'กระปุกเงิน',
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {},
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
