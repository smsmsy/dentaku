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
      clearAll => bloc.add(ClearAll()),
      clear => bloc.add(Clear()),
      percent => bloc.add(Percent()),
      divide => bloc.add(Operator(OperatorType.divide)),
      seven => bloc.add(Number('7')),
      eight => bloc.add(Number('8')),
      nine => bloc.add(Number('9')),
      multiply => bloc.add(Operator(OperatorType.multiply)),
      four => bloc.add(Number('4')),
      five => bloc.add(Number('5')),
      six => bloc.add(Number('6')),
      subtract => bloc.add(Operator(OperatorType.subtract)),
      one => bloc.add(Number('1')),
      two => bloc.add(Number('2')),
      three => bloc.add(Number('3')),
      add => bloc.add(Operator(OperatorType.add)),
      toggleSign => bloc.add(ToggleSign()),
      zero => bloc.add(Number('0')),
      decimalPoint => bloc.add(DecimalPoint()),
      equals => bloc.add(Equals()),
    };
  }
}
