import 'package:depi_graduation_project/models/request.dart';

abstract class RequestsSectionState {}

class LoadingRequests extends RequestsSectionState {}

class DisplayRequests extends RequestsSectionState {
  final List<Request> requests;
  DisplayRequests({required this.requests});
}

class NoRequests extends RequestsSectionState {
  final bool showAddRequestDialog;

  NoRequests({this.showAddRequestDialog = false});

  NoRequests copyWith({bool? showAddRequestDialog}) {
    return NoRequests(
      showAddRequestDialog: showAddRequestDialog ?? this.showAddRequestDialog,
    );
  }
}
