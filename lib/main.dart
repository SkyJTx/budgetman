import 'package:budgetman/client/bloc/settings/settings_bloc.dart';
import 'package:budgetman/server/repository/settings/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:budgetman/dependencies_injector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  await init();
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(
        create: (context) => SettingsRepository()..init(),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingsBloc()..init(),
        ),
      ],
      child: const BudgetManApp(),
    ),
  ));
}

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
    nameController.text = BlocProvider.of<SettingsBloc>(context).state.name;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'BudgetMan',
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.yellow,
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.yellow,
              brightness: Brightness.dark,
            ),
          ),
          themeMode: state.theme,
          home: Scaffold(
            appBar: AppBar(
              title: const Text('BudgetMan'),
            ),
            body: Center(
              child: Column(
                children: [
                  Text('Hello, ${state.name}'),
                  ListTile(
                    title: const Text('Name'),
                    trailing: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                      ),
                      child: TextField(
                        controller: nameController,
                        onChanged: (value) {
                          context.read<SettingsBloc>().setName(value);
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Theme'),
                    trailing: Builder(builder: (context) {
                      bool isDark = state.theme == ThemeMode.dark;
                      if (state.theme == ThemeMode.system) {
                        isDark = WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                            Brightness.dark;
                      }
                      return Switch.adaptive(
                        value: isDark,
                        onChanged: (value) {
                          context.read<SettingsBloc>().toggleTheme();
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
