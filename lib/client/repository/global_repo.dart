import 'dart:async';

import 'package:budgetman/client/presentation/budget/budget_page.dart';
import 'package:budgetman/client/presentation/categories/categories_page.dart';
import 'package:budgetman/client/presentation/component/component_page.dart';
import 'package:budgetman/client/presentation/home/home_page.dart';
import 'package:budgetman/client/presentation/main_page.dart';
import 'package:budgetman/client/presentation/setting/setting_page.dart';
import 'package:budgetman/server/component/extension.dart';
import 'package:budgetman/server/data_model/budget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class ClientRepository {
  ClientRepository._privateConstructor();

  static final ClientRepository instance = ClientRepository._privateConstructor();

  factory ClientRepository() {
    return instance;
  }

  void showErrorSnackBar(
    BuildContext context, {
    Widget? leading,
    required TextSpan message,
    Widget? trailing,
  }) {
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        content: ListTile(
          leading: leading,
          title: Text.rich(
            message,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.theme.colorScheme.onError,
            ),
          ),
          trailing: trailing,
        ),
        backgroundColor: context.theme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showSuccessSnackBar(
    BuildContext context, {
    Widget? leading,
    required TextSpan message,
    Widget? trailing,
  }) {
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        content: ListTile(
          leading: leading,
          title: Text.rich(
            message,
          ),
          trailing: trailing,
        ),
        backgroundColor: context.theme.colorScheme.secondaryContainer,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  MainPageState get mainPageState => mainPageKey.currentState!;
  
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static final GlobalKey<MainPageState> mainPageKey = GlobalKey<MainPageState>();
  final List<FutureOr<void> Function(ClientRepository)> listeners = [];
  final router = GoRouter(
    initialLocation: HomePage.routeName,
    navigatorKey: navigatorKey,
    routes: [
      ShellRoute(
        pageBuilder: (context, state, child) {
          return MaterialPage(
            child: MainPage(
              key: mainPageKey,
              state: state,
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            path: HomePage.routeName,
            pageBuilder: goPageBuilder(
              builder: (context, state) {
                return const HomePage();
              },
            ),
          ),
          GoRoute(
            path: BudgetPage.routeName,
            pageBuilder: goPageBuilder(
              builder: (context, state) {
                final budget = state.extra;
                if (budget is Budget) {
                  return BudgetPage(
                    budget: budget,
                  );
                }
                throw ArgumentError('Expected Argument: Budget, Got: $budget');
              },
            ),
          ),
          GoRoute(
            path: CategoriesPage.routeName,
            pageBuilder: goPageBuilder(
              builder: (context, state) {
                return const CategoriesPage();
              },
            ),
          ),
          GoRoute(
            path: SettingPage.routeName,
            pageBuilder: goPageBuilder(
              builder: (context, state) {
                return const SettingPage();
              },
            ),
          ),
          GoRoute(
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
