import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetman/client/component/component.dart';

void main() async {
  group('Component Test', () {
    testWidgets('Wrapper', (WidgetTester tester) async {
      final key = GlobalKey<WrapperBuilderState>();
      await tester.pumpWidget(MaterialApp(
        home: WrapperBuilder(
          key: key,
          builder: (context, child) {
            return Row(
              children: [
                const Text('Hello'),
                if (child != null) child,
              ],
            );
          },
          child: const Text('World'),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('World'), findsOneWidget);

      final rowWidget = tester.firstWidget(find.byType(Row)) as Row;
      expect(rowWidget.children.length, 2);
      expect(rowWidget.children[1], isA<Text>());
    });

    testWidgets('Loading Overlay', (WidgetTester tester) async {
      late final BuildContext context;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (ctx) {
              context = ctx;
              return const SizedBox();
            },
          ),
        ),
      ));

      LoadingOverlay.show(context);

      expect(ModalRoute.of(context)?.isCurrent, false);
    });

    testWidgets('Loading Overlay Wait', (WidgetTester tester) async {
      late final BuildContext context;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (ctx) {
              context = ctx;
              return const SizedBox();
            },
          ),
        ),
      ));

      await tester.runAsync(() async {
        final future = Future.delayed(const Duration(seconds: 1), () => 'Hello');
        final result = await LoadingOverlay.wait(context, future);

        expect(result, 'Hello');
      });
    });

    testWidgets('Value Change Notifier', (tester) async {
      final notifier = ValueChangeNotifier<int>(0);

      await tester.pumpWidget(MaterialApp(
        home: BlocBuilder<ValueChangeNotifier<int>, int>(
          bloc: notifier,
          builder: (context, value) {
            return Text(value.toString());
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);

      notifier.value = 1;
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Multiple Value Change Notifier Selector', (tester) async {
      final notifiers = (
        ValueChangeNotifier<int>(0),
        ValueChangeNotifier<int>(0),
        ValueChangeNotifier<int>(0),
      );

      await tester.pumpWidget(MaterialApp(
        home: MultipleValueChangeNotifierSelector<int>(
          valueChangeNotifiers: [
            notifiers.$1,
            notifiers.$2,
            notifiers.$3,
          ],
          selector: () => notifiers.$1.value + notifiers.$2.value + notifiers.$3.value,
          builder: (context, state) {
            return Text(state.toString());
          },
        ),
      ));

      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);

      notifiers.$1.value = 1;
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);

      notifiers.$2.value = 2;
      await tester.pumpAndSettle();
      expect(find.text('3'), findsOneWidget);

      notifiers.$3.value = 3;
      await tester.pumpAndSettle();
      expect(find.text('6'), findsOneWidget);
    });

    testWidgets('Custom Alert Dialog', (tester) async {
      late final BuildContext context;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (ctx) {
              context = ctx;
              return const SizedBox();
            },
          ),
        ),
      ));

      await tester.pumpAndSettle();

      for (final type in AlertType.values) {
        CustomAlertDialog.alertWithoutOptions(context, type, 'Title', 'Description');

        await tester.pumpAndSettle();

        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Description'), findsOneWidget);
        expect(find.text('OK'), findsOneWidget);

        final logo = type.icon;
        final logoWidget = tester.widget(find.byIcon(logo)) as Icon;
        expect(logoWidget.icon, logo);

        await tester.tap(find.text('OK'));

        await tester.pumpAndSettle();

        expect(find.text('Title'), findsNothing);
        expect(find.text('Description'), findsNothing);
        expect(find.text('OK'), findsNothing);
      }
    });

    testWidgets('Confirmation Dialog (Confirm Option)', (tester) async {
      late final BuildContext context;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (ctx) {
              context = ctx;
              return const SizedBox();
            },
          ),
        ),
      ));

      await tester.pumpAndSettle();

      final result = ConfirmationDialog.show(
        context: context,
        title: 'Title',
        content: 'Description',
      );

      await tester.pumpAndSettle();

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Confirm'));

      await tester.pumpAndSettle();
      expect(await result, true);
    });

  testWidgets('Confirmation Dialog (Cancel Option)', (tester) async {
      late final BuildContext context;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (ctx) {
              context = ctx;
              return const SizedBox();
            },
          ),
        ),
      ));

      await tester.pumpAndSettle();

      final result = ConfirmationDialog.show(
        context: context,
        title: 'Title',
        content: 'Description',
      );

      await tester.pumpAndSettle();

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Cancel'));

      await tester.pumpAndSettle();
      expect(await result, false);
    });
  });
}
