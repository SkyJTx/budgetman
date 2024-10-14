import 'package:collection/collection.dart';
import 'package:budgetman/client/bloc/budget/budget_bloc.dart';
import 'package:budgetman/client/component/dialog/confirmation_dialog.dart';
import 'package:budgetman/client/presentation/budget/budget_list/budget_list.dart';
import 'package:budgetman/client/repository/global_repo.dart';
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
              final sortedBudgetList = state.budget.budgetList
                  .where((budgetList) => !budgetList.isRemoved)
                  .sortedBy((e) => e.deadline)
                  .sortedBy<num>((e) => e.isCompleted ? 1 : 0);
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
                          final budgetListView = ListView(
                            children: [
                              ...sortedBudgetList.map((budgetList) {
                                final budgetListTileState = GlobalKey<BudgetListTileState>();
                                return Column(
                                  children: [
                                    BudgetListTile(
                                      key: budgetListTileState,
                                      budgetList: budgetList,
                                      onInit: (
                                        budgetList,
                                        selectionModeController,
                                        selectionController,
                                        completeController,
                                      ) {
                                        completeController.value = budgetList.isCompleted;
                                      },
                                      onPressComplete: (budgetList, completeController) async {
                                        await budgetBloc.updateBudgetList(
                                          budgetList,
                                          isCompleted: completeController.value,
                                        );

                                        if (context.mounted) {
                                          ClientRepository().showSuccessSnackBar(
                                            context,
                                            message: TextSpan(
                                              text: budgetList.title,
                                              style: context.theme.textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: ' is marked as ',
                                                  style: context.theme.textTheme.titleMedium,
                                                ),
                                                TextSpan(
                                                  text: completeController.value
                                                      ? '"Completed"'
                                                      : '"Incomplete"',
                                                  style:
                                                      context.theme.textTheme.titleMedium?.copyWith(
                                                    color: completeController.value
                                                        ? Colors.green
                                                        : Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                      onPressDelete: (budgetList) async {
                                        final isConfirm = (await showDialog<bool>(
                                          context: context,
                                          builder: (context) {
                                            return ConfirmationDialog(
                                              context: context,
                                              title: 'Are you sure to delete?',
                                              content:
                                                  'You are deleting ${budgetList.title} from the list. This action cannot be undone.',
                                              onPressAction: (isConfirm) {
                                                Navigator.of(context).pop(isConfirm);
                                              },
                                            );
                                          },
                                        ))!;
                                        if (isConfirm) {
                                          budgetListTileState.currentState?.collapse();
                                          await budgetBloc.removeBudgetList(budgetList);
                                        }
                                      },
                                    ),
                                    SizedBox(height: 2.h),
                                  ],
                                );
                              }),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 32),
                                child: Text(
                                  'End of Budget List',
                                  textAlign: TextAlign.center,
                                  style: context.theme.textTheme.titleMedium,
                                ),
                              ),
                            ],
                          );
                          const graphWidget = Text('Graph Placeholder');
                          final utilityWidget = Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: null,
                                style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                  ),
                                ),
                                label: const Text('Edit Budget'),
                                icon: const Icon(Icons.edit),
                              ),
                              VerticalDivider(
                                width: 2,
                                color: context.theme.colorScheme.secondary,
                              ),
                              ElevatedButton.icon(
                                onPressed: null,
                                style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                ),
                                label: const Text('Add Budget List'),
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          );

                          if (80.w < 100.h) {
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: context.theme.colorScheme.surfaceContainerHighest,
                                  ),
                                  height: 40.h,
                                  alignment: Alignment.center,
                                  child: graphWidget,
                                ),
                                const SizedBox(height: 8),
                                utilityWidget,
                                SizedBox(height: 2.h),
                                Flexible(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: budgetListView,
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
                                      child: graphWidget,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  utilityWidget,
                                ],
                              ),
                              SizedBox(width: 2.w),
                              Flexible(child: budgetListView),
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
