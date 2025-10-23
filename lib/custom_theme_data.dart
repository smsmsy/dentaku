import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomThemeData {
  const CustomThemeData();

  ThemeData _base(Brightness brightness) {
    return ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: brightness,
      ),
    );
  }

  ThemeData get light => _base(Brightness.light);

  ThemeData get dark => _base(Brightness.dark);
}

class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit() : super(ThemeMode.system) {
    unawaited(_loadThemeMode());
  }

  Future<void> _loadThemeMode() async {
    final prefs = SharedPreferencesAsync();
    final savedMode = await prefs.getString('theme_mode');
    if (savedMode != null) {
      final themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.name == savedMode,
        orElse: () => ThemeMode.system,
      );
      emit(themeMode);
    }
  }

  @override
  Future<void> onChange(Change<ThemeMode> change) async {
    super.onChange(change);
    await _saveThemeMode(change.nextState);
  }

  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    final pref = SharedPreferencesAsync();
    await pref.setString('theme_mode', themeMode.name);
  }

  void changeThemeMode(ThemeMode themeMode) {
    emit(themeMode);
  }
}
