import 'package:bloc_test/bloc_test.dart';
import 'package:depi_graduation_project/bloc/Investor section/investor_section_bloc.dart';
import 'package:depi_graduation_project/bloc/Investor section/investor_section_event.dart';
import 'package:depi_graduation_project/bloc/Investor section/investor_section_state.dart';
import 'package:depi_graduation_project/models/investor.dart';
import 'package:depi_graduation_project/services/firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockInvestorFirestoreService extends Mock
    implements InvestorFirestoreService {}

void main() {
  late InvestorSectionBloc investorSectionBloc;
  late MockInvestorFirestoreService mockInvestorService;

  final testInvestors = [
    Investor(
      uid: 'uid1',
      name: 'Investor 1',
      about: 'About investor 1',
      phoneNumber: '1234567890',
      experience: '5 years',
      skills: ['Finance', 'Marketing'],
      investmentCapacity: 50000,
      preferredIndustries: ['Tech', 'Healthcare'],
      investorType: 'Angel Investor',
      nationalIdUrl: '',
      photoUrl: '',
    ),
    Investor(
      uid: 'uid2',
      name: 'Investor 2',
      about: 'About investor 2',
      phoneNumber: '0987654321',
      experience: '10 years',
      skills: ['Tech', 'AI'],
      investmentCapacity: 100000,
      preferredIndustries: ['Tech', 'AI'],
      investorType: 'Venture Capitalist',
      nationalIdUrl: '',
      photoUrl: '',
    ),
  ];

  setUp(() {
    mockInvestorService = MockInvestorFirestoreService();

    investorSectionBloc = InvestorSectionBloc(
      investorService: mockInvestorService,
    );
  });

  tearDown(() {
    investorSectionBloc.close();
  });

  group('InvestorSectionBloc', () {
    test('initial state is LoadingInvestors', () {
      expect(investorSectionBloc.state, isA<LoadingInvestors>());
    });

    blocTest<InvestorSectionBloc, InvestorSectionState>(
      'emits LoadingInvestors then DisplayInvestors when LoadInvestors succeeds',
      setUp: () {
        when(() => mockInvestorService.getInvestors())
            .thenAnswer((_) async => testInvestors);
      },
      build: () => investorSectionBloc,
      act: (bloc) => bloc.add(LoadInvestors()),
      expect: () => [
        isA<LoadingInvestors>(),
        isA<DisplayInvestors>(),
      ],
      verify: (_) {
        verify(() => mockInvestorService.getInvestors()).called(1);
      },
    );

    blocTest<InvestorSectionBloc, InvestorSectionState>(
      'emits ErrorLoadingInvestors when LoadInvestors fails',
      setUp: () {
        when(() => mockInvestorService.getInvestors())
            .thenThrow(Exception('Error loading investors'));
      },
      build: () => investorSectionBloc,
      act: (bloc) => bloc.add(LoadInvestors()),
      expect: () => [
        isA<LoadingInvestors>(),
        isA<ErrorLoadingInvestors>(),
      ],
    );

    blocTest<InvestorSectionBloc, InvestorSectionState>(
      'filters investors by selected industries',
      setUp: () {
        when(() => mockInvestorService.getInvestors())
            .thenAnswer((_) async => testInvestors);
      },
      build: () => investorSectionBloc,
      seed: () => DisplayInvestors(
        investors: testInvestors,
        filteredInvestors: testInvestors,
      ),
      act: (bloc) => bloc.add(FilterInvestors(
            selectedIndustries: ['Tech'],
          )),
      expect: () => [
        predicate<DisplayInvestors>((state) {
          return state.filteredInvestors.length == 2 &&
              state.selectedIndustries == ['Tech'];
        }),
      ],
    );

    blocTest<InvestorSectionBloc, InvestorSectionState>(
      'filters investors by min investment capacity',
      setUp: () {
        when(() => mockInvestorService.getInvestors())
            .thenAnswer((_) async => testInvestors);
      },
      build: () => investorSectionBloc,
      seed: () => DisplayInvestors(
        investors: testInvestors,
        filteredInvestors: testInvestors,
      ),
      act: (bloc) => bloc.add(FilterInvestors(
            minInvestmentCapacity: 75000,
          )),
      expect: () => [
        predicate<DisplayInvestors>((state) {
          return state.filteredInvestors.length == 1 &&
              state.filteredInvestors.first.investmentCapacity >= 75000;
        }),
      ],
    );

    blocTest<InvestorSectionBloc, InvestorSectionState>(
      'filters investors by max investment capacity',
      setUp: () {
        when(() => mockInvestorService.getInvestors())
            .thenAnswer((_) async => testInvestors);
      },
      build: () => investorSectionBloc,
      seed: () => DisplayInvestors(
        investors: testInvestors,
        filteredInvestors: testInvestors,
      ),
      act: (bloc) => bloc.add(FilterInvestors(
            maxInvestmentCapacity: 75000,
          )),
      expect: () => [
        predicate<DisplayInvestors>((state) {
          return state.filteredInvestors.length == 1 &&
              state.filteredInvestors.first.investmentCapacity <= 75000;
        }),
      ],
    );

    blocTest<InvestorSectionBloc, InvestorSectionState>(
      'filters investors by multiple criteria',
      setUp: () {
        when(() => mockInvestorService.getInvestors())
            .thenAnswer((_) async => testInvestors);
      },
      build: () => investorSectionBloc,
      seed: () => DisplayInvestors(
        investors: testInvestors,
        filteredInvestors: testInvestors,
      ),
      act: (bloc) => bloc.add(FilterInvestors(
            selectedIndustries: ['Tech'],
            minInvestmentCapacity: 75000,
          )),
      expect: () => [
        predicate<DisplayInvestors>((state) {
          return state.filteredInvestors.length == 1 &&
              state.selectedIndustries == ['Tech'] &&
              state.minInvestmentCapacity == 75000;
        }),
      ],
    );

    blocTest<InvestorSectionBloc, InvestorSectionState>(
      'clears filters when ClearFilters is added',
      setUp: () {
        when(() => mockInvestorService.getInvestors())
            .thenAnswer((_) async => testInvestors);
      },
      build: () => investorSectionBloc,
      seed: () => DisplayInvestors(
        investors: testInvestors,
        filteredInvestors: [testInvestors.first],
        selectedIndustries: ['Tech'],
        minInvestmentCapacity: 50000,
      ),
      act: (bloc) => bloc.add(ClearFilters()),
      expect: () => [
        predicate<DisplayInvestors>((state) {
          return state.filteredInvestors.length == testInvestors.length &&
              state.selectedIndustries == null &&
              state.minInvestmentCapacity == null &&
              state.maxInvestmentCapacity == null;
        }),
      ],
    );

    blocTest<InvestorSectionBloc, InvestorSectionState>(
      'does not filter if state is not DisplayInvestors',
      setUp: () {
        when(() => mockInvestorService.getInvestors())
            .thenAnswer((_) async => testInvestors);
      },
      build: () => investorSectionBloc,
      seed: () => LoadingInvestors(),
      act: (bloc) => bloc.add(FilterInvestors(
            selectedIndustries: ['Tech'],
          )),
      expect: () => [],
    );

    blocTest<InvestorSectionBloc, InvestorSectionState>(
      'automatically loads investors on initialization',
      setUp: () {
        when(() => mockInvestorService.getInvestors())
            .thenAnswer((_) async => testInvestors);
      },
      build: () => InvestorSectionBloc(investorService: mockInvestorService),
      expect: () => [
        isA<LoadingInvestors>(),
        isA<DisplayInvestors>(),
      ],
    );
  });
}

