// main.dart
import 'package:budgetman/client/bloc/categories/categories_bloc.dart';
import 'package:budgetman/client/bloc/settings/settings_bloc.dart';
import 'package:budgetman/client/component/theme.dart';
import 'package:budgetman/client/repository/global_repo.dart';
import 'package:budgetman/server/repository/budget/budget_repository.dart';
import 'package:budgetman/server/repository/budget_list/budget_list_repository.dart';
import 'package:budgetman/server/repository/categories/categories_repository.dart';
import 'package:budgetman/server/repository/settings/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:budgetman/dependencies_injector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

void main() async {
  runApp(await widget);
}

Future<Widget> get widget => init().then((_) => MultiRepositoryProvider(
      providers: [
        // จัดเตรียม CategoryRepository โดยใช้ RepositoryProvider<T>.create แยกต่างหาก
        RepositoryProvider<CategoryRepository>(
          create: (_) => CategoryRepository(),
        ),
        // จัดเตรียม repositories อื่นๆ โดยใช้ .map และ RepositoryProvider.value
        ...[
          ClientRepository(),
          BudgetRepository(),
          BudgetListRepository(),
          SettingsRepository()..init(),
        ].map((e) => RepositoryProvider.value(value: e)),
      ],
      child: MultiBlocProvider(
        providers: [
          // จัดเตรียม SettingsBloc
          BlocProvider<SettingsBloc>(
            create: (context) => SettingsBloc()..init(),
          ),
          // จัดเตรียม CategoriesBloc โดยดึง CategoryRepository จาก context
          BlocProvider<CategoriesBloc>(
            create: (context) => CategoriesBloc(
              context.read<CategoryRepository>(),
            )..add(LoadCategories()),
          ),
        ],
        child: const BudgetManApp(),
      ),
    ));

class BudgetManApp extends StatefulWidget {
  const BudgetManApp({super.key});

  @override
  State<BudgetManApp> createState() => BudgetManAppState();
}

class BudgetManAppState extends State<BudgetManApp> {
  @override
  Widget build(BuildContext context) {
    final baseThemes = MaterialTheme(const TextTheme().apply());
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return MaterialApp.router(
              routerConfig: ClientRepository.router,
              debugShowCheckedModeBanner: false,
              title: 'BudgetMan',
              theme: baseThemes.light(),
              darkTheme: baseThemes.dark(),
              highContrastTheme: baseThemes.lightHighContrast(),
              highContrastDarkTheme: baseThemes.darkHighContrast(),
              themeMode: state.theme,
            );
          },
        );
      },
    );
  }
}