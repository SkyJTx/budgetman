import 'package:budgetman/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Budget List', () {

    testWidgets('Delete Budget List', (tester) async {
      await tester.runAsync(() async {
        runApp(await appWidget);
      });
      await tester.pumpAndSettle();
  
      // scroll down to see the budgets
      await tester.drag(find.byType(NestedScrollView), const Offset(0.0, -200.0));
      await tester.pumpAndSettle();

      // press the first budget edit icon button
      await tester.tap(find.byIcon(Icons.edit).first);
      await tester.pumpAndSettle();

      // press the budget list
      await tester.tap(find.text('Budget List 1'));
      await tester.pumpAndSettle();

      // press the first budget list trash icon button in the custom expansion tile
      await tester.dragUntilVisible(
        find.byKey(const Key('delete_button_of_budget_list')),
        find.byType(ListView),
        const Offset(0.0, -500.0),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('delete_button_of_budget_list')));
      await tester.pumpAndSettle();

      // press "Confirm" button
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // check if the budget list is deleted
      await tester.drag(find.byType(ListView), const Offset(0.0, 1000.0));
      await tester.pumpAndSettle();

      expect(find.text('Budget List 1'), findsNothing);
    });
  });
}
