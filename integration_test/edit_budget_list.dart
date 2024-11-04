import 'package:budgetman/client/component/custom_text_form_field.dart';
import 'package:budgetman/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Budget List', () {
    testWidgets('Edit Budget List', (tester) async {
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

      // press the budget list
      await tester.tap(find.text('Budget List 1'));
      await tester.pumpAndSettle();

      // press the first budget list edit icon button in the custom expansion tile
      await tester.dragUntilVisible(
        find.byKey(const Key('edit_button_of_budget_list')),
        find.byType(ListView),
        const Offset(0.0, -250.0),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('edit_button_of_budget_list')));
      await tester.pumpAndSettle();

      // enter new budget list name into "Title" text field
      await tester.enterText(find.byType(CustomTextFormField).at(0), 'Budget List 1 Edited');
      await tester.pumpAndSettle();

      // press "Save" button
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // press "Confirm" button
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // check if the budget list is updated
      await tester.dragUntilVisible(
        find.text('Budget List 1 Edited'),
        find.byType(ListView),
        const Offset(0.0, 250.0),
      );
      await tester.pumpAndSettle();
      expect(find.text('Budget List 1 Edited'), findsOneWidget);
    });
  });
}
