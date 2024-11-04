import 'package:budgetman/client/component/custom_text_form_field.dart';
import 'package:budgetman/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Budget List', () {
    testWidgets('Add Budget List', (tester) async {
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

      // press the "Add Budget List" button
      await tester.tap(find.text('Add Budget List'));
      await tester.pumpAndSettle();

      // enter new budget list name into "Title" text field
      await tester.enterText(find.byType(CustomTextFormField).at(0), 'Test Budget List 1');
      await tester.pumpAndSettle();

      // enter new budget list description into "Description" text field
      await tester.enterText(
          find.byType(CustomTextFormField).at(1), 'Test Budget List 1 Description');
      await tester.pumpAndSettle();

      // enter the priority into "Priority" text field
      await tester.enterText(find.byType(CustomTextFormField).at(2), '1');
      await tester.pumpAndSettle();

      // enter the amount into "Amount" text field
      await tester.enterText(find.byType(CustomTextFormField).at(3), '1000');
      await tester.pumpAndSettle();

      // press "Create" button
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // press "Confirm" button
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // check if the budget list is added
      await tester.dragUntilVisible(
        find.text('Test Budget List 1'),
        find.byType(ListView),
        const Offset(0.0, -500.0),
      );
      await tester.pumpAndSettle();
      expect(find.text('Test Budget List 1'), findsOneWidget);
    });
  });
}
