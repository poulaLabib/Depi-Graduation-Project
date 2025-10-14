class Investor {
  final String uid;
  final String name;
  final String investorType;
  final String photoUrl;
  final String about;
  final String phoneNumber;
  final String experience;
  final List<String> skills;
  final int investmentCapacity;
  final String nationalIdUrl;
  final List<String> preferredIndustries;

  Investor({
    required this.uid,
    required this.name,
    required this.investorType,
    required this.photoUrl,
    required this.about,
    required this.phoneNumber,
    required this.experience,
    required this.skills,
    required this.investmentCapacity,
    required this.nationalIdUrl,
    required this.preferredIndustries,
  });

  factory Investor.fromFireStore(Map<String, dynamic> data, String uid) {
    return Investor(
      uid: uid,
      name: data['name'] ?? '',
      investorType: data['InvestorType'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      about: data['about'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      experience: data['experience'] ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      investmentCapacity: data['investmentCapacity'] ?? 0,
      nationalIdUrl: data['NationalIdUrl'] ?? '',
      preferredIndustries: List<String>.from(data['PreferredIndustries'] ?? []),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'investorType':investorType,
      'photoUrl':photoUrl,
      'about': about,
      'phoneNumber': phoneNumber,
      'experience': experience,
      'skills': skills,
      'investmentCapacity': investmentCapacity,
      'nationalIdUrl': nationalIdUrl,
      'preferredIndustries': preferredIndustries,
    };
  }
  
}
