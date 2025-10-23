import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.label,
    required this.backgroundColor,
    required this.onPressed,
    super.key,
  });

  final String label;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        FilledButton.tonal(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(40),
            backgroundColor: backgroundColor,
          ),
          child: const SizedBox.shrink(),
        ),
        IgnorePointer(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }
}
