import 'package:bloc_test/bloc_test.dart';
import 'package:depi_graduation_project/bloc/request_screen/request_screen_bloc.dart';
import 'package:depi_graduation_project/bloc/request_screen/request_screen_event.dart';
import 'package:depi_graduation_project/bloc/request_screen/request_screen_state.dart';
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
  late RequestScreenBloc requestScreenBloc;
  late MockRequestFirestoreService mockRequestService;
  late MockAuthenticationService mockAuthService;
  late MockUser mockUser;

  final testRequest = Request(
    requestId: 'req1',
    uid: 'test-uid',
    description: 'Test request',
    amountOfMoney: 10000.0,
    equityInReturn: '10%',
    whyAreYouRaising: 'Expansion',
    submittedAt: DateTime.now(),
  );

  setUp(() {
    mockRequestService = MockRequestFirestoreService();
    mockAuthService = MockAuthenticationService();
    mockUser = MockUser();

    when(() => mockAuthService.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('test-uid');
    registerFallbackValue(mockUser);

    requestScreenBloc = RequestScreenBloc(
      request: mockRequestService,
      auth: mockAuthService,
    );
  });

  tearDown(() {
    requestScreenBloc.close();
  });

  group('RequestScreenBloc', () {
    test('initial state is LoadingRequest', () {
      expect(requestScreenBloc.state, isA<LoadingRequest>());
    });

    blocTest<RequestScreenBloc, RequestScreenState>(
      'emits DisplayingRequest when LoadRequest succeeds',
      setUp: () {
        when(() => mockRequestService.getRequest(any(), any()))
            .thenAnswer((_) => Stream.value(testRequest));
      },
      build: () => requestScreenBloc,
      act: (bloc) => bloc.add(LoadRequest(request: testRequest)),
      expect: () => [
        isA<DisplayingRequest>(),
      ],
      verify: (_) {
        verify(() => mockRequestService.getRequest('test-uid', 'req1'))
            .called(1);
      },
    );

    blocTest<RequestScreenBloc, RequestScreenState>(
      'emits EditingRequest when EditRequestRequested is added',
      setUp: () {
        when(() => mockRequestService.getRequest(any(), any()))
            .thenAnswer((_) => Stream.value(testRequest));
      },
      build: () {
        // First load the request to initialize req field
        final bloc = RequestScreenBloc(
          request: mockRequestService,
          auth: mockAuthService,
        );
        bloc.add(LoadRequest(request: testRequest));
        return bloc;
      },
      wait: const Duration(milliseconds: 100), // Wait for LoadRequest to complete
      act: (bloc) => bloc.add(EditRequestRequested()),
      expect: () => [
        isA<EditingRequest>(),
      ],
    );

    blocTest<RequestScreenBloc, RequestScreenState>(
      'calls updateRequest and emits DisplayingRequest when EditRequestConfirmed is added',
      setUp: () {
        when(() => mockRequestService.updateRequest(
              requestId: any(named: 'requestId'),
              updatedData: any(named: 'updatedData'),
            )).thenAnswer((_) async => {});
        when(() => mockRequestService.getRequest(any(), any()))
            .thenAnswer((_) => Stream.value(testRequest));
      },
      build: () {
        // First load the request to initialize req field
        final bloc = RequestScreenBloc(
          request: mockRequestService,
          auth: mockAuthService,
        );
        bloc.add(LoadRequest(request: testRequest));
        return bloc;
      },
      wait: const Duration(milliseconds: 100), // Wait for LoadRequest to complete
      act: (bloc) => bloc.add(EditRequestConfirmed(
            description: 'Updated description',
            amountOfMoney: '15000',
            equityInReturn: '15%',
            whyAreYouRaising: 'New reason',
          )),
      expect: () => [
        isA<DisplayingRequest>(),
      ],
      verify: (_) {
        verify(() => mockRequestService.updateRequest(
              requestId: 'req1',
              updatedData: any(named: 'updatedData'),
            )).called(1);
      },
    );

    blocTest<RequestScreenBloc, RequestScreenState>(
      'emits DisplayingRequest when CancelButtonPressed is added',
      setUp: () {
        when(() => mockRequestService.getRequest(any(), any()))
            .thenAnswer((_) => Stream.value(testRequest));
      },
      build: () {
        // First load the request to initialize req field
        final bloc = RequestScreenBloc(
          request: mockRequestService,
          auth: mockAuthService,
        );
        bloc.add(LoadRequest(request: testRequest));
        return bloc;
      },
      wait: const Duration(milliseconds: 100), // Wait for LoadRequest to complete
      act: (bloc) => bloc.add(CancelButtonPressed()),
      expect: () => [
        isA<DisplayingRequest>(),
      ],
    );

    blocTest<RequestScreenBloc, RequestScreenState>(
      'calls deleteRequest and emits RequestDeleted when DeleteRequest succeeds',
      setUp: () {
        when(() => mockRequestService.deleteRequest(
              requestId: any(named: 'requestId'),
            )).thenAnswer((_) async => {});
        when(() => mockRequestService.getRequest(any(), any()))
            .thenAnswer((_) => Stream.value(testRequest));
      },
      build: () {
        // First load the request to initialize req field
        final bloc = RequestScreenBloc(
          request: mockRequestService,
          auth: mockAuthService,
        );
        bloc.add(LoadRequest(request: testRequest));
        return bloc;
      },
      wait: const Duration(milliseconds: 100), // Wait for LoadRequest to complete
      act: (bloc) => bloc.add(DeleteRequest()),
      expect: () => [
        isA<RequestDeleted>(),
      ],
      verify: (_) {
        verify(() => mockRequestService.deleteRequest(requestId: 'req1'))
            .called(1);
      },
    );

    blocTest<RequestScreenBloc, RequestScreenState>(
      'emits RequestError when DeleteRequest fails',
      setUp: () {
        when(() => mockRequestService.deleteRequest(
              requestId: any(named: 'requestId'),
            )).thenThrow(Exception('Delete failed'));
        when(() => mockRequestService.getRequest(any(), any()))
            .thenAnswer((_) => Stream.value(testRequest));
      },
      build: () => requestScreenBloc,
      seed: () => DisplayingRequest(request: testRequest),
      act: (bloc) => bloc.add(DeleteRequest()),
      expect: () => [
        isA<RequestError>(),
      ],
    );
  });
}

