import 'dart:collection';

import 'package:dentaku/custom_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef ThemeModeEntry = DropdownMenuEntry<ThemeMode>;

extension _ThemeMode on ThemeMode {
  String get label => switch (this) {
    ThemeMode.system => '自動',
    ThemeMode.light => 'ライト',
    ThemeMode.dark => 'ダーク',
  };

  static final List<ThemeModeEntry> entries =
      UnmodifiableListView<ThemeModeEntry>(
        ThemeMode.values.map(
          (e) => ThemeModeEntry(
            value: e,
            label: e.label,
          ),
        ),
      );
}

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeMode>(
      builder: (context, state) {
        return DropdownMenu(
          label: const Text('見た目'),
          dropdownMenuEntries: _ThemeMode.entries,
          initialSelection: state,
          onSelected: (value) {
            if (value == null) return;
            context.read<ThemeModeCubit>().changeThemeMode(value);
          },
        );
      },
    );
  }
}
