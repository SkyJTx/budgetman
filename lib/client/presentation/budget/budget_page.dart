import 'package:budgetman/client/component/chart/line_chart.dart';
import 'package:budgetman/client/presentation/budget/budget_list/add_budget_list.dart';
import 'package:budgetman/client/presentation/budget/budget_list/edit_budget_list.dart';
import 'package:budgetman/client/presentation/budget/edit_budget.dart';
import 'package:collection/collection.dart';
import 'package:budgetman/client/bloc/budget/budget_bloc.dart';
import 'package:budgetman/client/component/dialog/confirmation_dialog.dart';
import 'package:budgetman/client/presentation/budget/budget_list/budget_list.dart';
import 'package:budgetman/client/repository/global_repo.dart';
import 'package:budgetman/server/component/extension.dart';
import 'package:budgetman/server/data_model/budget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
          return BlocConsumer<BudgetBloc, BudgetState>(
            bloc: budgetBloc,
            listener: (context, state) {
              if (state.error != null) {
                ClientRepository().showErrorSnackBar(
                  context,
                  message: TextSpan(
                    text: state.error!.message,
                    style: context.theme.textTheme.bodyMedium,
                  ),
                );
              }
            },
            builder: (context, state) {
              final filteredBudgetList =
                  state.budget.budgetList.where((budgetList) => !budgetList.isRemoved);
              final sortedBudgetList = filteredBudgetList
                  .sortedBy<num>((e) => -e.priority)
                  .sortedBy((e) => e.deadline)
                  .sortedBy<num>((e) => e.isCompleted ? 1 : 0);
              return Container(
                padding: EdgeInsets.all([3.h, 3.w].min.toDouble()),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.budget.name,
                            style: context.theme.textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
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
                                        if (state.error != null) return;
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
                                      onPressEdit: (budgetList) {
                                        showBarModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return EditBudgetList(
                                              budgetBloc: budgetBloc,
                                              budget: widget.budget,
                                              categories: state.categories,
                                              budgetList: budgetList,
                                            );
                                          },
                                        );
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
                                          if (state.error != null) return;
                                          if (!context.mounted) return;
                                          ClientRepository().showSuccessSnackBar(
                                            context,
                                            message: TextSpan(
                                              text: budgetList.title,
                                              style: context.theme.textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              children: const [
                                                TextSpan(
                                                  text: ' is deleted successfully.',
                                                ),
                                              ],
                                            ),
                                          );
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

                          final graphWidget = Builder(
                            builder: (context) {
                              if (sortedBudgetList.isEmpty) {
                                return const Center(
                                  child: Text('No budget list found'),
                                );
                              }
                              final mapper = filteredBudgetList.map((e) {
                                return (x: e.deadline, y: e.budget);
                              });
                              final sortedData = <DateTime, double>{};
                              for (final e in mapper) {
                                final key = e.x;
                                if (sortedData.containsKey(key)) {
                                  sortedData[key] = sortedData[key]! + e.y;
                                } else {
                                  sortedData[key] = e.y;
                                }
                              }
                              final firstDateTime = sortedData.keys.first;
                              return Padding(
                                padding: EdgeInsets.all([2.w, 2.h].min.toDouble()),
                                child: CustomLineChart(
                                  data: sortedData.entries
                                      .map((e) => FlSpot(
                                            e.key.difference(firstDateTime).inDays.toDouble(),
                                            e.value.roundToDouble(),
                                          ))
                                      .sortedBy<num>((e) => e.x),
                                  getTooltipItems: (spot) {
                                    return spot.map((e) {
                                      final date = firstDateTime.add(Duration(days: e.x.toInt()));
                                      return LineTooltipItem(
                                        'Deadline: ${DateFormat('dd/MM/y').format(date)}',
                                        TextStyle(
                                          color: context.theme.colorScheme.onSurface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                '\n Amount: ${e.y.toShortString(fractionDigits: 0)}',
                                            style: TextStyle(
                                              color: context.theme.colorScheme.onSurface,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList();
                                  },
                                  maxY: sortedData.values.max * 1.5,
                                  minY: -1,
                                  leftAxisTitleWidget: const Text('Amount'),
                                  bottomAxisTitleWidget: const Text('Date Time'),
                                  getLeftAxisTitlesWidget: (value, meta) {
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(
                                        value.toShortString(fractionDigits: 0),
                                      ),
                                    );
                                  },
                                  getBottomAxisTitlesWidget: (value, meta) {
                                    final date = firstDateTime.add(Duration(days: value.toInt()));
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      space: 4,
                                      child: Text(
                                        DateFormat('dd/MM/y').format(date),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );

                          final utilityWidget = ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 80.w < 100.h || 100.w < 898 ? double.infinity : 50.w,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      showBarModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return EditBudget(
                                            budgetBloc: budgetBloc,
                                            budget: widget.budget,
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                        ),
                                      ),
                                    ),
                                    label: const Text(
                                      'Edit Budget',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    icon: const Icon(Icons.edit),
                                  ),
                                ),
                                VerticalDivider(
                                  width: 2,
                                  color: context.theme.colorScheme.secondary,
                                ),
                                Flexible(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      showBarModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return AddBudgetList(
                                            budgetBloc: budgetBloc,
                                            budget: widget.budget,
                                            categories: state.categories,
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                      ),
                                    ),
                                    label: const Text(
                                      'Add Budget List',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    icon: const Icon(Icons.add),
                                  ),
                                ),
                              ],
                            ),
                          );

                          // Vertical
                          if (80.w < 100.h || 100.w < 898) {
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

                          // Horizontal
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
                                      width: 50.w,
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
