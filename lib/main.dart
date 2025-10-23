import 'package:dentaku/button_grid.dart';
import 'package:dentaku/calculator_bloc.dart';
import 'package:dentaku/custom_drawer.dart';
import 'package:dentaku/custom_theme_data.dart';
import 'package:dentaku/display_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialThemeMode = await ThemeModeCubit.loadThemeMode();
  runApp(MyApp(initialThemeMode: initialThemeMode));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.initialThemeMode, super.key});
  final ThemeMode initialThemeMode;

  @override
  Widget build(BuildContext context) {
    const themeData = CustomThemeData();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CalculatorBloc()),
        BlocProvider(
          create: (context) => ThemeModeCubit(initialValue: initialThemeMode),
        ),
      ],
      child: BlocBuilder<ThemeModeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: themeData.light,
            darkTheme: themeData.dark,
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const CustomDrawer(),
      body: const Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Column(
            children: <Widget>[
              DisplayArea(),
              ButtonGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
