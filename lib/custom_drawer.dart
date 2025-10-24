import 'package:dentaku/theme_mode_selector.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7,
      child: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.arrow_back_ios_new),
                title: const Text('閉じる'),
                onTap: () => Navigator.of(context).pop(),
              ),
              const Divider(),
              const ListTile(title: ThemeModeSelector()),
              const Spacer(),
              const Divider(),
              ListTile(
                title: const Text('ライセンスについて'),
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: 'dentaku',
                  applicationVersion: 'Version 1.0.0',
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
