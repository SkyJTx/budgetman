// header_widget.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:budgetman/client/presentation/setting/setting_page.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'สวัสดี ผู้ใช้',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            iconSize: 28,
            onPressed: () {
              context.go(SettingPage.routeName); 
            },
          ),
        ],
      ),
    );
  }
}
