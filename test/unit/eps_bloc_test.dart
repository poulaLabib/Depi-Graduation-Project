import 'package:bloc_test/bloc_test.dart';
import 'package:depi_graduation_project/bloc/entrepreneur_profile_screen/eps_bloc.dart';
import 'package:depi_graduation_project/bloc/entrepreneur_profile_screen/eps_event.dart';
import 'package:depi_graduation_project/bloc/entrepreneur_profile_screen/eps_state.dart';
import 'package:depi_graduation_project/models/entrepreneur.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockEntrepreneurFirestoreService extends Mock
    implements EntrepreneurFirestoreService {}

class MockAuthenticationService extends Mock implements AuthenticationService {}

class MockUser extends Mock implements User {}

void main() {
  late EpsBloc epsBloc;
  late MockEntrepreneurFirestoreService mockEntrepreneurService;
  late MockAuthenticationService mockAuthService;
  late MockUser mockUser;

  final testEntrepreneur = Entrepreneur(
    uid: 'test-uid',
    name: 'Test Entrepreneur',
    about: 'Test about',
    phoneNumber: '1234567890',
    experience: '5 years',
    skills: ['Flutter', 'Dart'],
    role: 'Founder',
    profileImageUrl: '',
    idImageUrl: '',
  );

  setUp(() {
    mockEntrepreneurService = MockEntrepreneurFirestoreService();
    mockAuthService = MockAuthenticationService();
    mockUser = MockUser();

    when(() => mockAuthService.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('test-uid');
    registerFallbackValue(mockUser);

    epsBloc = EpsBloc(
      entrepreneur: mockEntrepreneurService,
      auth: mockAuthService,
    );
  });

  tearDown(() {
    epsBloc.close();
  });

  group('EpsBloc', () {
    test('initial state is LoadingProfile', () {
      expect(epsBloc.state, isA<LoadingProfile>());
    });

    blocTest<EpsBloc, EpsState>(
      'emits DisplayInfo when LoadProfileData succeeds',
      setUp: () {
        when(() => mockEntrepreneurService.getEntrepreneurStream(
              uid: any(named: 'uid'),
            )).thenAnswer((_) => Stream.value(testEntrepreneur));
      },
      build: () => epsBloc,
      act: (bloc) => bloc.add(LoadProfileData()),
      expect: () => [
        isA<DisplayInfo>(),
      ],
      verify: (_) {
        verify(() => mockEntrepreneurService.getEntrepreneurStream(
              uid: 'test-uid',
            )).called(1);
      },
    );

    blocTest<EpsBloc, EpsState>(
      'emits EditInfo when EditButtonPressed is added',
      setUp: () {
        when(() => mockEntrepreneurService.getEntrepreneur(uid: any(named: 'uid')))
            .thenAnswer((_) async => testEntrepreneur);
        when(() => mockEntrepreneurService.getEntrepreneurStream(
              uid: any(named: 'uid'),
            )).thenAnswer((_) => Stream.value(testEntrepreneur));
      },
      build: () => epsBloc,
      seed: () => DisplayInfo(entrepreneur: testEntrepreneur),
      act: (bloc) => bloc.add(EditButtonPressed()),
      expect: () => [
        isA<EditInfo>(),
      ],
    );

    blocTest<EpsBloc, EpsState>(
      'calls updateEntrepreneur and emits DisplayInfo when SaveButtonPressed is added',
      setUp: () {
        when(() => mockEntrepreneurService.getEntrepreneur(uid: any(named: 'uid')))
            .thenAnswer((_) async => testEntrepreneur);
        when(() => mockEntrepreneurService.updateEntrepreneur(
              uid: any(named: 'uid'),
              updatedData: any(named: 'updatedData'),
            )).thenAnswer((_) async => {});
        when(() => mockEntrepreneurService.getEntrepreneurStream(
              uid: any(named: 'uid'),
            )).thenAnswer((_) => Stream.value(testEntrepreneur));
      },
      build: () => epsBloc,
      seed: () => EditInfo(entrepreneur: testEntrepreneur),
      act: (bloc) => bloc.add(SaveButtonPressed(
            name: 'Updated Name',
            about: 'Updated about',
            phoneNumber: '0987654321',
            experience: '6 years',
            skills: ['Flutter', 'Dart', 'Firebase'],
            role: 'CEO',
          )),
      expect: () => [
        isA<DisplayInfo>(),
      ],
      verify: (_) {
        verify(() => mockEntrepreneurService.updateEntrepreneur(
              uid: 'test-uid',
              updatedData: any(named: 'updatedData'),
            )).called(1);
      },
    );

    blocTest<EpsBloc, EpsState>(
      'emits DisplayInfo when CancelButtonPressed is added',
      setUp: () {
        when(() => mockEntrepreneurService.getEntrepreneur(uid: any(named: 'uid')))
            .thenAnswer((_) async => testEntrepreneur);
        when(() => mockEntrepreneurService.getEntrepreneurStream(
              uid: any(named: 'uid'),
            )).thenAnswer((_) => Stream.value(testEntrepreneur));
      },
      build: () => epsBloc,
      seed: () => EditInfo(entrepreneur: testEntrepreneur),
      act: (bloc) => bloc.add(CancelButtonPressed()),
      expect: () => [
        isA<DisplayInfo>(),
      ],
    );

    blocTest<EpsBloc, EpsState>(
      'shows available skills when AddSkillButtonPressed is added',
      setUp: () {
        when(() => mockEntrepreneurService.getEntrepreneurStream(
              uid: any(named: 'uid'),
            )).thenAnswer((_) => Stream.value(testEntrepreneur));
      },
      build: () => epsBloc,
      seed: () => EditInfo(
        entrepreneur: testEntrepreneur,
        tempSkills: [],
      ),
      act: (bloc) => bloc.add(AddSkillButtonPressed()),
      expect: () => [
        predicate<EditInfo>((state) => state.showSkills == true),
      ],
    );

    blocTest<EpsBloc, EpsState>(
      'adds temp skill when AddTempSkill is added',
      setUp: () {
        when(() => mockEntrepreneurService.getEntrepreneurStream(
              uid: any(named: 'uid'),
            )).thenAnswer((_) => Stream.value(testEntrepreneur));
      },
      build: () => epsBloc,
      seed: () => EditInfo(
        entrepreneur: testEntrepreneur,
        tempSkills: [],
        showSkills: true,
        availableSkills: ['React', 'Node.js'],
      ),
      act: (bloc) => bloc.add(AddTempSkill(skill: 'React')),
      expect: () => [
        predicate<EditInfo>((state) =>
            state.tempSkills.contains('React') &&
            state.showSkills == false),
      ],
    );

    blocTest<EpsBloc, EpsState>(
      'removes temp skill when RemoveTempSkill is added',
      setUp: () {
        when(() => mockEntrepreneurService.getEntrepreneurStream(
              uid: any(named: 'uid'),
            )).thenAnswer((_) => Stream.value(testEntrepreneur));
      },
      build: () => epsBloc,
      seed: () => EditInfo(
        entrepreneur: testEntrepreneur,
        tempSkills: ['React'],
      ),
      act: (bloc) => bloc.add(RemoveTempSkill(skill: 'React')),
      expect: () => [
        predicate<EditInfo>((state) => !state.tempSkills.contains('React')),
      ],
    );
  });
}

