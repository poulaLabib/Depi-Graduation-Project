import 'package:bloc/bloc.dart';
import 'package:depi_graduation_project/bloc/Investor%20section/investor_section_event.dart';
import 'package:depi_graduation_project/bloc/Investor%20section/investor_section_state.dart';
import 'package:depi_graduation_project/models/investor.dart';
import 'package:depi_graduation_project/services/firestore.dart';

class InvestorSectionBloc
    extends Bloc<InvestorSectionEvent, InvestorSectionState> {
  final InvestorFirestoreService investorService;

  InvestorSectionBloc({required this.investorService})
      : super(LoadingInvestors()) {
    on<LoadInvestors>((event, emit) async {
      emit(LoadingInvestors());
      try {
        final investors = await investorService.getInvestors();
        emit(DisplayInvestors(
          investors: investors,
          filteredInvestors: investors,
        ));
      } catch (e) {
        emit(ErrorLoadingInvestors(message: e.toString()));
      }
    });

    on<FilterInvestors>((event, emit) async {
      if (state is! DisplayInvestors) return;

      final currentState = state as DisplayInvestors;
      List<Investor> filtered = List.from(currentState.investors);

      // Filter by industries
      if (event.selectedIndustries != null &&
          event.selectedIndustries!.isNotEmpty) {
        filtered = filtered.where((investor) {
          return investor.preferredIndustries.any((industry) =>
              event.selectedIndustries!.contains(industry));
        }).toList();
      }

      // Filter by investment capacity
      if (event.minInvestmentCapacity != null) {
        filtered = filtered.where((investor) {
          return investor.investmentCapacity >= event.minInvestmentCapacity!;
        }).toList();
      }

      if (event.maxInvestmentCapacity != null) {
        filtered = filtered.where((investor) {
          return investor.investmentCapacity <= event.maxInvestmentCapacity!;
        }).toList();
      }

      emit(currentState.copyWith(
        filteredInvestors: filtered,
        selectedIndustries: event.selectedIndustries,
        minInvestmentCapacity: event.minInvestmentCapacity,
        maxInvestmentCapacity: event.maxInvestmentCapacity,
      ));
    });

    on<ClearFilters>((event, emit) {
      if (state is! DisplayInvestors) return;

      final currentState = state as DisplayInvestors;
      emit(currentState.copyWith(
        filteredInvestors: currentState.investors,
        selectedIndustries: null,
        minInvestmentCapacity: null,
        maxInvestmentCapacity: null,
      ));
    });

    add(LoadInvestors());
  }
}

