import 'package:budgetman/client/bloc/settings/settings_bloc.dart';
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
                        trailing: Builder(builder: (context) {
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
                        }),
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
