import 'package:depi_graduation_project/models/entrepreneur.dart';

abstract class EpsState {}

class LoadingProfile extends EpsState {}

class DisplayInfo extends EpsState {
  final Entrepreneur entrepreneur;
  DisplayInfo({required this.entrepreneur});
}

class EditInfo extends EpsState {
  final Entrepreneur entrepreneur;
  EditInfo({required this.entrepreneur});
}
