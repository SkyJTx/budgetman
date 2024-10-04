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

  static final ClientRepository _instance = ClientRepository._privateConstructor();

  factory ClientRepository() {
    return _instance;
  }

  final List<FutureOr<void> Function(ClientRepository)> listeners = [];
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final router = GoRouter(
    initialLocation: '/home',
    navigatorKey: _instance.navigatorKey,
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
            path: HomePage.routeName,
            pageBuilder: _instance.goPageBuilder(
              builder: (context, state) {
                return const HomePage();
              },
            ),
          ),
          GoRoute(
            path: BudgetPage.routeName,
            pageBuilder: _instance.goPageBuilder(
              builder: (context, state) {
                return const BudgetPage();
              },
            ),
          ),
          GoRoute(
            path: CategoriesPage.routeName,
            pageBuilder: _instance.goPageBuilder(
              builder: (context, state) {
                return const CategoriesPage();
              },
            ),
          ),
          GoRoute(
            path: SettingPage.routeName,
            pageBuilder: _instance.goPageBuilder(
              builder: (context, state) {
                return const SettingPage();
              },
            ),
          ),
          GoRoute(
            path: ComponentPage.routeName,
            pageBuilder: _instance.goPageBuilder(
              builder: (context, state) {
                return const ComponentPage();
              },
            ),
          ),
        ],
      ),
    ],
  );

  Page<dynamic> Function(BuildContext, GoRouterState) goPageBuilder({
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
