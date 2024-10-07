import 'dart:async';

import 'package:budgetman/client/presentation/budget/budget_page.dart';
import 'package:budgetman/client/presentation/categories/categories_page.dart';
import 'package:budgetman/client/presentation/component/component_page.dart';
import 'package:budgetman/client/presentation/home/home_page.dart';
import 'package:budgetman/client/presentation/main_page.dart';
import 'package:budgetman/client/presentation/setting/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class ClientRepository {
  ClientRepository._privateConstructor();

  static final ClientRepository instance = ClientRepository._privateConstructor();

  factory ClientRepository() {
    return instance;
  }

  final List<FutureOr<void> Function(ClientRepository)> listeners = [];
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static final router = GoRouter(
    initialLocation: SettingPage.routeName,
    navigatorKey: navigatorKey,
    routes: [
      ShellRoute(
        pageBuilder: (context, state, child) {
          return MaterialPage(
            child: MainPage(
              state: state,
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            name: HomePage.pageName,
            path: HomePage.routeName,
            pageBuilder: goPageBuilder(
              builder: (context, state) {
                return const HomePage();
              },
            ),
          ),
          GoRoute(
            name: BudgetPage.pageName,
            path: BudgetPage.routeName,
            pageBuilder: goPageBuilder(
              builder: (context, state) {
                return const BudgetPage();
              },
            ),
          ),
          GoRoute(
            name: CategoriesPage.pageName,
            path: CategoriesPage.routeName,
            pageBuilder: goPageBuilder(
              builder: (context, state) {
                return const CategoriesPage();
              },
            ),
          ),
          GoRoute(
            name: SettingPage.pageName,
            path: SettingPage.routeName,
            pageBuilder: goPageBuilder(
              builder: (context, state) {
                return const SettingPage();
              },
            ),
          ),
          GoRoute(
            name: ComponentPage.pageName,
            path: ComponentPage.routeName,
            pageBuilder: goPageBuilder(
              builder: (context, state) {
                return const ComponentPage();
              },
            ),
          ),
        ],
      ),
    ],
  );

  static Page<dynamic> Function(BuildContext, GoRouterState) goPageBuilder({
    required Widget Function(BuildContext context, GoRouterState state) builder,
  }) {
    return (BuildContext context, GoRouterState state) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: builder(context, state),
        transitionDuration: 0.3.seconds,
        reverseTransitionDuration: 0.15.seconds,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: Tween(
              begin: 0.9,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeInOutCubic)).animate(animation),
            child: ScaleTransition(
              scale: Tween(
                begin: 1.0,
                end: 1.1,
              ).chain(CurveTween(curve: Curves.easeInOutCubic)).animate(secondaryAnimation),
              child: FadeTransition(
                opacity: Tween(
                  begin: 0.0,
                  end: 1.0,
                ).chain(CurveTween(curve: Curves.linear)).animate(animation),
                child: FadeTransition(
                  opacity: Tween(
                    begin: 1.0,
                    end: 0.0,
                  )
                      .chain(CurveTween(curve: Curves.fastEaseInToSlowEaseOut))
                      .animate(secondaryAnimation),
                  child: child,
                ),
              ),
            ),
          );
        },
      );
    };
  }

  void addListener(FutureOr<void> Function(ClientRepository) listener) {
    listeners.add(listener);
  }

  void removeListener(FutureOr<void> Function(ClientRepository) listener) {
    listeners.remove(listener);
  }

  void notifyListeners() {
    for (final listener in listeners) {
      listener(this);
    }
  }

  void dispose() {
    listeners.clear();
  }
}
