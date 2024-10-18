import 'package:budgetman/client/bloc/settings/settings_bloc.dart';
import 'package:budgetman/client/presentation/budget/budget_page.dart';
import 'package:budgetman/client/presentation/categories/categories_page.dart';
import 'package:budgetman/client/presentation/component/component_page.dart';
import 'package:budgetman/client/component/options_button.dart';
import 'package:budgetman/client/presentation/home/home_page.dart';
import 'package:budgetman/client/presentation/setting/setting_page.dart';
import 'package:budgetman/server/component/extension.dart';
import 'package:budgetman/server/repository/budget/budget_repository.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: ListTile(
                title: const Text('BudgetMan App'),
                subtitle: Text(widget.state.matchedLocation),
                titleTextStyle: context.textTheme.titleLarge,
              ),
            ),
            drawer: Drawer(
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 3.h),
                    const CircleAvatar(
                      radius: 50,
                      child: FlutterLogo(size: 50),
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
                            leading: const Icon(Icons.money),
                            title: const Text('Budget'),
                            onTap: () async {
                              final budget =
                                  await BudgetRepository().getAll().then((value) => value.first);
                              if (!context.mounted) return;
                              context.go(BudgetPage.routeName, extra: budget);
                              scaffoldKey.currentState!.closeDrawer();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.category),
                            title: const Text('Categories'),
                            onTap: () {
                              context.go(CategoriesPage.routeName);
                              scaffoldKey.currentState!.closeDrawer();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.widgets),
                            title: const Text('Component'),
                            onTap: () {
                              context.go(ComponentPage.routeName);
                              scaffoldKey.currentState!.closeDrawer();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.settings),
                            title: const Text('Setting'),
                            onTap: () {
                              context.go(SettingPage.routeName);
                              scaffoldKey.currentState!.closeDrawer();
                            },
                          ),
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
            floatingActionButton: () {
              if (widget.state.matchedLocation == HomePage.routeName) {
                return const OptionsButton(locate: HomePage.routeName);
              }
            }());
      },
    );
  }
}
