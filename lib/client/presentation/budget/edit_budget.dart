import 'dart:async';

import 'package:budgetman/client/bloc/budget/budget_bloc.dart';
import 'package:budgetman/client/component/custom_list_tile.dart';
import 'package:budgetman/client/component/custom_text_form_field.dart';
import 'package:budgetman/client/component/dialog/confirmation_dialog.dart';
import 'package:budgetman/client/component/loading_overlay.dart';
import 'package:budgetman/client/component/value_notifier/value_change_notifier.dart';
import 'package:budgetman/client/repository/global_repo.dart';
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
  final _routineIntervalController = TextEditingController();
  final _routineIntervalFormKey = GlobalKey<FormFieldState<String>>();
  final _isCompletedController = ValueChangeNotifier<bool>(false);

  void init() {
    _titleController.text = widget.budget.name;
    _descriptionController.text = widget.budget.description;
    _startDateController.value = widget.budget.startDate;
    _endDateController.value = widget.budget.endDate;
    _isRoutineController.value = widget.budget.isRoutine;
    _routineIntervalController.text =
        (widget.budget.routineInterval?.seconds.inDays ?? '').toString();
    _isCompletedController.value = widget.budget.isCompleted;
    _titleController.addListener(() {
      _titleFormKey.currentState?.validate();
    });
    _descriptionController.addListener(() {
      _descriptionFormKey.currentState?.validate();
    });
    _routineIntervalController.addListener(() {
      _routineIntervalFormKey.currentState?.validate();
    });
    _budgetBloc = widget.budgetBloc ?? BudgetBloc(widget.budget)
      ..init();
  }

  List<bool> postInit() {
    return [
      _titleFormKey.currentState?.validate() ?? false,
      _descriptionFormKey.currentState?.validate() ?? false,
      if (_isRoutineController.value) _routineIntervalFormKey.currentState?.validate() ?? false,
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

  Future<DateTime> getDate({
    required BuildContext context,
    required DateTime firstDate,
    required DateTime lastDate,
    required DateTime currentDate,
    required String title,
  }) async {
    final value = await showDatePicker(
      context: context,
      helpText: title,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: currentDate,
      useRootNavigator: false,
    );
    if (value == null) {
      return currentDate;
    }
    return value;
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
                          ),
                          BlocBuilder<ValueChangeNotifier<DateTime>, DateTime>(
                            bloc: _startDateController,
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
                                  onPressed: () async {
                                    final value = await getDate(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365)),
                                      currentDate: state,
                                      title: 'Select Start Date',
                                    );
                                    _startDateController.value = value;
                                  },
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
                            bloc: _endDateController,
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
                                  onPressed: () async {
                                    final value = await getDate(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365)),
                                      currentDate: state,
                                      title: 'Select End Date',
                                    );
                                    _endDateController.value = value;
                                  },
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
                          BlocBuilder<ValueChangeNotifier<bool>, bool>(
                            bloc: _isRoutineController,
                            builder: (context, state) {
                              return CustomTextFormField(
                                enabled: state,
                                key: _routineIntervalFormKey,
                                context: context,
                                prefix: const Icon(Icons.repeat),
                                label: const Text('Routine Interval'),
                                suffix: const Text('days'),
                                hintText: 'Enter routine interval in days',
                                keyboardType: TextInputType.number,
                                controller: _routineIntervalController,
                                validator: Validator.routineIntervalDayValidator,
                                onTapOutside: (event) {
                                  final parsedDouble =
                                      double.tryParse(_routineIntervalController.text);
                                  if (parsedDouble == null) {
                                    _routineIntervalController.text = '';
                                  } else {
                                    _routineIntervalController.text =
                                        parsedDouble.round().toString();
                                  }
                                },
                                onEditingComplete: () {
                                  final parsedDouble =
                                      double.tryParse(_routineIntervalController.text);
                                  if (parsedDouble == null) {
                                    _routineIntervalController.text = '';
                                  } else {
                                    _routineIntervalController.text =
                                        parsedDouble.round().toString();
                                  }
                                },
                              );
                            },
                          )
                        ].map((e) {
                          return Column(
                            children: [
                              e,
                              const Divider(),
                            ],
                          );
                        }),
                        ElevatedButton(
                          onPressed: () async {
                            final isValid = postInit().reduce((value, element) => value && element);
                            if (!isValid) return;
                            if (!await ConfirmationDialog.show(
                              context: context,
                              title: 'Do you want to change this budget?',
                              content: 'Please confirm your inputs. This action cannot be undone.',
                            )) return;
                            if (!context.mounted) return;
                            await LoadingOverlay.wait(
                                context,
                                _budgetBloc.updateBudget(
                                  name: _titleController.text,
                                  description: _descriptionController.text,
                                  startDate: _startDateController.value,
                                  endDate: _endDateController.value,
                                  isRoutine: _isRoutineController.value,
                                  routineInterval:
                                      int.tryParse(_routineIntervalController.text)?.days.inSeconds,
                                  isCompleted: _isCompletedController.value,
                                ));
                            if (!context.mounted) return;
                            if (state.error != null) {
                              ClientRepository().showErrorSnackBar(
                                context,
                                message: TextSpan(
                                  text: state.error!.message,
                                  style: context.textTheme.bodyMedium,
                                ),
                              );
                            }
                            ClientRepository().showSuccessSnackBar(context,
                                message: TextSpan(
                                  text: 'Budget Updated Successfully',
                                  style: context.textTheme.bodyMedium,
                                ));
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.theme.colorScheme.primary,
                            foregroundColor: context.theme.colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              'Save',
                              style: context.textTheme.headlineMedium?.copyWith(
                                color: context.theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
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
