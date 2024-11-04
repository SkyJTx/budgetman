import 'package:budgetman/client/bloc/categories/categories_bloc.dart';
import 'package:budgetman/client/bloc/home/home_bloc.dart';
import 'package:budgetman/client/bloc/settings/settings_bloc.dart';
import 'package:budgetman/client/component/theme.dart';
import 'package:budgetman/client/repository/global_repo.dart';
import 'package:budgetman/server/repository/budget/budget_repository.dart';
import 'package:budgetman/server/repository/budget_list/budget_list_repository.dart';
import 'package:budgetman/server/repository/categories/categories_repository.dart';
import 'package:budgetman/server/repository/services/notification_services.dart';
import 'package:budgetman/server/repository/services/services.dart';
import 'package:budgetman/server/repository/settings/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sizer/sizer.dart';

void main() async {
  runApp(await appWidget);
}

Future<Widget> get appWidget => Services().init().then(
      (payload) {
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<CategoryRepository>(
              create: (_) => CategoryRepository(),
            ),
            ...[
              ClientRepository(),
              BudgetRepository(),
              BudgetListRepository(),
              SettingsRepository()..init(),
            ].map((e) => RepositoryProvider.value(value: e)),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<SettingsBloc>(
                create: (context) => SettingsBloc()..init(),
              ),
              BlocProvider(
                create: (context) => HomeBloc()..init(),
              ),
              BlocProvider<CategoriesBloc>(
                create: (context) => CategoriesBloc(
                  context.read<CategoryRepository>(),
                )..add(
                    LoadCategories(),
                  ),
              ),
            ],
            child: BudgetManApp(
              notificationAppLaunchDetails: payload.notificationAppLaunchDetails,
            ),
          ),
        );
      },
    );

class BudgetManApp extends StatefulWidget {
  final NotificationAppLaunchDetails? notificationAppLaunchDetails;
  const BudgetManApp({
    super.key,
    this.notificationAppLaunchDetails,
  });

  @override
  State<BudgetManApp> createState() => BudgetManAppState();
}

class BudgetManAppState extends State<BudgetManApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final isLaunchedByNotification =
          widget.notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
      if (isLaunchedByNotification &&
          widget.notificationAppLaunchDetails?.notificationResponse != null) {
        NotificationServices.onDidReceiveNotificationResponse(
          widget.notificationAppLaunchDetails!.notificationResponse!,
        );
      }
    });
  }

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
