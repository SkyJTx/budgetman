import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetman/client/bloc/categories/categories_bloc.dart';
import 'package:budgetman/server/data_model/categories.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color? selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPickerDialog({
    Key? key,
    this.selectedColor,
    required this.onColorSelected,
  }) : super(key: key);

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
              child: Text('Preset'),
              style: ElevatedButton.styleFrom(
                backgroundColor: !_showCustomPicker
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface, // ใช้สีจากธีม
                foregroundColor: !_showCustomPicker
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface, // สีข้อความตามธีม
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showCustomPicker = true;
                });
              },
              child: Text('Custom'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _showCustomPicker
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface, // ใช้สีจากธีม
                foregroundColor: _showCustomPicker
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface, // สีข้อความตามธีม
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
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
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.transparent, // ใช้สีจากธีม
            width: 2,
          ),
        ),
        child: isSelected
            ? Icon(
                Icons.check,
                color:
                    color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
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
                  hintText: 'ชื่อหมวดหมู่',
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                style: theme.textTheme.bodyLarge,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อหมวดหมู่';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 33.0),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'เลือกสี',
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.hintColor,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
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
                    return 'กรุณาเลือกสี';
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
                      final colorValue =
                          _selectedColor?.value ?? Colors.grey.value;
                      if (widget.category != null) {
                        final updatedCategory = Category(
                          id: widget.category!.id,
                          name: _nameController.text,
                          description: '',
                          colorValue: colorValue,
                          updatedDateTime: DateTime.now(),
                        );
                        context
                            .read<CategoriesBloc>()
                            .add(UpdateCategory(updatedCategory));
                      } else {
                        final newCategory = Category(
                          name: _nameController.text,
                          colorValue: colorValue,
                          description: '',
                          createdDateTime: DateTime.now(),
                        );
                        context
                            .read<CategoriesBloc>()
                            .add(AddCategory(newCategory));
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
                    'ยืนยัน',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.colorScheme.onPrimary),
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