import 'package:budgetman/client/bloc/budget/budget_bloc.dart';
import 'package:budgetman/client/presentation/budget/budget_list/budget_list.dart';
import 'package:budgetman/extension.dart';
import 'package:budgetman/server/data_model/budget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

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
  late final BudgetBloc budgetBloc;

  @override
  void initState() {
    budgetBloc = BudgetBloc(widget.budget);
    super.initState();
    budgetBloc.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: budgetBloc,
      child: BlocSelector<BudgetBloc, BudgetState, bool>(
        bloc: budgetBloc,
        selector: (state) => state.isInitialized,
        builder: (context, isInitialized) {
          if (!isInitialized) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return BlocBuilder<BudgetBloc, BudgetState>(
            bloc: budgetBloc,
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.all([3.h, 3.w].min.toDouble()),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.budget.name,
                          style: context.theme.textTheme.titleLarge,
                        ),
                        BlocSelector<BudgetBloc, BudgetState, bool>(
                          bloc: budgetBloc,
                          selector: (state) {
                            return state.budget.isRoutine;
                          },
                          builder: (context, isRoutine) {
                            final startDate = state.budget.startDate;
                            if (isRoutine) {
                              final interval = state.budget.routineInterval;
                              if (interval == null) throw Exception('Routine interval is null');
                              final endDate = startDate.add(interval.seconds);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.repeat),
                                      const SizedBox(width: 8),
                                      Text('Every ${interval.seconds.inDays} days'),
                                    ],
                                  ),
                                  Text(
                                    '${DateFormat("dd/MM/y").format(startDate)} - ${DateFormat("dd/MM/y").format(endDate)}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              );
                            } else {
                              final endDate = state.budget.endDate;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('One-Time'),
                                  Text(
                                    '${DateFormat("dd/MM/y").format(startDate)} - ${DateFormat("dd/MM/y").format(endDate)}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ResponsiveSizer(
                        builder: (context, orientaion, screen) {
                          if (orientaion == Orientation.portrait) {
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: context.theme.colorScheme.surfaceContainerHighest,
                                  ),
                                  height: 40.h,
                                  alignment: Alignment.center,
                                  child: const Text('Graph Placeholder'),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: context.theme.colorScheme.primary),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: const Text('Utility Placeholder'),
                                ),
                                SizedBox(height: 2.h),
                                Flexible(
                                  child: ListView.builder(
                                    itemCount: state.budget.budgetList.length,
                                    itemBuilder: (context, index) {
                                      final budgetList = state.budget.budgetList.toList()[index];
                                      return BudgetListTile(budgetList: budgetList);
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                          return Row(
                            children: [
                              Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: context.theme.colorScheme.surfaceContainerHighest,
                                      ),
                                      width: 40.w,
                                      alignment: Alignment.center,
                                      child: const Text('Graph Placeholder'),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: context.theme.colorScheme.primary),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: const Text('Utility Placeholder'),
                                  ),
                                ],
                              ),
                              SizedBox(width: 2.w),
                              Flexible(
                                child: ListView.builder(
                                  itemCount: state.budget.budgetList.length,
                                  itemBuilder: (context, index) {
                                    final budgetList = state.budget.budgetList.toList()[index];
                                    return BudgetListTile(budgetList: budgetList);
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
