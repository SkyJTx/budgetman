import 'package:budgetman/client/bloc/settings/settings_bloc.dart';
import 'package:budgetman/client/presentation/setting/setting_page.dart';
import 'package:budgetman/server/repository/services/notification_payload.dart';
import 'package:budgetman/server/repository/services/notification_services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:budgetman/client/component/component.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComponentPage extends StatefulWidget {
  const ComponentPage({super.key});

  static const String pageName = 'Component';
  static const String routeName = 'component';

  @override
  State<ComponentPage> createState() => ComponentPageState();
}

class ComponentPageState extends State<ComponentPage> {
  final testValueNotifier = ValueChangeNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: ListView(
          children: [
        Text(
          'Component Page',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: context.theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        CustomExpansionTile(
          context: context,
          title: 'Custom Expansion Tile',
          children: const [
            ListTile(
              leading: Icon(Icons.abc),
              title: Text('List Tile'),
              trailing: Icon(Icons.baby_changing_station),
            ),
            CustomListTile(
              leading: Icon(Icons.abc),
              title: 'Custom List Tile',
              trailing: Icon(Icons.baby_changing_station),
            )
          ],
        ),
        CustomTextFormField(
          context: context,
          label: const Text('Custom Text Form Field'),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 100),
          child: const Row(
            children: [
              Text(
                'Loading Overlay',
                overflow: TextOverflow.ellipsis,
              ),
              Flexible(child: LoadingOverlay()),
            ],
          ),
        ),
        WrapperBuilder(
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: context.theme.colorScheme.primary),
              ),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Wrapper Builder Outside',
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: context.theme.colorScheme.primary),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: child ?? const SizedBox(),
                  ),
                ],
              ),
            );
          },
          child: const Text('Wrapper Builder Inside'),
        ),
        Column(
          children: [
            const Text('Custom Line Chart'),
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: CustomLineChart(
                data: [
                  for (var i = -10.0; i <= 10.0; i++) FlSpot(i, i.pow(2).toDouble()),
                ],
                maxY: 100,
                minY: 0,
              ),
            ),
          ],
        ),
        BlocBuilder<ValueChangeNotifier<bool>, bool>(
          bloc: testValueNotifier,
          builder: (context, value) {
            return ElevatedButton(
              onPressed: () {
                testValueNotifier.value = !value;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    value ? context.theme.colorScheme.primary : context.theme.colorScheme.secondary,
                foregroundColor: value
                    ? context.theme.colorScheme.onPrimary
                    : context.theme.colorScheme.onSecondary,
              ),
              child: Text(
                'ValueChangeNotifier Value: ${value ? 'True' : 'False'}',
                style: TextStyle(
                  color: value
                      ? context.theme.colorScheme.onPrimary
                      : context.theme.colorScheme.onSecondary,
                ),
              ),
            );
          },
        ),
        Row(
          children: [
            Flexible(
              child: ElevatedButton(
                onPressed: () {
                  CustomAlertDialog.alertWithoutOptions(context, AlertType.info, 'Test', 'Test');
                },
                child: const Text(
                  'Alert Dialog Without Options',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Flexible(
              child: ElevatedButton(
                onPressed: () async {
                  testValueNotifier.value = await ConfirmationDialog.show(
                      context: context, title: 'Confirm?', content: 'Test');
                },
                child: const Text(
                  'Confirmation Dialog',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: state.localNotification
                  ? () async {
                      await NotificationServices().showInstantNotification(
                        'Test',
                        'Test',
                        payload: const NotificationPayload(
                          path: '/${SettingPage.routeName}',
                        ).toJson(),
                      );
                    }
                  : null,
              child: const Text('Push Notification Button'),
            );
          },
        ),
      ].map((e) => Padding(padding: const EdgeInsets.all(10), child: e)).toList()),
    );
  }
}
