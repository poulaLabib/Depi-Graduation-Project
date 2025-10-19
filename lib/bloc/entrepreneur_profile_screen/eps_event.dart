import 'package:depi_graduation_project/bloc/entrepreneur_profile_screen/eps_state.dart';

abstract class EpsEvent {}

class LoadProfileData extends EpsEvent {}

class EditButtonPressed extends EpsEvent {}

class SaveButtonPressed extends EpsEvent {
  final String name;
  final String about;
  final String phoneNumber;
  final String experience;
  final List<String> skills;
  final String role;
  SaveButtonPressed({
    required this.name,
    required this.about,
    required this.phoneNumber,
    required this.experience,
    required this.skills,
    required this.role,
  });
}

class CancelButtonPressed extends EpsEvent {}

class EditProfilePhoto extends EpsEvent {}

class EditAuthenticationPhoto extends EpsEvent {}
