import 'package:depi_graduation_project/models/investor.dart';

abstract class IpsState {}

class LoadingProfile extends IpsState {}

class DisplayInfo extends IpsState {
  final Investor investor;
  DisplayInfo({required this.investor});
}

class EditInfo extends IpsState {
  final Investor investor;
  EditInfo({required this.investor});
}
