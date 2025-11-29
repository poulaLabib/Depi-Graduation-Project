import 'package:bloc_test/bloc_test.dart';
import 'package:depi_graduation_project/bloc/auth/auth_bloc.dart';
import 'package:depi_graduation_project/bloc/auth/auth_event.dart';
import 'package:depi_graduation_project/bloc/auth/auth_state.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockFirebaseAuthService extends Mock implements AuthenticationService {}

class MockInvestorFirestoreService extends Mock
    implements InvestorFirestoreService {}

class MockEntrepreneurFirestoreService extends Mock
    implements EntrepreneurFirestoreService {}

class MockUser extends Mock implements User {}

void main() {
  late AuthBloc authBloc;
  late MockFirebaseAuthService mockAuthService;
  late MockInvestorFirestoreService mockInvestorService;
  late MockEntrepreneurFirestoreService mockEntrepreneurService;
  late MockUser mockUser;

  setUp(() {
    mockAuthService = MockFirebaseAuthService();
    mockInvestorService = MockInvestorFirestoreService();
    mockEntrepreneurService = MockEntrepreneurFirestoreService();
    mockUser = MockUser();

    when(() => mockUser.uid).thenReturn('test-uid');
    when(() => mockAuthService.currentUser).thenReturn(mockUser);

    authBloc = AuthBloc(
      auth: mockAuthService,
      investor: mockInvestorService,
      entrepreneur: mockEntrepreneurService,
    );
    registerFallbackValue(mockUser);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initial state is InitialState', () {
      expect(authBloc.state, isA<InitialState>());
    });

    blocTest<AuthBloc, AuthState>(
      'emits AuthLoading then AuthSuccessfull when SignUpButtonPressed succeeds for entrepreneur',
      setUp: () {
        when(
          () => mockAuthService.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => mockUser);
        when(
          () => mockEntrepreneurService.addEntrepreneur(
            uid: any(named: 'uid'),
            name: any(named: 'name'),
          ),
        ).thenAnswer((_) async => {});
      },
      build: () => authBloc,
      act:
          (bloc) => bloc.add(
            SignUpButtonPressed(
              fullName: 'Test Entrepreneur',
              email: 'test@example.com',
              password: 'password123',
              userType: 'entrepreneur',
            ),
          ),
      expect: () => [isA<AuthLoading>(), isA<AuthSuccessfull>()],
      verify: (_) {
        verify(
          () => mockAuthService.register(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).called(1);
        verify(
          () => mockEntrepreneurService.addEntrepreneur(
            uid: 'test-uid',
            name: 'Test Entrepreneur',
          ),
        ).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits AuthLoading then AuthSuccessfull when SignUpButtonPressed succeeds for investor',
      setUp: () {
        when(
          () => mockAuthService.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => mockUser);
        when(
          () => mockInvestorService.addInvestor(
            uid: any(named: 'uid'),
            name: any(named: 'name'),
          ),
        ).thenAnswer((_) async => {});
      },
      build: () => authBloc,
      act:
          (bloc) => bloc.add(
            SignUpButtonPressed(
              fullName: 'Test Investor',
              email: 'investor@example.com',
              password: 'password123',
              userType: 'investor',
            ),
          ),
      expect: () => [isA<AuthLoading>(), isA<AuthSuccessfull>()],
      verify: (_) {
        verify(
          () => mockAuthService.register(
            email: 'investor@example.com',
            password: 'password123',
          ),
        ).called(1);
        verify(
          () => mockInvestorService.addInvestor(
            uid: 'test-uid',
            name: 'Test Investor',
          ),
        ).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits AuthLoading then AuthUnsuccessfull when SignUpButtonPressed returns null user',
      setUp: () {
        when(
          () => mockAuthService.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => null);
      },
      build: () => authBloc,
      act:
          (bloc) => bloc.add(
            SignUpButtonPressed(
              fullName: 'Test User',
              email: 'test@example.com',
              password: 'password123',
              userType: 'entrepreneur',
            ),
          ),
      expect: () => [isA<AuthLoading>(), isA<AuthUnsuccessfull>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits AuthLoading then AuthError when SignUpButtonPressed throws exception',
      setUp: () {
        when(
          () => mockAuthService.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('Registration failed'));
      },
      build: () => authBloc,
      act:
          (bloc) => bloc.add(
            SignUpButtonPressed(
              fullName: 'Test User',
              email: 'test@example.com',
              password: 'password123',
              userType: 'entrepreneur',
            ),
          ),
      expect: () => [isA<AuthLoading>(), isA<AuthError>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits AuthLoading then AuthSuccessfull when SignInButtonPressed succeeds',
      setUp: () {
        when(
          () => mockAuthService.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => mockUser);
      },
      build: () => authBloc,
      act:
          (bloc) => bloc.add(
            SignInButtonPressed(
              email: 'test@example.com',
              password: 'password123',
            ),
          ),
      expect: () => [isA<AuthLoading>(), isA<AuthSuccessfull>()],
      verify: (_) {
        verify(
          () => mockAuthService.login(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits AuthLoading then AuthUnsuccessfull when SignInButtonPressed returns null user',
      setUp: () {
        when(
          () => mockAuthService.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => null);
      },
      build: () => authBloc,
      act:
          (bloc) => bloc.add(
            SignInButtonPressed(
              email: 'test@example.com',
              password: 'wrongpassword',
            ),
          ),
      expect: () => [isA<AuthLoading>(), isA<AuthUnsuccessfull>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits AuthLoading then AuthError when SignInButtonPressed throws exception',
      setUp: () {
        when(
          () => mockAuthService.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('Login failed'));
      },
      build: () => authBloc,
      act:
          (bloc) => bloc.add(
            SignInButtonPressed(
              email: 'test@example.com',
              password: 'password123',
            ),
          ),
      expect: () => [isA<AuthLoading>(), isA<AuthError>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits AuthLoading then AuthSuccessfull when LogoutButtonPressed succeeds',
      setUp: () {
        when(() => mockAuthService.logout()).thenAnswer((_) async => {});
      },
      build: () => authBloc,
      act: (bloc) => bloc.add(LogoutButtonPressed()),
      expect: () => [isA<AuthLoading>(), isA<AuthSuccessfull>()],
      verify: (_) {
        verify(() => mockAuthService.logout()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits AuthLoading then AuthError when LogoutButtonPressed throws exception',
      setUp: () {
        when(
          () => mockAuthService.logout(),
        ).thenThrow(Exception('Logout failed'));
      },
      build: () => authBloc,
      act: (bloc) => bloc.add(LogoutButtonPressed()),
      expect: () => [isA<AuthLoading>(), isA<AuthError>()],
    );
  });
}
