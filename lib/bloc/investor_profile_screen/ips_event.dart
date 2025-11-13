abstract class IpsEvent {}

class LoadInvestorData extends IpsEvent {}

class EditInvestorButtonPressed extends IpsEvent {}

class SaveInvestorButtonPressed extends IpsEvent {
  final String name;
  final String investorType;
  final String about;
  final String phoneNumber;
  final String experience;
  final List<String> skills;
  final List<String> preferredIndustries;
  final int investmentCapacity;

  SaveInvestorButtonPressed({
    required this.name,
    required this.investorType,
    required this.about,
    required this.phoneNumber,
    required this.experience,
    required this.skills,
    required this.preferredIndustries,
    required this.investmentCapacity,
  });
}

class CancelInvestorButtonPressed extends IpsEvent {}

class AddTempIndustryButtonPressed extends IpsEvent {}

class EditInvestorPhoto extends IpsEvent {
  final String type;
  EditInvestorPhoto({required this.type});
}

class AddTempSkillButtonPressed extends IpsEvent {}

class AddTempSkillInvestor extends IpsEvent {
  final String skill;
  AddTempSkillInvestor({required this.skill});
}

class RemoveTempSkillInvestor extends IpsEvent {
  final String skill;
  RemoveTempSkillInvestor({required this.skill});
}

class AddTempIndustryInvestor extends IpsEvent {
  final String industry;
  AddTempIndustryInvestor({required this.industry});
}

class RemoveTempIndustryInvestor extends IpsEvent {
  final String industry;
  RemoveTempIndustryInvestor({required this.industry});
}
