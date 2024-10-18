import 'package:budgetman/client/bloc/settings/settings_bloc.dart';
import 'package:budgetman/client/component/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetman/server/component/extension.dart';
import 'package:sizer/sizer.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  static const String pageName = 'Setting';
  static const String routeName = '/setting';

  @override
  State<SettingPage> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> with SingleTickerProviderStateMixin {
  final userNameController = TextEditingController();
  final discordWebhookUriController = TextEditingController();
  final scrollController = ScrollController();
  AnimationController? controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          userNameController.text = state.username;
          discordWebhookUriController.text = state.discordWebhookUrl;
        },
        builder: (context, state) {
          if (!state.isInitialized) {
            return Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: [50.w, 50.h].min.toDouble(),
                height: [50.w, 50.h].min.toDouble(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Animate(
                      target: state.isInitialized ? 0 : 1,
                      onComplete: (controller) {
                        controller.repeat();
                      },
                      effects: const [
                        RotateEffect(
                          begin: 0,
                          end: 1,
                          curve: Curves.linear,
                          duration: Duration(seconds: 3),
                        ),
                      ],
                      child: const Icon(
                        Icons.settings,
                        size: 100,
                      ),
                    ),
                    Text(
                      'Initialize Settings',
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView(
            controller: scrollController,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Animate(
                        target: state.isInitialized ? 1 : 0,
                        onInit: (controller) {
                          this.controller = controller;
                          controller.stop();
                        },
                        effects: [
                          RotateEffect(
                            begin: 0,
                            end: 1,
                            curve: Curves.easeInOut,
                            duration: 1.0.seconds,
                          ),
                          ScaleEffect(
                            begin: const Offset(0.7, 0.7),
                            end: const Offset(1.1, 1.1),
                            curve: Curves.easeInOut,
                            duration: 0.7.seconds,
                          ),
                          ScaleEffect(
                            delay: const Duration(seconds: 1),
                            begin: const Offset(1.1, 1.1),
                            end: const Offset(1, 1),
                            curve: Curves.easeInOut,
                            duration: 0.3.seconds,
                          ),
                        ],
                        child: GestureDetector(
                          onTap: () async {
                            if (controller?.isAnimating ?? false) return;
                            await controller?.reverse();
                            controller?.forward();
                          },
                          child: const Icon(
                            Icons.settings,
                            size: 100,
                          ),
                        ),
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
              SizedBox(height: 2.h),
              CustomExpansionTile(
                context: context,
                leading: const Icon(Icons.notifications),
                title: 'Notification',
                subtitle: 'discord webhook, local notification, etc.',
                children: [
                  CustomListTile(
                    leading: const Icon(Icons.notifications),
                    title: 'Notification',
                    subtitle: 'discord webhook, local notification, etc.',
                    trailing: Switch(
                      value: state.notification,
                      onChanged: (value) => context.bloc<SettingsBloc>()?.setNotification(value),
                    ),
                  ),
                  CustomListTile(
                    leading: const Icon(Icons.web),
                    title: 'Discord Webhook',
                    subtitle: 'Modify the discord webhook',
                    trailing: Switch(
                      value: state.discordWebhook,
                      onChanged: state.enabledDiscordWebhook
                          ? (value) => context.bloc<SettingsBloc>()?.setDiscordWebhook(value)
                          : null,
                    ).animate(target: state.enabledDiscordWebhook ? 1 : 0).fade(
                          begin: 0,
                          end: 1,
                          curve: Curves.easeInOut,
                          duration: 0.5.seconds,
                        ),
                  )
                      .animate(
                        target: state.enabledDiscordWebhook ? 1 : 0,
                      )
                      .fade(
                        begin: 0.5,
                        end: 1,
                        curve: Curves.easeInOut,
                        duration: 0.5.seconds,
                      ),
                  CustomListTile(
                    leading: const Icon(Icons.web),
                    title: 'Webhook URL',
                    subtitle: 'Change the discord webhook URL',
                    trailing: TextField(
                      enabled: state.enabledDiscordWebhookUrl,
                      controller: discordWebhookUriController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the discord webhook URL',
                      ),
                      onChanged: state.enabledDiscordWebhookUrl
                          ? (value) => context.bloc<SettingsBloc>()?.setDiscordWebhookUri(value)
                          : null,
                    ).animate(target: state.enabledDiscordWebhookUrl ? 1 : 0).fade(
                          begin: 0,
                          end: 1,
                          curve: Curves.easeInOut,
                          duration: 0.5.seconds,
                        ),
                  ).animate(target: state.enabledDiscordWebhookUrl ? 1 : 0).fade(
                        begin: 0.5,
                        end: 1,
                        curve: Curves.easeInOut,
                        duration: 0.5.seconds,
                      ),
                  CustomListTile(
                    leading: const Icon(Icons.notifications_active),
                    title: 'Local Notification',
                    subtitle: 'Enable local notification',
                    trailing: Switch(
                      value: state.localNotification,
                      onChanged: state.enabledLocalNotification
                          ? (value) => context.bloc<SettingsBloc>()?.setLocalNotification(value)
                          : null,
                    ).animate(target: state.enabledLocalNotification ? 1 : 0).fade(
                          begin: 0,
                          end: 1,
                          curve: Curves.easeInOut,
                          duration: 0.5.seconds,
                        ),
                  ).animate(target: state.enabledLocalNotification ? 1 : 0).fade(
                        begin: 0.5,
                        end: 1,
                        curve: Curves.easeInOut,
                        duration: 0.5.seconds,
                      ),
                ],
              ),
            ],
          )
              .animate(
                target: state.isInitialized ? 1 : 0,
              )
              .fade(
                begin: 0,
                end: 1,
                curve: Curves.easeInOut,
                duration: 0.5.seconds,
              );
        },
      ),
    );
  }
}
