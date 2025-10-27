class Investor {
  final String uid;
  final String name;
  final String about;
  final String phoneNumber;
  final String experience;
  final List<String> skills;
  final int investmentCapacity;
  final List<String> preferredIndustries;
  final String investorType;
  final String nationalIdUrl;
  final String photoUrl;

  Investor({
    required this.uid,
    required this.name,
    required this.about,
    required this.phoneNumber,
    required this.experience,
    required this.skills,
    required this.investmentCapacity,
    required this.preferredIndustries,
    required this.investorType,
    required this.nationalIdUrl,
    required this.photoUrl,
  });

  factory Investor.fromFireStore(Map<String, dynamic> data, String uid) {
    return Investor(
      uid: uid,
      name: data['name'] ?? '',
      about: data['about'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      experience: data['experience'] ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      investmentCapacity: data['investmentCapacity'] ?? 0,
      preferredIndustries: List<String>.from(data['preferredIndustries'] ?? []),
      investorType: data['investorType'] ?? '',
      nationalIdUrl: data['nationalIdUrl'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'about': about,
      'phoneNumber': phoneNumber,
      'experience': experience,
      'skills': skills,
      'investmentCapacity': investmentCapacity,
      'preferredIndustries': preferredIndustries,
      'investorType': investorType,
      'nationalIdUrl': nationalIdUrl,
      'photoUrl': photoUrl,
    };
  }
}
