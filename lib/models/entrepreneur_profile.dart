import 'dart:typed_data';

class EntrepreneurProfile {
  String name;
  String about;
  String phone;
  String experience;
  String skills;
  String role;
  Uint8List? profileImageBytes;
  Uint8List? idImageBytes;

  EntrepreneurProfile({
    required this.name,
    required this.about,
    required this.phone,
    required this.experience,
    required this.skills,
    required this.role,
    this.profileImageBytes,
    this.idImageBytes,
  });
}
