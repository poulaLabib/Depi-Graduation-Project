import 'dart:typed_data';

class InvestorProfile {
  String name;
  String about;
  String phone;
  String experience;
  String skills;
  int investmentCapacity;
  String preferredIndustries;
  String investorType;
  Uint8List? profileImage;
  Uint8List? idImage;

  InvestorProfile({
    required this.name,
    required this.about,
    required this.phone,
    required this.experience,
    required this.skills,
    required this.investmentCapacity,
    required this.preferredIndustries,
    required this.investorType,
    this.profileImage,
    this.idImage,
  });
}
