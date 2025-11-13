import 'package:depi_graduation_project/models/entrepreneur.dart';

abstract class EpsState {}

class LoadingProfile extends EpsState {}

class DisplayInfo extends EpsState {
  final Entrepreneur entrepreneur;
  DisplayInfo({required this.entrepreneur});
}

class EditInfo extends EpsState {
  final Entrepreneur entrepreneur;
  final bool showSkills;
  final List<String> tempSkills;
  final List<String> availableSkills;

  EditInfo({
    required this.entrepreneur,
    this.showSkills = false,
    this.tempSkills = const [],
    this.availableSkills = const [],
  });

  EditInfo copyWith({
    Entrepreneur? entrepreneur,
    bool? showSkills,
    List<String>? tempSkills,
    List<String>? availableSkills,
  }) {
    return EditInfo(
      entrepreneur: entrepreneur ?? this.entrepreneur,
      showSkills: showSkills ?? this.showSkills,
      tempSkills: tempSkills ?? this.tempSkills,
      availableSkills: availableSkills ?? this.availableSkills,
    );
  }
}
