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
  final ValueChangeNotifier<bool> _expandedController = ValueChangeNotifier(false);
  late ValueChangeNotifier<bool> _selectionModeController;
  late ValueChangeNotifier<bool> _selectionController;
  late ValueChangeNotifier<bool> _completeController;
  late AnimationController _animationController;

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

  void toggleExpandCollapse() {
    _expandedController.value = !_expandedController.value;
  }

  void expand() {
    _expandedController.value = true;
  }

  void collapse() {
    _expandedController.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _selectionModeController),
        BlocProvider.value(value: _selectionController),
        BlocProvider.value(value: _completeController),
        BlocProvider.value(value: _expandedController),
      ],
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: toggleExpandCollapse,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<ValueChangeNotifier<bool>, bool>(
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
              Flexible(
                child: Text(
                  widget.budgetList.title,
                  style: context.theme.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                  strutStyle: const StrutStyle(height: 1.5),
                ),
              ),
              Text(
                '฿ ${widget.budgetList.budget.toShortString()}',
                style: context.theme.textTheme.titleMedium,
              ),
              if (widget.budgetList.category.value != null) Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: widget.budgetList.category.value!.color,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.budgetList.category.value!.name,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  DateFormat('dd/MM/y').format(widget.budgetList.deadline),
                  style: context.theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
