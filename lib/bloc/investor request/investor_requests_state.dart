import 'package:depi_graduation_project/models/request.dart';

abstract class InvestorRequestsState {}

class LoadingInvestorRequests extends InvestorRequestsState {}

class DisplayInvestorRequests extends InvestorRequestsState {
  final List<Request> requests;

  DisplayInvestorRequests({required this.requests});
}

class ErrorLoadingInvestorRequests extends InvestorRequestsState {
  final String message;

  ErrorLoadingInvestorRequests({required this.message});
}

