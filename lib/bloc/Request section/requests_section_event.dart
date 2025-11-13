abstract class RequestsSectionEvent {}

class LoadRequests extends RequestsSectionEvent {}

class AddRequestButtonPressed extends RequestsSectionEvent {}

class AddRequestConfirmed extends RequestsSectionEvent {
  final String description;
  final double amountOfMoney;
  final String equityInReturn;
  final String whyAreYouRaising;

  AddRequestConfirmed({
    required this.description,
    required this.amountOfMoney,
    required this.equityInReturn,
    required this.whyAreYouRaising,
  });
}
