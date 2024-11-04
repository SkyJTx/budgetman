import 'package:budgetman/client/component/custom_text_form_field.dart';
import 'package:budgetman/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Budget', () {
    testWidgets('Edit Budget', (tester) async {
      await tester.runAsync(() async {
        runApp(await appWidget);
      });
      await tester.pumpAndSettle();

      // scroll down to see the budgets
      await tester.drag(find.byType(NestedScrollView), const Offset(0.0, -200.0));
      await tester.pumpAndSettle();

      // press the first budget card
      await tester.tap(find.text('Budget 1').first);
      await tester.pumpAndSettle();

      // press the "Edit Budget" button
      await tester.tap(find.text('Edit Budget'));
      await tester.pumpAndSettle();

      // enter new budget name into "Title" text field
      await tester.enterText(find.byType(CustomTextFormField).first, 'Test Budget 1 Edited');
      await tester.pumpAndSettle();

      // press "Save" button
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // confirm the dialog
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // check if the budget name is updated
      expect(find.text('Test Budget 1 Edited'), findsOneWidget);
    });
  });
}
