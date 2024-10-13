import 'package:budgetman/client/bloc/settings/settings_bloc.dart';
import 'package:budgetman/client/component/options_button.dart';
import 'package:budgetman/client/presentation/categories/categories_page.dart';
import 'package:budgetman/client/presentation/home/home_page.dart';
import 'package:budgetman/client/presentation/setting/setting_page.dart';
import 'package:budgetman/extension.dart';
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
            child: ListView(
              children: [
                Align(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 8.h,
                          child: Icon(
                            Icons.account_circle,
                            size: 8.h,
                          ),
                        ),
                        const Text('BudgetMan App',
                            style: TextStyle(fontSize: 30)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    context.go(HomePage.routeName);
                    scaffoldKey.currentState?.closeDrawer();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Budget Manager'),
                  onTap: () {
                    context.go('/budget');
                    scaffoldKey.currentState?.closeDrawer();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.category),
                  title: const Text('Categories Manager'),
                  onTap: () {
                    context.go(CategoriesPage.routeName);
                    scaffoldKey.currentState?.closeDrawer();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    context.go(SettingPage.routeName);
                    scaffoldKey.currentState?.closeDrawer();
                  },
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all([3.w, 3.h].min.toDouble()),
              child: widget.child,
            ),
          ),
          floatingActionButton: widget.state.matchedLocation == '/setting'
              ? null
              : OptionsButton(
                  locate: widget.state.matchedLocation,
                ),
        );
      },
    );
  }
}
