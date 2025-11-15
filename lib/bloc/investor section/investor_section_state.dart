import 'package:depi_graduation_project/models/investor.dart';

abstract class InvestorSectionState {}

class LoadingInvestors extends InvestorSectionState {}

class DisplayInvestors extends InvestorSectionState {
  final List<Investor> investors;
  final List<Investor> filteredInvestors;
  final List<String>? selectedIndustries;
  final int? minInvestmentCapacity;
  final int? maxInvestmentCapacity;

  DisplayInvestors({
    required this.investors,
    required this.filteredInvestors,
    this.selectedIndustries,
    this.minInvestmentCapacity,
    this.maxInvestmentCapacity,
  });

  DisplayInvestors copyWith({
    List<Investor>? investors,
    List<Investor>? filteredInvestors,
    List<String>? selectedIndustries,
    int? minInvestmentCapacity,
    int? maxInvestmentCapacity,
  }) {
    return DisplayInvestors(
      investors: investors ?? this.investors,
      filteredInvestors: filteredInvestors ?? this.filteredInvestors,
      selectedIndustries: selectedIndustries ?? this.selectedIndustries,
      minInvestmentCapacity: minInvestmentCapacity ?? this.minInvestmentCapacity,
      maxInvestmentCapacity: maxInvestmentCapacity ?? this.maxInvestmentCapacity,
    );
  }
}

class ErrorLoadingInvestors extends InvestorSectionState {
  final String message;

  ErrorLoadingInvestors({required this.message});
}