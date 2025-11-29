import 'package:bloc_test/bloc_test.dart';
import 'package:depi_graduation_project/bloc/investor_profile_screen/ips_bloc.dart';
import 'package:depi_graduation_project/bloc/investor_profile_screen/ips_event.dart';
import 'package:depi_graduation_project/bloc/investor_profile_screen/ips_state.dart';
import 'package:depi_graduation_project/models/investor.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockInvestorFirestoreService extends Mock
    implements InvestorFirestoreService {}

class MockAuthenticationService extends Mock implements AuthenticationService {}

class MockUser extends Mock implements User {}

void main() {
  late IpsBloc ipsBloc;
  late MockInvestorFirestoreService mockInvestorService;
  late MockAuthenticationService mockAuthService;
  late MockUser mockUser;

  final testInvestor = Investor(
    uid: 'test-uid',
    name: 'Test Investor',
    about: 'Test about',
    phoneNumber: '1234567890',
    experience: '10 years',
    skills: ['Finance', 'Marketing'],
    investmentCapacity: 100000,
    preferredIndustries: ['Tech', 'Healthcare'],
    investorType: 'Angel Investor',
    nationalIdUrl: '',
    photoUrl: '',
  );

  setUp(() {
    mockInvestorService = MockInvestorFirestoreService();
    mockAuthService = MockAuthenticationService();
    mockUser = MockUser();

    when(() => mockAuthService.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('test-uid');
    registerFallbackValue(mockUser);

    // Mock the stream that's called on initialization
    when(() => mockInvestorService.getInvestorStream(uid: any(named: 'uid')))
        .thenAnswer((_) => Stream.value(testInvestor));

    ipsBloc = IpsBloc(
      investorService: mockInvestorService,
      auth: mockAuthService,
    );
  });

  tearDown(() {
    ipsBloc.close();
  });

  group('IpsBloc', () {
    test('initial state is LoadingInvestorProfile', () {
      expect(ipsBloc.state, isA<LoadingInvestorProfile>());
    });

    blocTest<IpsBloc, IpsState>(
      'emits DisplayInvestorInfo when LoadInvestorData succeeds',
      setUp: () {
        when(() => mockInvestorService.getInvestorStream(uid: any(named: 'uid')))
            .thenAnswer((_) => Stream.value(testInvestor));
      },
      build: () => ipsBloc,
      act: (bloc) => bloc.add(LoadInvestorData()),
      expect: () => [
        isA<DisplayInvestorInfo>(),
      ],
      verify: (_) {
        verify(() => mockInvestorService.getInvestorStream(uid: 'test-uid'))
            .called(1);
      },
    );

    blocTest<IpsBloc, IpsState>(
      'emits EditInvestorInfo when EditInvestorButtonPressed is added',
      setUp: () {
        when(() => mockInvestorService.getInvestor(uid: any(named: 'uid')))
            .thenAnswer((_) async => testInvestor);
        when(() => mockInvestorService.getInvestorStream(uid: any(named: 'uid')))
            .thenAnswer((_) => Stream.value(testInvestor));
      },
      build: () => ipsBloc,
      seed: () => DisplayInvestorInfo(investor: testInvestor),
      act: (bloc) => bloc.add(EditInvestorButtonPressed()),
      expect: () => [
        isA<EditInvestorInfo>(),
      ],
    );

    blocTest<IpsBloc, IpsState>(
      'calls updateInvestor and emits DisplayInvestorInfo when SaveInvestorButtonPressed is added',
      setUp: () {
        when(() => mockInvestorService.getInvestor(uid: any(named: 'uid')))
            .thenAnswer((_) async => testInvestor);
        when(() => mockInvestorService.updateInvestor(
              uid: any(named: 'uid'),
              updatedData: any(named: 'updatedData'),
            )).thenAnswer((_) async => {});
        when(() => mockInvestorService.getInvestorStream(uid: any(named: 'uid')))
            .thenAnswer((_) => Stream.value(testInvestor));
      },
      build: () => ipsBloc,
      seed: () => EditInvestorInfo(investor: testInvestor),
      act: (bloc) => bloc.add(SaveInvestorButtonPressed(
            name: 'Updated Name',
            investorType: 'Venture Capitalist',
            about: 'Updated about',
            phoneNumber: '0987654321',
            experience: '12 years',
            skills: ['Finance', 'Marketing', 'AI'],
            preferredIndustries: ['Tech', 'Healthcare', 'AI'],
            investmentCapacity: 200000,
          )),
      expect: () => [
        isA<DisplayInvestorInfo>(),
      ],
      verify: (_) {
        verify(() => mockInvestorService.updateInvestor(
              uid: 'test-uid',
              updatedData: any(named: 'updatedData'),
            )).called(1);
      },
    );

    blocTest<IpsBloc, IpsState>(
      'emits DisplayInvestorInfo when CancelInvestorButtonPressed is added',
      setUp: () {
        when(() => mockInvestorService.getInvestor(uid: any(named: 'uid')))
            .thenAnswer((_) async => testInvestor);
        when(() => mockInvestorService.getInvestorStream(uid: any(named: 'uid')))
            .thenAnswer((_) => Stream.value(testInvestor));
      },
      build: () => ipsBloc,
      seed: () => EditInvestorInfo(investor: testInvestor),
      act: (bloc) => bloc.add(CancelInvestorButtonPressed()),
      expect: () => [
        isA<DisplayInvestorInfo>(),
      ],
    );

    blocTest<IpsBloc, IpsState>(
      'shows available skills when AddTempSkillButtonPressed is added',
      setUp: () {
        when(() => mockInvestorService.getInvestorStream(uid: any(named: 'uid')))
            .thenAnswer((_) => Stream.value(testInvestor));
      },
      build: () => ipsBloc,
      seed: () => EditInvestorInfo(
        investor: testInvestor,
        tempSkills: [],
      ),
      act: (bloc) => bloc.add(AddTempSkillButtonPressed()),
      expect: () => [
        predicate<EditInvestorInfo>((state) => state.showSkills == true),
      ],
    );

    blocTest<IpsBloc, IpsState>(
      'adds temp skill when AddTempSkillInvestor is added',
      setUp: () {
        when(() => mockInvestorService.getInvestorStream(uid: any(named: 'uid')))
            .thenAnswer((_) => Stream.value(testInvestor));
      },
      build: () => ipsBloc,
      seed: () => EditInvestorInfo(
        investor: testInvestor,
        tempSkills: [],
        showSkills: true,
        availableSkills: ['React', 'Node.js'],
      ),
      act: (bloc) => bloc.add(AddTempSkillInvestor(skill: 'React')),
      expect: () => [
        predicate<EditInvestorInfo>((state) =>
            state.tempSkills.contains('React') &&
            state.showSkills == false),
      ],
    );

    blocTest<IpsBloc, IpsState>(
      'removes temp skill when RemoveTempSkillInvestor is added',
      setUp: () {
        when(() => mockInvestorService.getInvestorStream(uid: any(named: 'uid')))
            .thenAnswer((_) => Stream.value(testInvestor));
      },
      build: () => ipsBloc,
      seed: () => EditInvestorInfo(
        investor: testInvestor,
        tempSkills: ['React'],
      ),
      act: (bloc) => bloc.add(RemoveTempSkillInvestor(skill: 'React')),
      expect: () => [
        predicate<EditInvestorInfo>((state) => !state.tempSkills.contains('React')),
      ],
    );

    blocTest<IpsBloc, IpsState>(
      'shows available industries when AddTempIndustryButtonPressed is added',
      setUp: () {
        when(() => mockInvestorService.getInvestorStream(uid: any(named: 'uid')))
            .thenAnswer((_) => Stream.value(testInvestor));
      },
      build: () => ipsBloc,
      seed: () => EditInvestorInfo(
        investor: testInvestor,
        tempIndustries: [],
      ),
      act: (bloc) => bloc.add(AddTempIndustryButtonPressed()),
      expect: () => [
        predicate<EditInvestorInfo>((state) => state.showIndustries == true),
      ],
    );

    blocTest<IpsBloc, IpsState>(
      'adds temp industry when AddTempIndustryInvestor is added',
      setUp: () {
        when(() => mockInvestorService.getInvestorStream(uid: any(named: 'uid')))
            .thenAnswer((_) => Stream.value(testInvestor));
      },
      build: () => ipsBloc,
      seed: () => EditInvestorInfo(
        investor: testInvestor,
        tempIndustries: [],
        showIndustries: true,
        availableIndustries: ['Finance', 'Real Estate'],
      ),
      act: (bloc) => bloc.add(AddTempIndustryInvestor(industry: 'Finance')),
      expect: () => [
        predicate<EditInvestorInfo>((state) =>
            state.tempIndustries.contains('Finance') &&
            state.showIndustries == false),
      ],
    );

    blocTest<IpsBloc, IpsState>(
      'removes temp industry when RemoveTempIndustryInvestor is added',
      setUp: () {
        when(() => mockInvestorService.getInvestorStream(uid: any(named: 'uid')))
            .thenAnswer((_) => Stream.value(testInvestor));
      },
      build: () => ipsBloc,
      seed: () => EditInvestorInfo(
        investor: testInvestor,
        tempIndustries: ['Finance'],
      ),
      act: (bloc) => bloc.add(RemoveTempIndustryInvestor(industry: 'Finance')),
      expect: () => [
        predicate<EditInvestorInfo>(
            (state) => !state.tempIndustries.contains('Finance')),
      ],
    );
  });
}

