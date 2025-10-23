import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum OperatorType { add, subtract, multiply, divide }

sealed class CalculatorEvent {}

final class ClearAllEvent extends CalculatorEvent {}

final class ClearEvent extends CalculatorEvent {}

final class PercentEvent extends CalculatorEvent {}

final class OperatorEvent extends CalculatorEvent {
  OperatorEvent(this.type);
  final OperatorType type;
}

final class ToggleSignEvent extends CalculatorEvent {}

final class DecimalPointEvent extends CalculatorEvent {}

final class EqualsEvent extends CalculatorEvent {}

final class NumberEvent extends CalculatorEvent {
  NumberEvent(this.number);
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
    on<ClearAllEvent>(_handleClearAll);
    on<ClearEvent>(_handleClear);
    on<PercentEvent>(_handlePercent);
    on<OperatorEvent>(_handleOperator);
    on<ToggleSignEvent>(_handleToggleSign);
    on<DecimalPointEvent>(_handleDecimalPoint);
    on<EqualsEvent>(_handleEquals);
    on<NumberEvent>(_handleNumber);
  }

  String _formatResult(double result) {
    // 浮動小数点誤差を避けるために、適当に丸める
    final rounded = (result * 10000000000).round() / 10000000000;
    if (rounded == rounded.roundToDouble()) {
      return rounded.round().toString();
    } else {
      return rounded.toString();
    }
  }

  void _handleClearAll(ClearAllEvent event, Emitter<CalculatorState> emit) {
    emit(
      const CalculatorState(
        display: '0',
        currentInput: '',
        previousInput: '',
      ),
    );
  }

  void _handleClear(ClearEvent event, Emitter<CalculatorState> emit) {
    emit(state.copyWith(currentInput: '', display: '0'));
  }

  void _handlePercent(PercentEvent event, Emitter<CalculatorState> emit) {
    if (state.currentInput.isNotEmpty) {
      var value = double.parse(state.currentInput);
      value /= 100;
      final formatted = _formatResult(value);
      emit(
        state.copyWith(
          display: formatted,
          currentInput: formatted,
        ),
      );
    }
  }

  void _handleOperator(OperatorEvent event, Emitter<CalculatorState> emit) {
    if (state.previousInput.isNotEmpty &&
        state.currentInput.isNotEmpty &&
        state.operator != null) {
      // 連続演算子: まず計算を実行
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
      final formatted = _formatResult(result);
      emit(
        state.copyWith(
          display: formatted,
          currentInput: '',
          previousInput: formatted,
          operator: event.type,
        ),
      );
    } else if (state.currentInput.isNotEmpty) {
      emit(
        state.copyWith(
          previousInput: state.currentInput,
          operator: event.type,
          currentInput: '',
        ),
      );
    }
  }

  void _handleToggleSign(ToggleSignEvent event, Emitter<CalculatorState> emit) {
    if (state.currentInput.isNotEmpty) {
      var value = double.parse(state.currentInput);
      value = -value;
      final formatted = _formatResult(value);
      emit(
        state.copyWith(
          display: formatted,
          currentInput: formatted,
        ),
      );
    }
  }

  void _handleDecimalPoint(
    DecimalPointEvent event,
    Emitter<CalculatorState> emit,
  ) {
    if (!state.currentInput.contains('.')) {
      final newInput = state.currentInput.isEmpty
          ? '0.'
          : '${state.currentInput}.';
      emit(state.copyWith(display: newInput, currentInput: newInput));
    }
  }

  void _handleEquals(EqualsEvent event, Emitter<CalculatorState> emit) {
    if (state.result != null && state.operator != null) {
      // 繰り返し = の場合
      final a = double.parse(state.currentInput);
      final b = double.parse(state.previousInput);
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
      final formatted = _formatResult(result);
      emit(
        CalculatorState(
          display: formatted,
          currentInput: formatted,
          previousInput: state.currentInput,
          operator: state.operator,
          result: result,
        ),
      );
    } else if (state.previousInput.isNotEmpty &&
        state.currentInput.isNotEmpty &&
        state.operator != null) {
      // 通常計算
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
      final formatted = _formatResult(result);
      emit(
        CalculatorState(
          display: formatted,
          currentInput: formatted,
          previousInput: '',
          result: result,
        ),
      );
    }
  }

  void _handleNumber(NumberEvent event, Emitter<CalculatorState> emit) {
    String newInput;
    if (state.currentInput == '0') {
      if (event.number == '0') {
        newInput = '0';
      } else {
        newInput = event.number;
      }
    } else {
      newInput = state.currentInput + event.number;
    }
    emit(
      state.copyWith(
        display: newInput,
        currentInput: newInput,
      ),
    );
  }
}
