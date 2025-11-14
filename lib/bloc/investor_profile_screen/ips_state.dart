import 'package:depi_graduation_project/models/investor.dart';

abstract class IpsState {}

class LoadingInvestorProfile extends IpsState {}

class DisplayInvestorInfo extends IpsState {
  final Investor investor;
  DisplayInvestorInfo({required this.investor});
}

class EditInvestorInfo extends IpsState {
  final Investor investor;
  final bool showSkills;
  final List<String> tempSkills;
  final List<String> availableSkills;
  final bool showIndustries;
  final List<String> tempIndustries;
  final List<String> availableIndustries;

  EditInvestorInfo({
    required this.investor,
    this.showSkills = false,
    this.tempSkills = const [],
    this.availableSkills = const [],
    this.showIndustries = false,
    this.tempIndustries = const [],
    this.availableIndustries = const [],
  });

  EditInvestorInfo copyWith({
    Investor? investor,
    bool? showSkills,
    List<String>? tempSkills,
    List<String>? availableSkills,
    bool? showIndustries,
    List<String>? tempIndustries,
    List<String>? availableIndustries,
  }) {
    return EditInvestorInfo(
      investor: investor ?? this.investor,
      showSkills: showSkills ?? this.showSkills,
      tempSkills: tempSkills ?? this.tempSkills,
      availableSkills: availableSkills ?? this.availableSkills,
      showIndustries: showIndustries ?? this.showIndustries,
      tempIndustries: tempIndustries ?? this.tempIndustries,
      availableIndustries: availableIndustries ?? this.availableIndustries,
    );
  }
}
