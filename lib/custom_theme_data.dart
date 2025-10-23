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
  ThemeModeCubit() : super(_loadInitialThemeMode()) {
    // 非同期で保存された値を読み込み、必要に応じてemit
    unawaited(_loadThemeMode());
  }

  static ThemeMode _loadInitialThemeMode() {
    // 同期的にSharedPreferencesから読み込む
    final prefs = SharedPreferences.getInstance();
    // ただし、getInstance()はFutureなので、同期的にできない。
    // 初期状態をsystemにし、非同期で更新するしかない。
    // または、初期状態をnullにし、読み込み後にemit。
    return ThemeMode.system;
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString('theme_mode');
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
