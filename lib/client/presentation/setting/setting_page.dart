import 'package:budgetman/client/bloc/settings/settings_bloc.dart';
import 'package:budgetman/client/component/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetman/extension.dart';
import 'package:sizer/sizer.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  static const String pageName = 'Setting';
  static const String routeName = '/setting';

  @override
  State<SettingPage> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  final userNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        userNameController.text = state.name;
      },
      builder: (context, state) {
        return ListView(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: [50.w, 50.h].min.toDouble(),
                height: [50.w, 50.h].min.toDouble(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.settings,
                      size: 10.h,
                    ),
                    Text(
                      'Settings',
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomExpansionTile(
              context: context,
              leading: const Icon(Icons.settings),
              title: 'General',
              subtitle: 'username, theme, etc.',
              children: [
                CustomListTile(
                  leading: const Icon(Icons.person),
                  title: 'User Name',
                  subtitle: 'Change your user name',
                  trailing: TextField(
                    controller: userNameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your user name',
                    ),
                    maxLength: 40,
                    onChanged: (value) => context.bloc<SettingsBloc>()?.setName(value),
                  ),
                ),
                CustomListTile(
                  leading: const Icon(Icons.palette),
                  title: 'Theme',
                  subtitle: 'Change the theme of the app',
                  trailing: DropdownMenu(
                    initialSelection: state.theme,
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(
                        leadingIcon: Icon(Icons.brightness_5),
                        value: ThemeMode.light,
                        label: 'Light',
                      ),
                      DropdownMenuEntry(
                        leadingIcon: Icon(Icons.brightness_2),
                        value: ThemeMode.dark,
                        label: 'Dark',
                      ),
                      DropdownMenuEntry(
                        leadingIcon: Icon(Icons.brightness_auto),
                        value: ThemeMode.system,
                        label: 'System',
                      ),
                    ],
                    onSelected: (value) {
                      if (value == null) return;
                      context.bloc<SettingsBloc>()?.setTheme(value);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
