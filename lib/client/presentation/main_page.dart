// main_page.dart
import 'package:budgetman/client/bloc/settings/settings_bloc.dart';
import 'package:budgetman/client/component/value_notifier/value_change_notifier.dart';
import 'package:budgetman/client/presentation/budget/budget_page.dart';
import 'package:budgetman/client/presentation/categories/categories_page.dart';
import 'package:budgetman/client/presentation/component/component_page.dart';
import 'package:budgetman/client/component/options_button.dart';
import 'package:budgetman/client/presentation/home/home_page.dart';
import 'package:budgetman/client/presentation/setting/setting_page.dart';
import 'package:budgetman/server/component/extension.dart';
import 'package:budgetman/server/repository/budget/budget_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
    required this.state,
    required this.child,
  });

  final GoRouterState state;
  final Widget child;

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final toggleOptionButtonController = ValueChangeNotifier<bool>(true);

  bool get isOptionButtonVisible => toggleOptionButtonController.value;
  set setOptionButtonVisibility(bool value) => toggleOptionButtonController.value = value;

  List<String> get optionButtonVisibleLocation => [
        HomePage.routeName,
        '/${CategoriesPage.routeName}',
      ];

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.matchedLocation != widget.state.matchedLocation) {
      setOptionButtonVisibility = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValueChangeNotifier<bool>, bool>(
      bloc: toggleOptionButtonController,
      builder: (context, isVisible) {
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: ListTile(
                  title: const Text('BudgetMan App'),
                  subtitle: kDebugMode ? Text(widget.state.matchedLocation) : null,
                  titleTextStyle: context.textTheme.titleLarge,
                ),
              ),
              drawer: Drawer(
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 3.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          'assets/image/logo/logo.png',
                          width: 150,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'BudgetMan',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'a budget management app',
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 3.h),
                      Flexible(
                        child: ListView(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.home),
                              title: const Text('Home'),
                              onTap: () {
                                context.go(HomePage.routeName);
                                scaffoldKey.currentState!.closeDrawer();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.category),
                              title: const Text('Categories'),
                              onTap: () {
                                context.go('/${CategoriesPage.routeName}');
                                scaffoldKey.currentState!.closeDrawer();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.settings),
                              title: const Text('Setting'),
                              onTap: () {
                                context.go('/${SettingPage.routeName}');
                                scaffoldKey.currentState!.closeDrawer();
                              },
                            ),
                            SizedBox(height: 3.h),
                            if (kDebugMode) ...[
                              Container(
                                margin: const EdgeInsets.only(left: 4),
                                child: const Row(
                                  children: [
                                    Icon(Icons.developer_mode),
                                    SizedBox(width: 4),
                                    Text('Developer Mode'),
                                    SizedBox(width: 4),
                                    Flexible(child: Divider()),
                                  ],
                                ),
                              ),
                              ListTile(
                                leading: const Icon(Icons.money),
                                title: const Text('Budget'),
                                onTap: () async {
                                  final budget = await BudgetRepository()
                                      .getAll()
                                      .then((value) => value.first);
                                  if (!context.mounted) return;
                                  context.go('/${BudgetPage.routeName}', extra: budget);
                                  scaffoldKey.currentState!.closeDrawer();
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.widgets),
                                title: const Text('Component'),
                                onTap: () {
                                  context.go('/${ComponentPage.routeName}');
                                  scaffoldKey.currentState!.closeDrawer();
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: SafeArea(
                child: widget.child,
              ),
              floatingActionButton: isVisible &&
                      optionButtonVisibleLocation
                          .any((element) => element == widget.state.matchedLocation)
                  ? OptionsButton(
                      locate: optionButtonVisibleLocation
                          .firstWhere((element) => element == widget.state.matchedLocation),
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}
