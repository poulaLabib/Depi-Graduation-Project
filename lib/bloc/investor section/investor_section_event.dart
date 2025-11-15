abstract class InvestorSectionEvent {}

class LoadInvestors extends InvestorSectionEvent {}

class FilterInvestors extends InvestorSectionEvent {
  final List<String>? selectedIndustries;
  final int? minInvestmentCapacity;
  final int? maxInvestmentCapacity;

  FilterInvestors({
    this.selectedIndustries,
    this.minInvestmentCapacity,
    this.maxInvestmentCapacity,
  });
}

class ClearFilters extends InvestorSectionEvent {}