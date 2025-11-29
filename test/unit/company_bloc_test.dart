import 'package:bloc_test/bloc_test.dart';
import 'package:depi_graduation_project/bloc/company_profile_screen/company_bloc.dart';
import 'package:depi_graduation_project/bloc/company_profile_screen/cps_event.dart';
import 'package:depi_graduation_project/bloc/company_profile_screen/cps_state.dart';
import 'package:depi_graduation_project/models/company.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockCompanyFirestoreService extends Mock
    implements CompanyFirestoreService {}

class MockAuthenticationService extends Mock implements AuthenticationService {}

class MockUser extends Mock implements User {}

void main() {
  late CompanyBloc companyBloc;
  late MockCompanyFirestoreService mockCompanyService;
  late MockAuthenticationService mockAuthService;
  late MockUser mockUser;

  final testCompany = Company(
    uid: 'test-uid',
    name: 'Test Company',
    description: 'Test description',
    founded: 2020,
    teamSize: 10,
    industry: 'Tech',
    stage: 'Seed',
    currency: 'USD',
    location: 'New York',
    teamMembers: [],
    logoUrl: '',
    certificateUrl: '',
  );

  setUp(() {
    mockCompanyService = MockCompanyFirestoreService();
    mockAuthService = MockAuthenticationService();
    mockUser = MockUser();

    when(() => mockAuthService.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('test-uid');
    when(() => mockUser.displayName).thenReturn('Test User');
    registerFallbackValue(mockUser);

    companyBloc = CompanyBloc(
      company: mockCompanyService,
      auth: mockAuthService,
    );
  });

  tearDown(() {
    companyBloc.close();
  });

  group('CompanyBloc', () {
    test('initial state is LoadingCompanyProfile', () {
      expect(companyBloc.state, isA<LoadingCompanyProfile>());
    });

    blocTest<CompanyBloc, CompanyState>(
      'emits DisplayCompanyInfo when LoadCompanyProfileData succeeds and company exists',
      setUp: () {
        when(() => mockCompanyService.companyExists(uid: any(named: 'uid')))
            .thenAnswer((_) async => true);
        when(() => mockCompanyService.getCompanyStream(uid: any(named: 'uid')))
            .thenAnswer((_) => Stream.value(testCompany));
      },
      build: () => companyBloc,
      act: (bloc) => bloc.add(LoadCompanyProfileData()),
      expect: () => [
        isA<DisplayCompanyInfo>(),
      ],
      verify: (_) {
        verify(() => mockCompanyService.companyExists(uid: 'test-uid'))
            .called(1);
        verify(() => mockCompanyService.getCompanyStream(uid: 'test-uid'))
            .called(1);
      },
    );

    blocTest<CompanyBloc, CompanyState>(
      'creates company and emits DisplayCompanyInfo when company does not exist',
      setUp: () {
        when(() => mockCompanyService.companyExists(uid: any(named: 'uid')))
            .thenAnswer((_) async => false);
        when(() => mockCompanyService.addCompany(
              name: any(named: 'name'),
              uid: any(named: 'uid'),
            )).thenAnswer((_) async => {});
        when(() => mockCompanyService.getCompanyStream(uid: any(named: 'uid')))
            .thenAnswer((_) => Stream.value(testCompany));
      },
      build: () => companyBloc,
      act: (bloc) => bloc.add(LoadCompanyProfileData()),
      expect: () => [
        isA<DisplayCompanyInfo>(),
      ],
      verify: (_) {
        verify(() => mockCompanyService.addCompany(
              name: 'Test User',
              uid: 'test-uid',
            )).called(1);
      },
    );

    blocTest<CompanyBloc, CompanyState>(
      'emits EditCompanyInfo when EditCompanyButtonPressed is added',
      setUp: () {
        when(() => mockCompanyService.companyExists(uid: any(named: 'uid')))
            .thenAnswer((_) async => true);
        when(() => mockCompanyService.getCompany(uid: any(named: 'uid')))
            .thenAnswer((_) async => testCompany);
        when(() => mockCompanyService.getCompanyStream(uid: any(named: 'uid')))
            .thenAnswer((_) => Stream.value(testCompany));
      },
      build: () => companyBloc,
      seed: () => DisplayCompanyInfo(company: testCompany),
      act: (bloc) => bloc.add(EditCompanyButtonPressed()),
      expect: () => [
        isA<EditCompanyInfo>(),
      ],
    );

    blocTest<CompanyBloc, CompanyState>(
      'calls updateCompany and emits DisplayCompanyInfo when SaveCompanyButtonPressed is added',
      setUp: () {
        when(() => mockCompanyService.companyExists(uid: any(named: 'uid')))
            .thenAnswer((_) async => true);
        when(() => mockCompanyService.updateCompany(
              uid: any(named: 'uid'),
              updatedData: any(named: 'updatedData'),
            )).thenAnswer((_) async => true);
        when(() => mockCompanyService.getCompany(uid: any(named: 'uid')))
            .thenAnswer((_) async => testCompany);
        when(() => mockCompanyService.getCompanyStream(uid: any(named: 'uid')))
            .thenAnswer((_) => Stream.value(testCompany));
      },
      build: () => companyBloc,
      seed: () => EditCompanyInfo(company: testCompany),
      act: (bloc) => bloc.add(SaveCompanyButtonPressed(
            name: 'Updated Company',
            description: 'Updated description',
            founded: 2021,
            teamSize: 15,
            industry: 'Finance',
            stage: 'Series A',
            currency: 'EUR',
            location: 'London',
            teamMembers: [],
          )),
      expect: () => [
        isA<LoadingCompanyProfile>(),
        isA<DisplayCompanyInfo>(),
      ],
      verify: (_) {
        verify(() => mockCompanyService.updateCompany(
              uid: 'test-uid',
              updatedData: any(named: 'updatedData'),
            )).called(1);
      },
    );

    blocTest<CompanyBloc, CompanyState>(
      'emits DisplayCompanyInfo when CancelCompanyButtonPressed is added',
      setUp: () {
        when(() => mockCompanyService.companyExists(uid: any(named: 'uid')))
            .thenAnswer((_) async => true);
        when(() => mockCompanyService.getCompany(uid: any(named: 'uid')))
            .thenAnswer((_) async => testCompany);
        when(() => mockCompanyService.getCompanyStream(uid: any(named: 'uid')))
            .thenAnswer((_) => Stream.value(testCompany));
      },
      build: () => companyBloc,
      seed: () => EditCompanyInfo(company: testCompany),
      act: (bloc) => bloc.add(CancelCompanyButtonPressed()),
      expect: () => [
        isA<LoadingCompanyProfile>(),
        isA<DisplayCompanyInfo>(),
      ],
    );
  });
}

