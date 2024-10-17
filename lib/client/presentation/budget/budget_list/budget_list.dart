import 'dart:async';
import 'dart:typed_data';

import 'package:budgetman/client/component/value_notifier/value_change_notifier.dart';
import 'package:budgetman/extension.dart';
import 'package:budgetman/server/data_model/budget_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class BudgetListTile extends StatefulWidget {
  const BudgetListTile({
    super.key,
    required this.budgetList,
    this.expandedController,
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

  final ExpansionTileController? expandedController;
  final ValueChangeNotifier<bool>? selectionModeController;
  final ValueChangeNotifier<bool>? selectionController;
  final ValueChangeNotifier<bool>? completeController;
  final void Function(
    BudgetList budgetList,
    ValueChangeNotifier<bool> selectionModeController,
    ValueChangeNotifier<bool> selectionController,
    ValueChangeNotifier<bool> completeController,
  )? onInit;
  final FutureOr<void> Function(
          BudgetList budgetList, ValueChangeNotifier<bool> selectionModeController)?
      onSelectionModeChanged;
  final FutureOr<void> Function(
      BudgetList budgetList, ValueChangeNotifier<bool> selectionController)? onBudgetListSelection;
  final FutureOr<void> Function(
      BudgetList budgetList, ValueChangeNotifier<bool> completeController)? onPressComplete;
  final FutureOr<void> Function(BudgetList budgetList)? onPressEdit;
  final FutureOr<void> Function(BudgetList budgetList)? onPressDelete;
  final BudgetList budgetList;

  @override
  State<BudgetListTile> createState() => BudgetListTileState();
}

class BudgetListTileState extends State<BudgetListTile> {
  late ExpansionTileController _expandedController;
  late ValueChangeNotifier<bool> _selectionModeController;
  late ValueChangeNotifier<bool> _selectionController;
  late ValueChangeNotifier<bool> _completeController;

  @override
  void initState() {
    _selectionModeController = widget.selectionModeController ?? ValueChangeNotifier(false);
    _selectionController = widget.selectionController ?? ValueChangeNotifier(false);
    _completeController = widget.completeController ?? ValueChangeNotifier(false);
    _expandedController = widget.expandedController ?? ExpansionTileController();
    super.initState();
    widget.onInit?.call(
      widget.budgetList,
      _selectionModeController,
      _selectionController,
      _completeController,
    );
    _selectionModeController.addListener((notifier) {
      widget.onSelectionModeChanged?.call(widget.budgetList, notifier);
    });
    _selectionController.addListener((notifier) {
      widget.onBudgetListSelection?.call(widget.budgetList, notifier);
    });
    _completeController.addListener((notifier) {
      widget.onPressComplete?.call(widget.budgetList, notifier);
    });
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
    if (oldWidget.expandedController != widget.expandedController) {
      _expandedController = widget.expandedController ?? ExpansionTileController();
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
      child: ExpansionTile(
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
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        backgroundColor: context.theme.colorScheme.primaryContainer,
        collapsedBackgroundColor: context.theme.colorScheme.surfaceContainerHighest,
        leading: BlocBuilder<ValueChangeNotifier<bool>, bool>(
          bloc: _completeController,
          builder: (context, state) {
            return Checkbox(
              value: state,
              onChanged: (value) async {
                _completeController.value = value!;
              },
            );
          },
        ),
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color:
                    widget.budgetList.category.value?.color ?? context.theme.colorScheme.tertiary,
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
            Builder(
              builder: (context) {
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
              },
            ),
          ],
        ),
        children: [
          Divider(
            height: 1,
            color: context.theme.colorScheme.primary,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SelectionArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Description: ',
                              style: context.theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: widget.budgetList.description,
                              style: context.theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Priority: ',
                              style: context.theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: widget.budgetList.priority.toString(),
                              style: context.theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Amount: ',
                              style: context.theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '฿ ${widget.budgetList.budget.toStringAsFixed(2)}',
                              style: context.theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Created: ',
                              style: context.theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: DateFormat('dd/MM/y').format(widget.budgetList.createdAt),
                              style: context.theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Deadline: ',
                              style: context.theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: DateFormat('dd/MM/y').format(widget.budgetList.deadline),
                              style: context.theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 2.w),
                Flexible(
                  child: Center(
                    child: ElevatedButton(
                      onPressed: widget.budgetList.imagesBytes.isEmpty
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: Stack(
                                      children: [
                                        InteractiveViewer(
                                          child: Image.memory(
                                            Uint8List.fromList(widget.budgetList.imagesBytes),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned.directional(
                                          textDirection: Directionality.of(context),
                                          end: 0,
                                          top: 0,
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            label: const Text('Close'),
                                            icon: const Icon(Icons.close),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          'View Image',
                          textAlign: TextAlign.center,
                          style: context.theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                    onPressed: widget.onPressEdit != null
                        ? () {
                            widget.onPressEdit?.call(widget.budgetList);
                          }
                        : null,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                  const VerticalDivider(width: 2),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    onPressed: widget.onPressDelete != null
                        ? () {
                            widget.onPressDelete?.call(widget.budgetList);
                          }
                        : null,
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }
}
