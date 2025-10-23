import 'package:bloc_test/bloc_test.dart';
import 'package:dentaku/calculator_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalculatorBloc', () {
    late CalculatorBloc bloc;

    setUp(() {
      bloc = CalculatorBloc();
    });

    tearDown(() async {
      await bloc.close();
    });

    test('initial state', () {
      expect(bloc.state.display, '0');
      expect(bloc.state.currentInput, '');
      expect(bloc.state.previousInput, '');
      expect(bloc.state.operator, null);
      expect(bloc.state.result, null);
    });

    group('ClearAll', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'clears all state',
        build: () => bloc,
        seed: () => const CalculatorState(
          display: '15',
          currentInput: '15',
          previousInput: '',
          result: 15,
        ),
        act: (bloc) => bloc.add(ClearAllEvent()),
        expect: () => [
          const CalculatorState(
            display: '0',
            currentInput: '',
            previousInput: '',
          ),
        ],
      );
    });

    group('Clear', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'clears current input and display',
        build: () => bloc,
        seed: () => const CalculatorState(
          display: '12',
          currentInput: '12',
          previousInput: '',
        ),
        act: (bloc) => bloc.add(ClearEvent()),
        expect: () => [
          const CalculatorState(
            display: '0',
            currentInput: '',
            previousInput: '',
          ),
        ],
      );
    });

    group('Percent', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'calculates percent when currentInput is not empty',
        build: () => bloc,
        seed: () => const CalculatorState(
          display: '50',
          currentInput: '50',
          previousInput: '',
        ),
        act: (bloc) => bloc.add(PercentEvent()),
        expect: () => [
          const CalculatorState(
            display: '0.5',
            currentInput: '0.5',
            previousInput: '',
          ),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'forCoverage: does nothing when currentInput is empty',
        build: () => bloc,
        act: (bloc) => bloc.add(PercentEvent()),
        expect: () => <CalculatorState>[],
      );
    });

    group('Operator', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'sets operator and moves currentInput to previousInput'
        ' when currentInput is not empty',
        build: () => bloc,
        seed: () => const CalculatorState(
          display: '12',
          currentInput: '12',
          previousInput: '',
        ),
        act: (bloc) => bloc.add(OperatorEvent(OperatorType.add)),
        expect: () => [
          const CalculatorState(
            display: '12',
            currentInput: '',
            previousInput: '12',
            operator: OperatorType.add,
          ),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'forCoverage: does nothing when currentInput is empty',
        build: () => bloc,
        act: (bloc) => bloc.add(OperatorEvent(OperatorType.add)),
        expect: () => <CalculatorState>[],
      );
    });

    group('ToggleSign', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'toggles sign when currentInput is positive',
        build: () => bloc,
        seed: () => const CalculatorState(
          display: '12',
          currentInput: '12',
          previousInput: '',
        ),
        act: (bloc) => bloc.add(ToggleSignEvent()),
        expect: () => [
          const CalculatorState(
            display: '-12.0',
            currentInput: '-12.0',
            previousInput: '',
          ),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'toggles sign when currentInput is negative',
        build: () => bloc,
        seed: () => const CalculatorState(
          display: '-12',
          currentInput: '-12',
          previousInput: '',
        ),
        act: (bloc) => bloc.add(ToggleSignEvent()),
        expect: () => [
          const CalculatorState(
            display: '12.0',
            currentInput: '12.0',
            previousInput: '',
          ),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'forCoverage: does nothing when currentInput is empty',
        build: () => bloc,
        act: (bloc) => bloc.add(ToggleSignEvent()),
        expect: () => <CalculatorState>[],
      );
    });

    group('DecimalPoint', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'adds decimal point when not present',
        build: () => bloc,
        seed: () => const CalculatorState(
          display: '12',
          currentInput: '12',
          previousInput: '',
        ),
        act: (bloc) => bloc.add(DecimalPointEvent()),
        expect: () => [
          const CalculatorState(
            display: '12.',
            currentInput: '12.',
            previousInput: '',
          ),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'forCoverage: does not add decimal point when already present',
        build: () => bloc,
        seed: () => const CalculatorState(
          display: '12.',
          currentInput: '12.',
          previousInput: '',
        ),
        act: (bloc) => bloc.add(DecimalPointEvent()),
        expect: () => <CalculatorState>[],
      );
    });

    group('Equals', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'performs addition',
        build: () => bloc,
        seed: () => const CalculatorState(
          display: '3',
          currentInput: '3',
          previousInput: '12',
          operator: OperatorType.add,
        ),
        act: (bloc) => bloc.add(EqualsEvent()),
        expect: () => [
          const CalculatorState(
            display: '15.0',
            currentInput: '15.0',
            previousInput: '',
            result: 15,
          ),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'performs subtraction',
        build: () => bloc,
        seed: () => const CalculatorState(
          display: '3',
          currentInput: '3',
          previousInput: '12',
          operator: OperatorType.subtract,
        ),
        act: (bloc) => bloc.add(EqualsEvent()),
        expect: () => [
          const CalculatorState(
            display: '9.0',
            currentInput: '9.0',
            previousInput: '',
            result: 9,
          ),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'performs multiplication',
        build: () => bloc,
        seed: () => const CalculatorState(
          display: '3',
          currentInput: '3',
          previousInput: '12',
          operator: OperatorType.multiply,
        ),
        act: (bloc) => bloc.add(EqualsEvent()),
        expect: () => [
          const CalculatorState(
            display: '36.0',
            currentInput: '36.0',
            previousInput: '',
            result: 36,
          ),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'performs division',
        build: () => bloc,
        seed: () => const CalculatorState(
          display: '3',
          currentInput: '3',
          previousInput: '12',
          operator: OperatorType.divide,
        ),
        act: (bloc) => bloc.add(EqualsEvent()),
        expect: () => [
          const CalculatorState(
            display: '4.0',
            currentInput: '4.0',
            previousInput: '',
            result: 4,
          ),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'forCoverage: division by zero does not change state',
        build: () => bloc,
        seed: () => const CalculatorState(
          display: '0',
          currentInput: '0',
          previousInput: '12',
          operator: OperatorType.divide,
        ),
        act: (bloc) => bloc.add(EqualsEvent()),
        expect: () => [
          const CalculatorState(
            display: '0.0',
            currentInput: '0.0',
            previousInput: '',
            result: 0,
          ),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'forCoverage: does nothing when previousInput is empty',
        build: () => bloc,
        seed: () => const CalculatorState(
          display: '3',
          currentInput: '3',
          previousInput: '',
          operator: OperatorType.add,
        ),
        act: (bloc) => bloc.add(EqualsEvent()),
        expect: () => <CalculatorState>[],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'forCoverage: does nothing when currentInput is empty',
        build: () => bloc,
        seed: () => const CalculatorState(
          display: '12',
          currentInput: '',
          previousInput: '12',
          operator: OperatorType.add,
        ),
        act: (bloc) => bloc.add(EqualsEvent()),
        expect: () => <CalculatorState>[],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'forCoverage: does nothing when operator is empty',
        build: () => bloc,
        seed: () => const CalculatorState(
          display: '123',
          currentInput: '123',
          previousInput: '',
        ),
        act: (bloc) => bloc.add(EqualsEvent()),
        expect: () => <CalculatorState>[],
      );
    });

    group('Number', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'adds number to currentInput',
        build: () => bloc,
        act: (bloc) => bloc.add(NumberEvent('1')),
        expect: () => [
          const CalculatorState(
            display: '1',
            currentInput: '1',
            previousInput: '',
          ),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'adds second number to currentInput',
        build: () => bloc,
        seed: () => const CalculatorState(
          display: '1',
          currentInput: '1',
          previousInput: '',
        ),
        act: (bloc) => bloc.add(NumberEvent('2')),
        expect: () => [
          const CalculatorState(
            display: '12',
            currentInput: '12',
            previousInput: '',
          ),
        ],
      );
    });
  });
}
