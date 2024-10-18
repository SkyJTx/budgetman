import 'dart:async';

import 'package:budgetman/client/bloc/budget/budget_bloc.dart';
import 'package:budgetman/client/component/custom_list_tile.dart';
import 'package:budgetman/client/component/custom_text_form_field.dart';
import 'package:budgetman/client/component/loading_overlay.dart';
import 'package:budgetman/client/component/value_notifier/value_change_notifier.dart';
import 'package:budgetman/server/component/date_formatter.dart';
import 'package:budgetman/server/component/extension.dart';
import 'package:budgetman/server/component/validator.dart';
import 'package:budgetman/server/data_model/budget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class EditBudget extends StatefulWidget {
  const EditBudget({
    super.key,
    required this.budget,
    this.budgetBloc,
  });

  final BudgetBloc? budgetBloc;
  final Budget budget;

  @override
  State<EditBudget> createState() => EditBudgetState();
}

class EditBudgetState extends State<EditBudget> {
  late BudgetBloc _budgetBloc;
  final _titleController = TextEditingController();
  final _titleFormKey = GlobalKey<FormFieldState<String>>();
  final _descriptionController = TextEditingController();
  final _descriptionFormKey = GlobalKey<FormFieldState<String>>();
  final _startDateController = ValueChangeNotifier<DateTime>(DateTime.now());
  final _endDateController = ValueChangeNotifier<DateTime>(DateTime.now());
  final _isRoutineController = ValueChangeNotifier<bool>(false);
  final _routineIntervalController = ValueChangeNotifier<Duration?>(null);
  final _isCompletedController = ValueChangeNotifier<bool>(false);

  void init() {
    _titleController.text = widget.budget.name;
    _descriptionController.text = widget.budget.description;
    _startDateController.value = widget.budget.startDate;
    _endDateController.value = widget.budget.endDate;
    _isRoutineController.value = widget.budget.isRoutine;
    _routineIntervalController.value = widget.budget.routineInterval?.seconds;
    _isCompletedController.value = widget.budget.isCompleted;
    _titleController.addListener(() {
      _titleFormKey.currentState?.validate();
    });
    _descriptionController.addListener(() {
      _descriptionFormKey.currentState?.validate();
    });
    _budgetBloc = widget.budgetBloc ?? BudgetBloc(widget.budget)
      ..init();
  }

  List<bool> postInit() {
    return [
      _titleFormKey.currentState?.validate() ?? false,
      _descriptionFormKey.currentState?.validate() ?? false,
    ];
  }

  @override
  void initState() {
    init();
    super.initState();
    postInit();
  }

  @override
  void didUpdateWidget(covariant EditBudget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.budgetBloc != widget.budgetBloc) {
      _budgetBloc = widget.budgetBloc ?? BudgetBloc(widget.budget)
        ..init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 70.h,
      ),
      child: BlocProvider.value(
        value: _budgetBloc,
        child: BlocBuilder<BudgetBloc, BudgetState>(
          bloc: _budgetBloc,
          builder: (context, state) {
            if (!state.isInitialized) {
              return const LoadingOverlay();
            }
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 8,
                    right: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 8),
                          Icon(
                            Icons.edit,
                            color: context.theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Edit Budget',
                            style: context.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color: context.theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: ListView(
                      children: [
                        ...[
                          CustomListTile(
                            leading: Icon(
                              Icons.check_circle_rounded,
                              color: context.theme.colorScheme.primary,
                            ),
                            title: 'Completion Check',
                            subtitle: 'Check box to mark as completed',
                            trailing: BlocBuilder<ValueChangeNotifier<bool>, bool>(
                              bloc: _isCompletedController,
                              builder: (context, state) {
                                return Checkbox(
                                  value: state,
                                  onChanged: (value) {
                                    if (value == null) return;
                                    _isCompletedController.value = value;
                                  },
                                );
                              },
                            ),
                          ),
                          CustomTextFormField(
                            key: _titleFormKey,
                            context: context,
                            prefix: const Icon(Icons.title),
                            label: const Text('Title'),
                            hintText: 'Enter budget list\'s title',
                            maxLength: 40,
                            controller: _titleController,
                            validator: Validator.titleValidator,
                            onChanged: (value) {
                              _titleFormKey.currentState?.validate();
                            },
                          ),
                          CustomTextFormField(
                            key: _descriptionFormKey,
                            context: context,
                            prefix: const Icon(Icons.description),
                            label: const Text('Description'),
                            hintText: 'Enter budget list\'s description',
                            maxLength: 100,
                            controller: _descriptionController,
                            validator: Validator.descriptionValidator,
                            onChanged: (value) {
                              _descriptionFormKey.currentState?.validate();
                            },
                          ),
                          BlocBuilder<ValueChangeNotifier<DateTime>, DateTime>(
                            builder: (context, state) {
                              return CustomListTile(
                                leading: Icon(
                                  Icons.date_range,
                                  color: context.theme.colorScheme.primary,
                                ),
                                title: 'Start Date',
                                subtitle: 'Current: ${state.format()}',
                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: context.theme.colorScheme.secondaryContainer,
                                    foregroundColor: context.theme.colorScheme.onSecondaryContainer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: null, //TODO: Implement Start Date
                                  child: Text(
                                    'Select Date',
                                    style: context.theme.textTheme.bodyMedium?.copyWith(
                                      color: context.theme.colorScheme.onSecondaryContainer,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          BlocBuilder<ValueChangeNotifier<DateTime>, DateTime>(
                            builder: (context, state) {
                              return CustomListTile(
                                leading: Icon(
                                  Icons.date_range,
                                  color: context.theme.colorScheme.primary,
                                ),
                                title: 'End Date',
                                subtitle: 'Current: ${state.format()}',
                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: context.theme.colorScheme.secondaryContainer,
                                    foregroundColor: context.theme.colorScheme.onSecondaryContainer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: null, //TODO: Implement Start Date
                                  child: Text(
                                    'Select Date',
                                    style: context.theme.textTheme.bodyMedium?.copyWith(
                                      color: context.theme.colorScheme.onSecondaryContainer,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          CustomListTile(
                            leading: Icon(
                              Icons.check_circle_rounded,
                              color: context.theme.colorScheme.primary,
                            ),
                            title: 'Is Routine?',
                            subtitle: 'Check box to mark as routine',
                            trailing: BlocBuilder<ValueChangeNotifier<bool>, bool>(
                              bloc: _isRoutineController,
                              builder: (context, state) {
                                return Switch(
                                  value: state,
                                  onChanged: (value) {
                                    _isRoutineController.value = value;
                                  },
                                );
                              },
                            ),
                          ),
                          CustomListTile(
                            leading: Icon(
                              Icons.timelapse_outlined,
                              color: context.theme.colorScheme.primary,
                            ),
                            title: 'Routine Interval',
                            trailing: BlocSelector<ValueChangeNotifier<bool>, bool,
                                FutureOr<void> Function()?>(
                              bloc: _isRoutineController,
                              selector: (isRoutine) {
                                if (!isRoutine) return null;
                                return () async {}; //TODO: Implement Routine Interval
                              },
                              builder: (context, state) {
                                return ElevatedButton(
                                  onPressed: state,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: context.theme.colorScheme.secondaryContainer,
                                    foregroundColor: context.theme.colorScheme.onSecondaryContainer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Select Interval',
                                    style: context.theme.textTheme.bodyMedium?.copyWith(
                                      color: context.theme.colorScheme.onSecondaryContainer,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ].map((e) {
                          return Column(
                            children: [
                              e,
                              const Divider(),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
