import 'package:dentaku/calculator_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ButtonItems {
  clearAll('AC'),
  clear('C'),
  percent('%'),
  divide('÷'),
  seven('7'),
  eight('8'),
  nine('9'),
  multiply('×'),
  four('4'),
  five('5'),
  six('6'),
  subtract('-'),
  one('1'),
  two('2'),
  three('3'),
  add('+'),
  toggleSign('±'),
  zero('0'),
  decimalPoint('.'),
  equals('=');

  const ButtonItems(this.label);
  final String label;

  void onPressed(BuildContext context) {
    final bloc = context.read<CalculatorBloc>();
    return switch (this) {
      clearAll => bloc.add(ClearAllEvent()),
      clear => bloc.add(ClearEvent()),
      percent => bloc.add(PercentEvent()),
      divide => bloc.add(OperatorEvent(OperatorType.divide)),
      seven => bloc.add(NumberEvent('7')),
      eight => bloc.add(NumberEvent('8')),
      nine => bloc.add(NumberEvent('9')),
      multiply => bloc.add(OperatorEvent(OperatorType.multiply)),
      four => bloc.add(NumberEvent('4')),
      five => bloc.add(NumberEvent('5')),
      six => bloc.add(NumberEvent('6')),
      subtract => bloc.add(OperatorEvent(OperatorType.subtract)),
      one => bloc.add(NumberEvent('1')),
      two => bloc.add(NumberEvent('2')),
      three => bloc.add(NumberEvent('3')),
      add => bloc.add(OperatorEvent(OperatorType.add)),
      toggleSign => bloc.add(ToggleSignEvent()),
      zero => bloc.add(NumberEvent('0')),
      decimalPoint => bloc.add(DecimalPointEvent()),
      equals => bloc.add(EqualsEvent()),
    };
  }
}
