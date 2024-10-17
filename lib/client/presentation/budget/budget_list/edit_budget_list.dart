import 'dart:typed_data';

import 'package:budgetman/client/bloc/budget/budget_bloc.dart';
import 'package:budgetman/client/component/component.dart';
import 'package:budgetman/client/component/loading_overlay.dart';
import 'package:budgetman/client/component/value_notifier/value_change_notifier.dart';
import 'package:budgetman/client/repository/global_repo.dart';
import 'package:budgetman/extension.dart';
import 'package:budgetman/server/data_model/budget.dart';
import 'package:budgetman/server/data_model/budget_list.dart';
import 'package:budgetman/server/data_model/categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:sizer/sizer.dart';

class EditBudgetList extends StatefulWidget {
  const EditBudgetList({
    super.key,
    required this.budgetBloc,
    required this.budget,
    required this.categories,
    required this.budgetList,
  });

  final BudgetBloc budgetBloc;
  final Budget budget;
  final BudgetList budgetList;
  final List<Category> categories;

  @override
  State<EditBudgetList> createState() => EditBudgetListState();
}

class EditBudgetListState extends State<EditBudgetList> {
  final _checkController = ValueChangeNotifier<bool>(false);
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
  final _imageController = ValueChangeNotifier<List<byte>>([]);

  @override
  void initState() {
    _checkController.value = widget.budgetList.isCompleted;
    _dateTimeController.value = widget.budgetList.deadline;
    _titleController.text = widget.budgetList.title;
    _descriptionController.text = widget.budgetList.description;
    _categoryController.value = widget.budgetList.category.value;
    _priorityController.text = widget.budgetList.priority.toString();
    _amountController.text = widget.budgetList.budget.toString();
    _imageController.value = widget.budgetList.imagesBytes;
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
        child: BlocListener<BudgetBloc, BudgetState>(
          bloc: widget.budgetBloc,
          listener: (context, state) {
            _titleController.text = widget.budgetList.title;
            _descriptionController.text = widget.budgetList.description;
            _priorityController.text = widget.budgetList.priority.toString();
          },
          child: Column(
            children: [
              AppBar(
                title: Text(
                  'Edit Budget List',
                  style: context.textTheme.titleLarge,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Flexible(
                child: ListView(
                  children: [
                    CustomListTile(
                      leading: Icon(
                        Icons.check_circle_rounded,
                        color: context.theme.colorScheme.primary,
                      ),
                      title: 'Completion Check',
                      subtitle: 'Check box to mark as completed',
                      trailing: BlocBuilder<ValueChangeNotifier<bool>, bool>(
                        bloc: _checkController,
                        builder: (context, state) {
                          return Checkbox(
                            value: state,
                            onChanged: (value) {
                              if (value == null) return;
                              _checkController.value = value;
                            },
                          );
                        },
                      ),
                    ),
                    CustomListTile(
                      leading: Icon(
                        Icons.title,
                        color: context.theme.colorScheme.primary,
                      ),
                      title: 'Title',
                      subtitle: 'Enter the title of the budget list',
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
                    CustomListTile(
                      leading: Icon(
                        Icons.description,
                        color: context.theme.colorScheme.primary,
                      ),
                      title: 'Description',
                      subtitle: 'Enter the description of the budget list',
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
                    CustomListTile(
                      leading: Icon(
                        Icons.category,
                        color: context.theme.colorScheme.primary,
                      ),
                      title: 'Category',
                      subtitle: 'Select the category of the budget list',
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
                    CustomListTile(
                      leading: Icon(
                        Icons.priority_high,
                        color: context.theme.colorScheme.primary,
                      ),
                      title: 'Prioity',
                      subtitle: 'Enter the priority of the budget list',
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
                    CustomListTile(
                      leading: Icon(
                        Icons.attach_money,
                        color: context.theme.colorScheme.primary,
                      ),
                      title: 'Budget',
                      subtitle: 'Enter the budget of the budget list',
                      trailing: TextFormField(
                        key: _amountFormKey,
                        controller: _amountController,
                        validator: amountValidator,
                        onChanged: (value) {
                          _amountValidator.value = _amountFormKey.currentState?.validate() ?? false;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Enter budget list\'s budget',
                        ),
                      ),
                    ),
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
                            onPressed: () async {
                              final firstDate = DateTime.now();
                              late final DateTime endDate;
                              if (widget.budget.isRoutine) {
                                endDate = firstDate.add(widget.budget.routineInterval!.seconds);
                              } else {
                                endDate = widget.budget.endDate;
                              }
                              final initDate = widget.budgetList.deadline.isAfter(endDate)
                                  ? endDate
                                  : widget.budgetList.deadline;
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
                    CustomListTile(
                      leading: Icon(
                        Icons.image,
                        color: context.theme.colorScheme.primary,
                      ),
                      title: 'Images',
                      subtitle: 'Add images to the budget list',
                      trailing: ElevatedButton(
                        onPressed: () async {
                          final imagePicker = ImagePicker();
                          final pickedFile =
                              await imagePicker.pickImage(source: ImageSource.gallery);
                          if (pickedFile == null) return;
                          final bytes = await pickedFile.readAsBytes();
                          if (!context.mounted) return;
                          final compressedBytes = await LoadingOverlay.wait(
                              context,
                              FlutterImageCompress.compressWithList(
                                bytes,
                                quality: 50,
                              ));
                          _imageController.value = compressedBytes.toList();
                        },
                        child: Text(
                          'Add Images',
                          style: context.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    BlocSelector<ValueChangeNotifier<List<byte>>, List<byte>, Uint8List?>(
                      bloc: _imageController,
                      selector: (state) {
                        return state.isNotEmpty ? Uint8List.fromList(state) : null;
                      },
                      builder: (context, imageByte) {
                        if (imageByte == null) return const SizedBox.shrink();
                        return Container(
                          constraints: BoxConstraints(
                            maxHeight: 20.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: context.theme.colorScheme.secondaryContainer,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              imageByte,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
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
                            widget.budgetBloc.updateBudgetList(
                              widget.budgetList,
                              title: _titleController.text,
                              description: _descriptionController.text,
                              category: _categoryController.value,
                              priority: int.tryParse(_priorityController.text),
                              budget: double.tryParse(_amountController.text),
                              deadline: _dateTimeController.value,
                              updatedDateTime: DateTime.now(),
                              image: _imageController.value,
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
                              text: 'Budget List Updated Successfully',
                              style: context.textTheme.bodyMedium,
                            ));
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Save',
                        style: context.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
