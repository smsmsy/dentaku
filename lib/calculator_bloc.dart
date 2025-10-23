import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum OperatorType { add, subtract, multiply, divide }

sealed class CalculatorEvent {}

final class ClearAll extends CalculatorEvent {}

final class Clear extends CalculatorEvent {}

final class Percent extends CalculatorEvent {}

final class Operator extends CalculatorEvent {
  Operator(this.type);
  final OperatorType type;
}

final class ToggleSign extends CalculatorEvent {}

final class DecimalPoint extends CalculatorEvent {}

final class Equals extends CalculatorEvent {}

final class Number extends CalculatorEvent {
  Number(this.number);
  final String number;
}

class CalculatorState extends Equatable {
  const CalculatorState({
    required this.display,
    required this.currentInput,
    required this.previousInput,
    this.operator,
    this.result,
  });
  final String display;
  final String currentInput;
  final String previousInput;
  final OperatorType? operator;
  final double? result;

  @override
  List<Object?> get props => [
    display,
    currentInput,
    previousInput,
    operator,
    result,
  ];

  CalculatorState copyWith({
    String? display,
    String? currentInput,
    String? previousInput,
    OperatorType? operator,
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
        const CalculatorState(
          display: '0',
          currentInput: '',
          previousInput: '',
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
      const CalculatorState(
        display: '0',
        currentInput: '',
        previousInput: '',
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
          operator: event.type,
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
        state.operator != null) {
      final a = double.parse(state.previousInput);
      final b = double.parse(state.currentInput);
      double result = 0;
      switch (state.operator!) {
        case OperatorType.add:
          result = a + b;
        case OperatorType.subtract:
          result = a - b;
        case OperatorType.multiply:
          result = a * b;
        case OperatorType.divide:
          if (b != 0) result = a / b;
      }
      emit(
        CalculatorState(
          display: result.toString(),
          currentInput: result.toString(),
          previousInput: '',
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
