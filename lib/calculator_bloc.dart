import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CalculatorEvent {}

class ClearAll extends CalculatorEvent {}

class Clear extends CalculatorEvent {}

class Percent extends CalculatorEvent {}

class Operator extends CalculatorEvent {
  Operator(this.operator);
  final String operator;
}

class ToggleSign extends CalculatorEvent {}

class DecimalPoint extends CalculatorEvent {}

class Equals extends CalculatorEvent {}

class Number extends CalculatorEvent {
  Number(this.number);
  final String number;
}

class CalculatorState {
  CalculatorState({
    required this.display,
    required this.currentInput,
    required this.previousInput,
    required this.operator,
    this.result,
  });
  final String display;
  final String currentInput;
  final String previousInput;
  final String operator;
  final double? result;

  CalculatorState copyWith({
    String? display,
    String? currentInput,
    String? previousInput,
    String? operator,
    double? result,
  }) {
    return CalculatorState(
      display: display ?? this.display,
      currentInput: currentInput ?? this.currentInput,
      previousInput: previousInput ?? this.previousInput,
      operator: operator ?? this.operator,
      result: result ?? this.result,
    );
  }
}

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc()
    : super(
        CalculatorState(
          display: '0',
          currentInput: '',
          previousInput: '',
          operator: '',
        ),
      ) {
    on<ClearAll>(_handleClearAll);
    on<Clear>(_handleClear);
    on<Percent>(_handlePercent);
    on<Operator>(_handleOperator);
    on<ToggleSign>(_handleToggleSign);
    on<DecimalPoint>(_handleDecimalPoint);
    on<Equals>(_handleEquals);
    on<Number>(_handleNumber);
  }

  void _handleClearAll(ClearAll event, Emitter<CalculatorState> emit) {
    emit(
      CalculatorState(
        display: '0',
        currentInput: '',
        previousInput: '',
        operator: '',
      ),
    );
  }

  void _handleClear(Clear event, Emitter<CalculatorState> emit) {
    emit(state.copyWith(currentInput: '', display: '0'));
  }

  void _handlePercent(Percent event, Emitter<CalculatorState> emit) {
    if (state.currentInput.isNotEmpty) {
      var value = double.parse(state.currentInput);
      value /= 100;
      emit(
        state.copyWith(
          display: value.toString(),
          currentInput: value.toString(),
        ),
      );
    }
  }

  void _handleOperator(Operator event, Emitter<CalculatorState> emit) {
    if (state.currentInput.isNotEmpty) {
      emit(
        state.copyWith(
          previousInput: state.currentInput,
          operator: event.operator,
          currentInput: '',
        ),
      );
    }
  }

  void _handleToggleSign(ToggleSign event, Emitter<CalculatorState> emit) {
    if (state.currentInput.isNotEmpty) {
      var value = double.parse(state.currentInput);
      value = -value;
      emit(
        state.copyWith(
          display: value.toString(),
          currentInput: value.toString(),
        ),
      );
    }
  }

  void _handleDecimalPoint(DecimalPoint event, Emitter<CalculatorState> emit) {
    if (!state.currentInput.contains('.')) {
      final newInput = '${state.currentInput}.';
      emit(state.copyWith(display: newInput, currentInput: newInput));
    }
  }

  void _handleEquals(Equals event, Emitter<CalculatorState> emit) {
    if (state.previousInput.isNotEmpty &&
        state.currentInput.isNotEmpty &&
        state.operator.isNotEmpty) {
      final a = double.parse(state.previousInput);
      final b = double.parse(state.currentInput);
      double result = 0;
      switch (state.operator) {
        case '+':
          result = a + b;
        case '-':
          result = a - b;
        case '×':
          result = a * b;
        case '÷':
          if (b != 0) result = a / b;
      }
      emit(
        state.copyWith(
          display: result.toString(),
          currentInput: result.toString(),
          previousInput: '',
          operator: '',
          result: result,
        ),
      );
    }
  }

  void _handleNumber(Number event, Emitter<CalculatorState> emit) {
    final newInput = state.currentInput + event.number;
    emit(
      state.copyWith(
        display: newInput,
        currentInput: newInput,
      ),
    );
  }
}
