import 'package:depi_graduation_project/models/request.dart';

abstract class RequestScreenEvent {}

class LoadRequest extends RequestScreenEvent {
  final Request request;
  LoadRequest({required this.request});
}

class EditRequestRequested extends RequestScreenEvent {}

class EditRequestConfirmed extends RequestScreenEvent {
  final String description;
  final String amountOfMoney;
  final String equityInReturn;
  final String whyAreYouRaising;
  EditRequestConfirmed({
    required this.amountOfMoney,
    required this.description,
    required this.equityInReturn,
    required this.whyAreYouRaising,
  });
}

class CancelButtonPressed extends RequestScreenEvent {}
