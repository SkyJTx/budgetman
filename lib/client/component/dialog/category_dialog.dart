import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetman/client/bloc/categories/categories_bloc.dart';
import 'package:budgetman/server/data_model/categories.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color? selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPickerDialog({
    super.key,
    this.selectedColor,
    required this.onColorSelected,
  });

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color? _currentColor;
  bool _showCustomPicker = false;

  final List<Color> colorOptions = const [
    Colors.purple,
    Colors.red,
    Color(0xFFFF6B6B),
    Color(0xFFFFB5B5),
    Colors.orange,
    Colors.blue,
    Colors.green,
    Color(0xFF90EE90),
    Colors.yellow,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.brown,
    Colors.amber,
  ];

  @override
  void initState() {
    super.initState();
    _currentColor = widget.selectedColor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // ดึงธีมปัจจุบัน

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showCustomPicker = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: !_showCustomPicker
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface, // ใช้สีจากธีม
                foregroundColor: !_showCustomPicker
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface, // สีข้อความตามธีม
              ),
              child: const Text('Preset'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showCustomPicker = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _showCustomPicker
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface, // ใช้สีจากธีม
                foregroundColor: _showCustomPicker
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface, // สีข้อความตามธีม
              ),
              child: const Text('Custom'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (!_showCustomPicker)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ...colorOptions.map((color) => _ColorOption(
                    color: color,
                    isSelected: _currentColor == color,
                    onTap: () {
                      setState(() {
                        _currentColor = color;
                        widget.onColorSelected(color);
                      });
                    },
                  )),
            ],
          ),
        if (_showCustomPicker)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              children: [
                ColorPicker(
                  pickerColor: _currentColor ?? Colors.green,
                  onColorChanged: (color) {
                    setState(() {
                      _currentColor = color;
                      widget.onColorSelected(color);
                    });
                  },
                  enableAlpha: false,
                  pickerAreaHeightPercent: 0.8,
                  hexInputBar: true,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorOption({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // ดึงธีมปัจจุบัน

    return GestureDetector(
      onTap: onTap,
      onLongPress: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent, // ใช้สีจากธีม
            width: 2,
          ),
        ),
        child: isSelected
            ? Icon(
                Icons.check,
                color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
              )
            : null,
      ),
    );
  }
}

// ฟังก์ชันแสดง CategoryDialog
void showCategoryDialog(BuildContext context, {Category? category}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
    ),
    isScrollControlled: true,
    builder: (context) => CategoryDialog(category: category),
  );
}

// CategoryDialog ยังคงเหมือนเดิม ไม่ได้เปลี่ยนแปลง
class CategoryDialog extends StatefulWidget {
  final Category? category;

  const CategoryDialog({
    super.key,
    this.category,
  });

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  Color? _selectedColor;
  bool _showColorPicker = false;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _selectedColor = Color(widget.category!.colorValue);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // ดึงธีมปัจจุบัน

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 33,
          left: 38.0,
          right: 38.0,
          top: 25.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Category name',
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.hintColor,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                style: theme.textTheme.bodyLarge,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter category name';
                  }
                  final categoriesState = context.read<CategoriesBloc>().state;
                  if (categoriesState is CategoriesLoaded) {
                    final isDuplicate = categoriesState.categories.any((category) =>
                        category.name.toLowerCase() == value.toLowerCase() &&
                        category.id != widget.category?.id); // ไม่นับกรณีที่กำลังแก้ไขหมวดหมู่เดิม

                    if (isDuplicate) {
                      return 'Category name already exists';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 33.0),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Category color',
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.hintColor,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0), // Added padding
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _selectedColor ?? Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    _showColorPicker = !_showColorPicker;
                  });
                },
                validator: (value) {
                  if (_selectedColor == null) {
                    return 'select category color';
                  }
                  return null;
                },
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: _showColorPicker
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ColorPickerDialog(
                          selectedColor: _selectedColor,
                          onColorSelected: (color) {
                            setState(() {
                              _selectedColor = color;
                            });
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 33.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final colorValue = _selectedColor?.value ?? Colors.grey.value;
                      final categoriesState = context.read<CategoriesBloc>().state;

                      if (categoriesState is CategoriesLoaded) {
                        final isDuplicate = categoriesState.categories.any((category) =>
                            category.name.toLowerCase() == _nameController.text.toLowerCase() &&
                            category.id != widget.category?.id);

                        if (isDuplicate) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Category name already exists'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                      }
                      if (widget.category != null) {
                        context.read<CategoriesBloc>().add(UpdateCategory(
                              widget.category!,
                              name: _nameController.text,
                              description: '',
                              colorValue: colorValue,
                              updatedDateTime: DateTime.now(),
                            ));
                      } else {
                        context.read<CategoriesBloc>().add(AddCategory(
                              name: _nameController.text,
                              colorValue: colorValue,
                              description: '',
                              createdDateTime: DateTime.now(),
                              updatedDateTime: DateTime.now(),
                            ));
                      }
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.onSurface,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
