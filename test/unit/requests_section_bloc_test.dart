import 'package:bloc_test/bloc_test.dart';
import 'package:depi_graduation_project/bloc/home/entrep_home_screen/requests_section/requests_section_bloc.dart';
import 'package:depi_graduation_project/bloc/home/entrep_home_screen/requests_section/requests_section_event.dart';
import 'package:depi_graduation_project/bloc/home/entrep_home_screen/requests_section/requests_section_state.dart';
import 'package:depi_graduation_project/models/request.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockRequestFirestoreService extends Mock
    implements RequestFirestoreService {}

class MockAuthenticationService extends Mock implements AuthenticationService {}

class MockUser extends Mock implements User {}

void main() {
  late RequestsSectionBloc requestsSectionBloc;
  late MockRequestFirestoreService mockRequestService;
  late MockAuthenticationService mockAuthService;
  late MockUser mockUser;

  setUp(() {
    mockRequestService = MockRequestFirestoreService();
    mockAuthService = MockAuthenticationService();
    mockUser = MockUser();

    when(() => mockAuthService.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('test-uid');
    registerFallbackValue(mockUser);

    // Mock the stream that's called on initialization
    when(() => mockRequestService.getRequestsStream(uid: any(named: 'uid')))
        .thenAnswer((_) => Stream.value([]));

    requestsSectionBloc = RequestsSectionBloc(
      auth: mockAuthService,
      request: mockRequestService,
    );
  });

  tearDown(() {
    requestsSectionBloc.close();
  });

  group('RequestsSectionBloc', () {
    test('initial state is LoadingRequests', () {
      expect(requestsSectionBloc.state, isA<LoadingRequests>());
    });

    blocTest<RequestsSectionBloc, RequestsSectionState>(
      'emits DisplayRequests when LoadRequests succeeds with non-empty list',
      setUp: () {
        final requests = [
          Request(
            requestId: 'req1',
            uid: 'test-uid',
            description: 'Test request',
            amountOfMoney: 10000.0,
            equityInReturn: '10%',
            whyAreYouRaising: 'Expansion',
            submittedAt: DateTime.now(),
          ),
        ];
        when(() => mockRequestService.getRequestsStream(uid: any(named: 'uid')))
            .thenAnswer((_) => Stream.value(requests));
      },
      build: () => requestsSectionBloc,
      act: (bloc) => bloc.add(LoadRequests()),
      expect: () => [
        isA<DisplayRequests>(),
      ],
      verify: (_) {
        verify(() => mockRequestService.getRequestsStream(uid: 'test-uid'))
            .called(1);
      },
    );

    blocTest<RequestsSectionBloc, RequestsSectionState>(
      'emits NoRequests when LoadRequests succeeds with empty list',
      setUp: () {
        when(() => mockRequestService.getRequestsStream(uid: any(named: 'uid')))
            .thenAnswer((_) => Stream.value([]));
      },
      build: () => requestsSectionBloc,
      act: (bloc) => bloc.add(LoadRequests()),
      expect: () => [
        isA<NoRequests>(),
      ],
    );

    blocTest<RequestsSectionBloc, RequestsSectionState>(
      'emits NoRequests with showAddRequestDialog true when AddRequestButtonPressed is added',
      setUp: () {
        when(() => mockRequestService.getRequestsStream(uid: any(named: 'uid')))
            .thenAnswer((_) => Stream.value([]));
      },
      build: () => requestsSectionBloc,
      seed: () => NoRequests(),
      act: (bloc) => bloc.add(AddRequestButtonPressed()),
      expect: () => [
        predicate<NoRequests>((state) => state.showAddRequestDialog == true),
      ],
    );

    blocTest<RequestsSectionBloc, RequestsSectionState>(
      'calls addRequest when AddRequestConfirmed is added',
      setUp: () {
        when(() => mockRequestService.addRequest(
              uid: any(named: 'uid'),
              description: any(named: 'description'),
              amountOfMoney: any(named: 'amountOfMoney'),
              equityInReturn: any(named: 'equityInReturn'),
            )).thenAnswer((_) async => {});
        when(() => mockRequestService.getRequestsStream(uid: any(named: 'uid')))
            .thenAnswer((_) => Stream.value([]));
      },
      build: () => requestsSectionBloc,
      act: (bloc) => bloc.add(AddRequestConfirmed(
            description: 'Test request',
            amountOfMoney: 10000.0,
            equityInReturn: '10%',
            whyAreYouRaising: 'Expansion',
          )),
      verify: (_) {
        verify(() => mockRequestService.addRequest(
              uid: 'test-uid',
              description: 'Test request',
              amountOfMoney: 10000.0,
              equityInReturn: '10%',
            )).called(1);
      },
    );
  });
}

