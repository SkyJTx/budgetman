import 'dart:developer';

import 'package:budgetman/client/component/dialog/category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetman/client/bloc/categories/categories_bloc.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  static const String pageName = 'Categories';
  static const String routeName = 'categories';

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          log('CategoriesBloc state: $state');
          if (state is CategoriesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoriesLoaded) {
            if (state.categories.isEmpty) {
              return Center(
                  child: Text(
                'No Category',
                style: theme.textTheme.bodyLarge,
              ));
            }
            return ListView.builder(
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Color(category.colorValue),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            category.name,
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(color: theme.colorScheme.onSurface, fontSize: 20),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: theme.colorScheme.onSurface, size: 25),
                          onPressed: () {
                            showCategoryDialog(context, category: category);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: theme.colorScheme.onSurface, size: 25),
                          onPressed: () {
                            context.read<CategoriesBloc>().add(RemoveCategory(category));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is CategoriesError) {
            return Center(child: Text(state.message, style: theme.textTheme.bodyLarge));
          } else {
            return Center(
                child: Text(
              'Invalid State',
              style: theme.textTheme.bodyLarge,
            ));
          }
        },
      ),
    );
  }
}
