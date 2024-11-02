import 'package:budgetman/client/bloc/settings/settings_bloc.dart';
import 'package:budgetman/client/component/theme.dart';
import 'package:budgetman/client/repository/global_repo.dart';
import 'package:budgetman/server/repository/budget/budget_repository.dart';
import 'package:budgetman/server/repository/budget_list/budget_list_repository.dart';
import 'package:budgetman/server/repository/categories/categories_repository.dart';
import 'package:budgetman/server/repository/services/services.dart';
import 'package:budgetman/server/repository/settings/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

void main() async {
  runApp(await widget);
}

Future<Widget> get widget => Services().init().then(
      (compatible) {
        if (compatible) {
          return MultiRepositoryProvider(
            providers: [
              ClientRepository(),
              BudgetRepository(),
              BudgetListRepository(),
              CategoryRepository(),
              SettingsRepository()..init(),
            ].map((e) => RepositoryProvider.value(value: e)).toList(),
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => SettingsBloc()..init(),
                ),
              ],
              child: const BudgetManApp(),
            ),
          );
        }
        return const MaterialApp(
          home: Scaffold(
            body: SafeArea(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Icon(
                    Icons.error,
                    size: 100.0,
                    color: Colors.red,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Your device is not compatible with this app.',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )),
          ),
        );
      },
    );

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
              scaffoldMessengerKey: ClientRepository.scaffoldMessengerKey,
              routerConfig: ClientRepository().router,
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
