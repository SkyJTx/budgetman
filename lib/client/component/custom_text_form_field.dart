import 'package:flutter/material.dart';

class CustomTextFormField extends TextFormField {
  CustomTextFormField({
    super.key,
    required BuildContext context,
    super.enabled,
    super.readOnly,
    super.obscureText,
    super.keyboardType,
    super.initialValue,
    Widget? prefix,
    Widget? label,
    Widget? suffix,
    String? hintText,
    super.maxLength,
    super.controller,
    super.validator,
    super.onChanged,
    super.onTap,
    super.onTapOutside,
    super.onEditingComplete,
    super.onFieldSubmitted,
  }) : super(
          decoration: InputDecoration(
            label: label,
            hintText: hintText,
            prefixIcon: prefix,
            suffixIcon: suffix != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [suffix],
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
}
