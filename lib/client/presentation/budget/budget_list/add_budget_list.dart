import 'package:budgetman/client/bloc/budget/budget_bloc.dart';
import 'package:budgetman/client/component/component.dart';
import 'package:budgetman/client/component/loading_overlay.dart';
import 'package:budgetman/client/component/value_notifier/value_change_notifier.dart';
import 'package:budgetman/client/repository/global_repo.dart';
import 'package:budgetman/extension.dart';
import 'package:budgetman/server/data_model/budget.dart';
import 'package:budgetman/server/data_model/categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class AddBudgetList extends StatefulWidget {
  const AddBudgetList({
    super.key,
    required this.budgetBloc,
    required this.budget,
    required this.categories,
  });

  final BudgetBloc budgetBloc;
  final Budget budget;
  final List<Category> categories;

  @override
  State<AddBudgetList> createState() => AddBudgetListState();
}

class AddBudgetListState extends State<AddBudgetList> {
  final _dateTimeController = ValueChangeNotifier<DateTime>(DateTime.now());
  final _titleController = TextEditingController();
  final _titleFormKey = GlobalKey<FormFieldState<String>>();
  final _titleValidator = ValueChangeNotifier<bool>(false);
  final _descriptionController = TextEditingController();
  final _descriptionFormKey = GlobalKey<FormFieldState<String>>();
  final _descriptionValidator = ValueChangeNotifier<bool>(false);
  final _categoryController = ValueChangeNotifier<Category?>(null);
  final _priorityController = TextEditingController();
  final _priorityFormKey = GlobalKey<FormFieldState<String>>();
  final _priorityValidator = ValueChangeNotifier<bool>(false);
  final _amountController = TextEditingController();
  final _amountFormKey = GlobalKey<FormFieldState<String>>();
  final _amountValidator = ValueChangeNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _titleValidator.value = _titleFormKey.currentState?.validate() ?? false;
    _descriptionValidator.value = _descriptionFormKey.currentState?.validate() ?? false;
    _priorityValidator.value = _priorityFormKey.currentState?.validate() ?? false;
    _amountValidator.value = _amountFormKey.currentState?.validate() ?? false;
  }

  String? titleValidator(String? value) {
    final frontBackSpaceRegEx = RegExp(r'^\s+|\s+$');
    if (value == null || value.isEmpty) {
      return 'Title cannot be empty';
    }
    if (value.length < 3) {
      return 'Title must be at least 3 characters';
    }
    if (value.length > 40) {
      return 'Title must be at most 40 characters';
    }
    if (frontBackSpaceRegEx.hasMatch(value)) {
      return 'Title must be different from the previous one';
    }
    return null;
  }

  String? descriptionValidator(String? value) {
    final frontBackSpaceRegEx = RegExp(r'^\s+|\s+$');
    if (value == null) {
      return 'Description cannot be empty';
    }
    if (value.length > 100) {
      return 'Description must be at most 100 characters';
    }
    if (frontBackSpaceRegEx.hasMatch(value)) {
      return 'Description must be different from the previous one';
    }
    return null;
  }

  String? priorityValidator(String? value) {
    final numValue = int.tryParse(value ?? '');
    if (numValue == null) {
      return 'Priority must be a number';
    }
    if (numValue < 1) {
      return 'Priority must be at least 1';
    }
    return null;
  }

  String? amountValidator(String? value) {
    final numValue = double.tryParse(value ?? '');
    if (numValue == null) {
      return 'Amount must be a number';
    }
    if (numValue < 0) {
      return 'Amount must be at least 0';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 70.h,
      ),
      child: BlocProvider.value(
        value: widget.budgetBloc,
        child: Column(
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
                      Icon(
                        Icons.add,
                        color: context.theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Add Budget List',
                        style: context.textTheme.headlineMedium,
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
                    CustomListTile(
                      leading: Icon(
                        Icons.title,
                        color: context.theme.colorScheme.primary,
                      ),
                      title: 'Title',
                      trailing: TextFormField(
                        key: _titleFormKey,
                        validator: titleValidator,
                        onChanged: (value) {
                          _titleValidator.value = _titleFormKey.currentState?.validate() ?? false;
                        },
                        maxLength: 40,
                        decoration: const InputDecoration(
                          hintText: 'Enter budget list\'s title',
                        ),
                        controller: _titleController,
                      ),
                    ),
                    const Divider(),
                    CustomListTile(
                      leading: Icon(
                        Icons.description,
                        color: context.theme.colorScheme.primary,
                      ),
                      title: 'Description',
                      trailing: TextFormField(
                        key: _descriptionFormKey,
                        validator: descriptionValidator,
                        onChanged: (value) {
                          _descriptionValidator.value =
                              _descriptionFormKey.currentState?.validate() ?? false;
                        },
                        maxLength: 100,
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Enter budget list\'s description',
                        ),
                      ),
                    ),
                    const Divider(),
                    CustomListTile(
                      leading: Icon(
                        Icons.category,
                        color: context.theme.colorScheme.primary,
                      ),
                      title: 'Category',
                      trailing: DropdownMenu<Category?>(
                        dropdownMenuEntries: [
                          DropdownMenuEntry(
                            value: null,
                            leadingIcon: CircleAvatar(
                              backgroundColor: context.theme.colorScheme.tertiary,
                            ),
                            labelWidget: const Text('None'),
                            label: 'None',
                          ),
                          ...widget.categories.map((e) {
                            return DropdownMenuEntry(
                              value: e,
                              leadingIcon: CircleAvatar(
                                backgroundColor: e.color,
                              ),
                              labelWidget: Text(e.name),
                              label: e.name,
                            );
                          }),
                        ],
                        onSelected: (value) {
                          _categoryController.value = value;
                        },
                      ),
                    ),
                    const Divider(),
                    CustomListTile(
                      leading: Icon(
                        Icons.priority_high,
                        color: context.theme.colorScheme.primary,
                      ),
                      title: 'Priority',
                      subtitle: 'Highest priority will show first',
                      trailing: TextFormField(
                        key: _priorityFormKey,
                        validator: priorityValidator,
                        onChanged: (value) {
                          _priorityValidator.value =
                              _priorityFormKey.currentState?.validate() ?? false;
                        },
                        keyboardType: TextInputType.number,
                        controller: _priorityController,
                        decoration: const InputDecoration(
                          hintText: 'Enter budget list\'s priority',
                        ),
                      ),
                    ),
                    const Divider(),
                    CustomListTile(
                      leading: Icon(
                        Icons.attach_money,
                        color: context.theme.colorScheme.primary,
                      ),
                      title: 'Amount',
                      trailing: TextFormField(
                        key: _amountFormKey,
                        controller: _amountController,
                        validator: amountValidator,
                        onChanged: (value) {
                          _amountValidator.value = _amountFormKey.currentState?.validate() ?? false;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Enter budget list\'s amount',
                        ),
                      ),
                    ),
                    const Divider(),
                    BlocBuilder<ValueChangeNotifier<DateTime>, DateTime>(
                      bloc: _dateTimeController,
                      builder: (context, state) {
                        return CustomListTile(
                          leading: Icon(
                            Icons.calendar_today,
                            color: context.theme.colorScheme.primary,
                          ),
                          title: 'Deadline',
                          subtitle: 'Current: ${DateFormat('dd/MM/y').format(state)}',
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.theme.colorScheme.secondaryContainer,
                              foregroundColor: context.theme.colorScheme.onSecondaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              final firstDate = DateTime.now();
                              late final DateTime endDate;
                              if (widget.budget.isRoutine) {
                                endDate = firstDate.add(widget.budget.routineInterval!.seconds);
                              } else {
                                endDate = widget.budget.endDate;
                              }
                              final initDate = endDate;
                              final selected = await showDatePicker(
                                context: context,
                                initialDate: initDate,
                                firstDate: firstDate,
                                lastDate: endDate,
                              );
                              if (selected == null) return;
                              _dateTimeController.value = selected;
                            },
                            child: Text(
                              'Select Deadline',
                              style: context.textTheme.bodyMedium,
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    ElevatedButton(
                      onPressed: () async {
                        _titleValidator.value = _titleFormKey.currentState?.validate() ?? false;
                        _descriptionValidator.value =
                            _descriptionFormKey.currentState?.validate() ?? false;
                        _priorityValidator.value =
                            _priorityFormKey.currentState?.validate() ?? false;
                        _amountValidator.value = _amountFormKey.currentState?.validate() ?? false;
                        if (!_titleValidator.value ||
                            !_descriptionValidator.value ||
                            !_priorityValidator.value ||
                            !_amountValidator.value) {
                          return;
                        }
                        await LoadingOverlay.wait(
                            context,
                            widget.budgetBloc.addBudgetList(
                              title: _titleController.text,
                              description: _descriptionController.text,
                              category: _categoryController.value,
                              priority: int.tryParse(_priorityController.text) ?? 1,
                              amount: double.tryParse(_amountController.text) ?? 0,
                              deadline: _dateTimeController.value,
                              updatedDateTime: DateTime.now(),
                            ));
                        if (!context.mounted) return;
                        if (widget.budgetBloc.state.error != null) {
                          ClientRepository().showErrorSnackBar(
                            context,
                            message: TextSpan(
                              text: widget.budgetBloc.state.error!.message,
                              style: context.textTheme.bodyMedium,
                            ),
                          );
                        }
                        ClientRepository().showSuccessSnackBar(context,
                            message: TextSpan(
                              text: 'Budget List Created Successfully',
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
                          'Create',
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
        ),
      ),
    );
  }
}
