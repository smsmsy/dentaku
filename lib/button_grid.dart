import 'package:dentaku/button_items.dart';
import 'package:dentaku/custom_button.dart';
import 'package:flutter/material.dart';

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: ButtonItems.values.length,
      itemBuilder: (context, index) {
        return CustomButton(
          label: ButtonItems.values[index].label,
          backgroundColor: _mapIndexToBackgroundColor(index, context),
          onPressed: () => ButtonItems.values[index].onPressed(context),
        );
      },
    );
  }

  static Color _mapIndexToBackgroundColor(int index, BuildContext context) {
    final isLight = Theme.brightnessOf(context) == Brightness.light;
    if (index % 4 == 3) {
      return isLight
          ? const Color.fromARGB(255, 250, 200, 50)
          : const Color.fromARGB(255, 150, 100, 0);
    }
    if (index < 4 || index == 16 || index == 18) {
      return isLight
          ? const Color.fromARGB(255, 230, 230, 230)
          : const Color.fromARGB(255, 45, 45, 45);
    }
    return isLight
        ? const Color.fromARGB(255, 180, 180, 180)
        : const Color.fromARGB(255, 80, 80, 80);
  }
}
