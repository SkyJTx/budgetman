import 'package:budgetman/client/bloc/settings/settings_bloc.dart';
import 'package:budgetman/client/component/theme.dart';
import 'package:budgetman/client/repository/global_repo.dart';
import 'package:budgetman/server/data_model/setting.dart';
import 'package:budgetman/server/repository/budget/budget_repository.dart';
import 'package:budgetman/server/repository/budget_list/budget_list_repository.dart';
import 'package:budgetman/server/repository/categories/categories_repository.dart';
import 'package:budgetman/server/repository/settings/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:budgetman/dependencies_injector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:sizer/sizer.dart';

void main() async {
  runApp(await widget);
}

Future<Widget> get widget => init().then((_) => MultiRepositoryProvider(
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
    ));

class BudgetManApp extends StatefulWidget {
  const BudgetManApp({super.key});

  @override
  State<BudgetManApp> createState() => BudgetManAppState();
}

class BudgetManAppState extends State<BudgetManApp> {
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.addListener(() {
      context.read<SettingsBloc>().setName(nameController.text);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseThemes = MaterialTheme(const TextTheme().apply());
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) {
            nameController.text = state.name;
          },
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'BudgetMan',
              theme: baseThemes.light(),
              darkTheme: baseThemes.dark(),
              highContrastTheme: baseThemes.lightHighContrast(),
              highContrastDarkTheme: baseThemes.darkHighContrast(),
              themeMode: state.theme,
              home: Scaffold(
                appBar: AppBar(
                  title: const Text('BudgetMan'),
                ),
                body: Center(
                  child: ListView(
                    children: [
                      Text('Hello, ${state.name}'),
                      ListTile(
                        title: const Text('Name'),
                        trailing: Container(
                          constraints: BoxConstraints(
                            maxWidth: 70.w,
                          ),
                          child: TextField(
                            controller: nameController,
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text('Theme'),
                        trailing: Builder(
                          builder: (context) {
                            bool isDark = state.theme == ThemeMode.dark;
                            if (state.theme == ThemeMode.system) {
                              isDark =
                                  WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                                      Brightness.dark;
                            }
                            return Switch.adaptive(
                              value: isDark,
                              onChanged: (value) {
                                context.read<SettingsBloc>().toggleTheme();
                              },
                            );
                          },
                        ),
                      ),
                      FutureBuilder(
                        future: () async {
                          final isar = Isar.getInstance();
                          if (isar == null) {
                            throw Exception('Isar instance is not initialized.');
                          }
                          final setting = isar.settings;
                          final name = await setting.getByKey('name');
                          if (name == null) {
                            throw Exception('Name setting is not initialized.');
                          }
                          return name;
                        }(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          final name = snapshot.data as Setting;
                          return Text('Hello, ${name.value} ${name.id}');
                        },
                      ),
                      FutureBuilder(
                        future: () async {
                          final isar = Isar.getInstance();
                          if (isar == null) {
                            throw Exception('Isar instance is not initialized.');
                          }
                          final setting = isar.settings;
                          final theme = await setting.getByKey('theme');
                          if (theme == null) {
                            throw Exception('theme setting is not initialized.');
                          }
                          return theme;
                        }(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          final theme = snapshot.data as Setting;
                          return Text('Hello, ${theme.value} ${theme.id}');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
