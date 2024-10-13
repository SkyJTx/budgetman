import 'dart:developer';

import 'package:budgetman/client/component/value_notifier/value_change_notifier.dart';
import 'package:budgetman/extension.dart';
import 'package:budgetman/server/data_model/budget_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BudgetListTile extends StatefulWidget {
  const BudgetListTile({
    super.key,
    required this.budgetList,
    this.selectionModeController,
    this.selectionController,
    this.completeController,
    this.onInit,
    this.onPressComplete,
    this.onPressDelete,
    this.onPressEdit,
    this.onSelectionModeChanged,
    this.onBudgetListSelection,
  });

  final ValueChangeNotifier<bool>? selectionModeController;
  final ValueChangeNotifier<bool>? selectionController;
  final ValueChangeNotifier<bool>? completeController;
  final void Function(
    BudgetList budgetList,
    ValueChangeNotifier<bool> selectionModeController,
    ValueChangeNotifier<bool> selectionController,
    ValueChangeNotifier<bool> completeController,
  )? onInit;
  final void Function(BudgetList budgetList, ValueChangeNotifier<bool> selectionModeController)?
      onSelectionModeChanged;
  final void Function(BudgetList budgetList, ValueChangeNotifier<bool> selectionController)?
      onBudgetListSelection;
  final void Function(BudgetList budgetList, ValueChangeNotifier<bool> completeController)?
      onPressComplete;
  final void Function(BudgetList budgetList)? onPressEdit;
  final void Function(BudgetList budgetList)? onPressDelete;
  final BudgetList budgetList;

  @override
  State<BudgetListTile> createState() => BudgetListTileState();
}

class BudgetListTileState extends State<BudgetListTile> {
  final _expandedController = ExpansionTileController();
  late ValueChangeNotifier<bool> _selectionModeController;
  late ValueChangeNotifier<bool> _selectionController;
  late ValueChangeNotifier<bool> _completeController;

  @override
  void initState() {
    _selectionModeController = widget.selectionModeController ?? ValueChangeNotifier(false);
    _selectionController = widget.selectionController ?? ValueChangeNotifier(false);
    _completeController = widget.completeController ?? ValueChangeNotifier(false);
    super.initState();
    widget.onInit?.call(
      widget.budgetList,
      _selectionModeController,
      _selectionController,
      _completeController,
    );
  }

  @override
  void didUpdateWidget(covariant BudgetListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectionModeController != widget.selectionModeController) {
      _selectionModeController = widget.selectionModeController ?? ValueChangeNotifier(false);
    }
    if (oldWidget.selectionController != widget.selectionController) {
      _selectionController = widget.selectionController ?? ValueChangeNotifier(false);
    }
    if (oldWidget.completeController != widget.completeController) {
      _completeController = widget.completeController ?? ValueChangeNotifier(false);
    }
  }

  void expand() {
    _expandedController.expand();
  }

  void collapse() {
    _expandedController.collapse();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _selectionModeController),
        BlocProvider.value(value: _selectionController),
        BlocProvider.value(value: _completeController),
      ],
      child: Column(
        children: [
          ExpansionTile(
            controller: _expandedController,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide.none,
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide.none,
            ),
            expansionAnimationStyle: AnimationStyle(
              curve: Curves.easeInOut,
              duration: 0.3.seconds,
              reverseCurve: Curves.easeInOut,
              reverseDuration: 0.3.seconds,
            ),
            leading: BlocBuilder<ValueChangeNotifier<bool>, bool>(
              bloc: _selectionController,
              builder: (context, state) {
                return Checkbox(
                  value: state,
                  onChanged: (value) {
                    _selectionController.value = value!;
                    widget.onBudgetListSelection?.call(widget.budgetList, _selectionController);
                  },
                );
              },
            ),
            title: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: widget.budgetList.category.value?.color ??
                        context.theme.colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    widget.budgetList.category.value?.name ?? 'None',
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      color: widget.budgetList.category.value?.color ??
                          context.theme.colorScheme.onTertiary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.budgetList.title,
                  style: context.theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  strutStyle: const StrutStyle(height: 1.5),
                ),
              ],
            ),
            subtitle: Row(
              children: [
                Text(
                  '฿ ${widget.budgetList.budget.toShortString()}',
                  style: context.theme.textTheme.titleMedium,
                ),
                const SizedBox(width: 8),
                Builder(builder: (context) {
                  Color? color;
                  Color? textColor;
                  if (widget.budgetList.deadline.isBefore(DateTime.now())) {
                    color = context.theme.colorScheme.error;
                    textColor = context.theme.colorScheme.onError;
                  } else if (widget.budgetList.deadline.isBefore(DateTime.now().add(1.days))) {
                    color = Colors.yellowAccent;
                    textColor = Colors.black;
                  }
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      DateFormat('dd/MM/y').format(widget.budgetList.deadline),
                      style: context.theme.textTheme.titleMedium?.copyWith(
                        color: textColor ?? context.theme.colorScheme.onSurface,
                      ),
                    ),
                  );
                }),
              ],
            ),
            children: [
              Divider(
                height: 1,
                color: context.theme.colorScheme.primary,
              ),
              Text(
                widget.budgetList.description,
                style: context.theme.textTheme.titleMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
