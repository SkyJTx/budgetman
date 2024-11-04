import 'package:budgetman/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Budget', () {
    testWidgets('Delete Budget', (tester) async {
      await tester.runAsync(() async {
        runApp(await appWidget);
      });
      await tester.pumpAndSettle();

      // scroll down to see the budgets
      await tester.drag(find.byType(NestedScrollView), const Offset(0.0, -200.0));
      await tester.pumpAndSettle();

      // press the first budget trash icon button
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      // confirm the dialog
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // acknowledge the dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // check if the budget is deleted
      expect(find.text('Test Budget 1 Edited'), findsNothing);
      expect(find.text('No Budgets'), findsOneWidget);
    });
  });
}
