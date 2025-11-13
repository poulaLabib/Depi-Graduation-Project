abstract class CompanyEvent {}

class LoadCompanyProfileData extends CompanyEvent {}

class EditCompanyButtonPressed extends CompanyEvent {}

class SaveCompanyButtonPressed extends CompanyEvent {
  final String name;
  final String description;
  final int founded;
  final int teamSize;
  final String industry;
  final String stage;
  final String currency;
  final String location;
  final List<Map<String, dynamic>> teamMembers;

  SaveCompanyButtonPressed({
    required this.name,
    required this.description,
    required this.founded,
    required this.teamSize,
    required this.industry,
    required this.stage,
    required this.currency,
    required this.location,
    required this.teamMembers,
  });
}

class CancelCompanyButtonPressed extends CompanyEvent {}

class EditCompanyLogo extends CompanyEvent {}

class EditCompanyCertificate extends CompanyEvent {}