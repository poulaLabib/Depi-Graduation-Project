abstract class IpsEvent {}

class LoadProfileData extends IpsEvent {}

class EditButtonPressed extends IpsEvent {}

class CancelButtonPressed extends IpsEvent {}

class EditProfilePhoto extends IpsEvent {}

class EditNationalIdPhoto extends IpsEvent {}

class SaveButtonPressed extends IpsEvent {
  final String name;
  final String investorType;
  final String about;
  final String phoneNumber;
  final String experience;
  final List<String> skills;
  final int investmentCapacity;
  final List<String> preferredIndustries;
  SaveButtonPressed({
    required this.name,
    required this.investorType,
    required this.about,
    required this.phoneNumber,
    required this.experience,
    required this.skills,
    required this.investmentCapacity,
    required this.preferredIndustries,
  });
}
