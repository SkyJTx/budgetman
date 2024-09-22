import 'package:flutter/material.dart';
import 'package:budgetman/dependencies_injector.dart';

void main() async {
  await init();
  runApp(const BudgetManApp());
}

class BudgetManApp extends StatelessWidget {
  const BudgetManApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('BudgetMan'),
        ),
        body: const Center(
          child: Text('Welcome to BudgetMan'),
        ),
      ),
    );
  }
}
