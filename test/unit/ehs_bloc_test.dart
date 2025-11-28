import 'package:bloc_test/bloc_test.dart';
import 'package:depi_graduation_project/bloc/home/entrep_home_screen/ehs_bloc.dart';
import 'package:depi_graduation_project/bloc/home/entrep_home_screen/ehs_event.dart';
import 'package:depi_graduation_project/bloc/home/entrep_home_screen/ehs_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late EhsBloc ehsBloc;

  setUp(() {
    ehsBloc = EhsBloc();
  });

  tearDown(() {
    ehsBloc.close();
  });

  group('EhsBloc', () {
    test('initial state is LoadingHome', () {
      expect(ehsBloc.state, isA<LoadingHome>());
    });

    blocTest<EhsBloc, EhsState>(
      'emits DisplayHome with sectionIndex 0 when ShowInvestors is added',
      build: () => ehsBloc,
      act: (bloc) => bloc.add(ShowInvestors()),
      expect: () => [
        isA<DisplayHome>(),
      ],
      verify: (_) {
        final state = ehsBloc.state as DisplayHome;
        expect(state.displayedSectionIndex, equals(0));
      },
    );

    blocTest<EhsBloc, EhsState>(
      'emits DisplayHome with sectionIndex 1 when ShowRequests is added',
      build: () => ehsBloc,
      act: (bloc) => bloc.add(ShowRequests()),
      expect: () => [
        isA<DisplayHome>(),
      ],
      verify: (_) {
        final state = ehsBloc.state as DisplayHome;
        expect(state.displayedSectionIndex, equals(1));
      },
    );

    blocTest<EhsBloc, EhsState>(
      'automatically shows investors section on initialization',
      build: () => EhsBloc(),
      expect: () => [
        isA<DisplayHome>(),
      ],
      verify: (_) {
        final state = ehsBloc.state as DisplayHome;
        expect(state.displayedSectionIndex, equals(0));
      },
    );
  });
}

