import 'package:dentaku/calculator_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayArea extends StatelessWidget {
  const DisplayArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        alignment: Alignment.centerRight,
        child: BlocBuilder<CalculatorBloc, CalculatorState>(
          builder: (context, state) {
            return Text(
              state.display,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
              textAlign: TextAlign.right,
            );
          },
        ),
      ),
    );
  }
}
