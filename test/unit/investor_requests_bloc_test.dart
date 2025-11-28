import 'package:bloc_test/bloc_test.dart';
import 'package:depi_graduation_project/bloc/investor request/investor_requests_bloc.dart';
import 'package:depi_graduation_project/bloc/investor request/investor_requests_event.dart';
import 'package:depi_graduation_project/bloc/investor request/investor_requests_state.dart';
import 'package:depi_graduation_project/models/request.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockRequestFirestoreService extends Mock
    implements RequestFirestoreService {}

void main() {
  late InvestorRequestsBloc investorRequestsBloc;
  late MockRequestFirestoreService mockRequestService;

  setUp(() {
    mockRequestService = MockRequestFirestoreService();

    investorRequestsBloc = InvestorRequestsBloc(
      requestService: mockRequestService,
    );
  });

  tearDown(() {
    investorRequestsBloc.close();
  });

  group('InvestorRequestsBloc', () {
    test('initial state is LoadingInvestorRequests', () {
      expect(investorRequestsBloc.state, isA<LoadingInvestorRequests>());
    });

    blocTest<InvestorRequestsBloc, InvestorRequestsState>(
      'emits LoadingInvestorRequests then DisplayInvestorRequests when LoadInvestorRequests succeeds',
      setUp: () {
        final requests = [
          Request(
            requestId: 'req1',
            uid: 'uid1',
            description: 'Test request 1',
            amountOfMoney: 10000.0,
            equityInReturn: '10%',
            whyAreYouRaising: 'Expansion',
            submittedAt: DateTime.now(),
          ),
          Request(
            requestId: 'req2',
            uid: 'uid2',
            description: 'Test request 2',
            amountOfMoney: 20000.0,
            equityInReturn: '15%',
            whyAreYouRaising: 'Marketing',
            submittedAt: DateTime.now(),
          ),
        ];
        when(() => mockRequestService.getRequests())
            .thenAnswer((_) async => requests);
      },
      build: () => investorRequestsBloc,
      act: (bloc) => bloc.add(LoadInvestorRequests()),
      expect: () => [
        isA<LoadingInvestorRequests>(),
        isA<DisplayInvestorRequests>(),
      ],
      verify: (_) {
        verify(() => mockRequestService.getRequests()).called(1);
      },
    );

    blocTest<InvestorRequestsBloc, InvestorRequestsState>(
      'emits ErrorLoadingInvestorRequests when LoadInvestorRequests fails',
      setUp: () {
        when(() => mockRequestService.getRequests())
            .thenThrow(Exception('Error loading requests'));
      },
      build: () => investorRequestsBloc,
      act: (bloc) => bloc.add(LoadInvestorRequests()),
      expect: () => [
        isA<LoadingInvestorRequests>(),
        isA<ErrorLoadingInvestorRequests>(),
      ],
    );

    blocTest<InvestorRequestsBloc, InvestorRequestsState>(
      'automatically loads requests on initialization',
      setUp: () {
        when(() => mockRequestService.getRequests())
            .thenAnswer((_) async => []);
      },
      build: () => InvestorRequestsBloc(requestService: mockRequestService),
      expect: () => [
        isA<LoadingInvestorRequests>(),
        isA<DisplayInvestorRequests>(),
      ],
    );
  });
}

