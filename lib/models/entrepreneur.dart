class Entrepreneur {
  final String uid;
  final String about;
  final String phoneNumber;
  final String experience;
  final List<String> skills;
  final String role;
  final String nationalIdUrl;

  Entrepreneur({
    required this.uid,
    required this.about,
    required this.phoneNumber,
    required this.experience,
    required this.skills,
    required this.role,
    required this.nationalIdUrl,
  });

  factory Entrepreneur.fromFireStore(Map<String, dynamic> data, String uid) {
    return Entrepreneur(
      uid: uid,
      about: data['about'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      experience: data['experience'] ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      role: data['role'] ?? '',
      nationalIdUrl: data['NationalIdUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'about': about,
      'phoneNumber': phoneNumber,
      'experience': experience,
      'skills': skills,
      'role': role,
      'NationalIdUrl': nationalIdUrl,
    };
  }
}