import 'package:budgetman/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Budget', () {
    testWidgets('Add Budget', (tester) async {
      await tester.runAsync(() async {
        runApp(await appWidget);
      });
      await tester.pumpAndSettle();

      // press floating action button
      await tester.tap(find.byKey(const Key('options_button')));
      await tester.pumpAndSettle();

      // press "Add Budget" button
      await tester.tap(find.text('Add Budget'));
      await tester.pumpAndSettle();

      // enter budget name into "Budget Name" text field
      // find the text field by widget type
      await tester.enterText(find.byType(TextField), 'Test Budget 1');
      await tester.pumpAndSettle();

      // press "Add" button
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // wait for the dialog to close
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // scroll down to see the newly added budget without showing render overflow error
      await tester.drag(find.byType(NestedScrollView), const Offset(0.0, -500.0));
      await tester.pumpAndSettle();

      // expect the budget name to be displayed
      expect(find.text('Test Budget 1'), findsOneWidget);
    });
  });
}
