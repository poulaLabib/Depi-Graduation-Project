import 'package:depi_graduation_project/models/request.dart';

abstract class RequestScreenState {}


class LoadingRequest extends RequestScreenState {

}

class DisplayingRequest extends RequestScreenState {
  final Request request;
  DisplayingRequest({required this.request});
}

class EditingRequest extends RequestScreenState {
  final Request request;
  EditingRequest({required this.request});
}
