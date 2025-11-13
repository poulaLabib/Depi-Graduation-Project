import 'package:depi_graduation_project/models/company.dart';

abstract class CompanyState {}

class LoadingCompanyProfile extends CompanyState {}

class DisplayCompanyInfo extends CompanyState {
  final Company company;
  DisplayCompanyInfo({required this.company});
}

class EditCompanyInfo extends CompanyState {
  final Company company;
  EditCompanyInfo({required this.company});
}

class CompanyError extends CompanyState {
  final String message;
  CompanyError({required this.message});
}
