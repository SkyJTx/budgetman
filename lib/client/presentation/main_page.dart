import 'package:budgetman/client/bloc/settings/settings_bloc.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: ListTile(
              title: const Text('BudgetMan App'),
              subtitle: Text(widget.state.matchedLocation),
              titleTextStyle: context.textTheme.titleLarge,
            ),
          ),
          drawer: const Drawer(),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all([3.w, 3.h].min.toDouble()),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
