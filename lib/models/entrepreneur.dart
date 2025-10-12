class Entrepreneur {
  final String uid;
  final String name;
  final String about;
  final String phoneNumber;
  final String experience;
  final List<String> skills;
  final String role;
  final String profileImageUrl;
  final String idImageUrl;
  final String nationalIdUrl;

  Entrepreneur({
    required this.uid,
    required this.name,
    required this.about,
    required this.phoneNumber,
    required this.experience,
    required this.skills,
    required this.role,
    required this.profileImageUrl,
    required this.idImageUrl,
    required this.nationalIdUrl,
  });

  factory Entrepreneur.fromFireStore(Map<String, dynamic> data, String uid) {
    return Entrepreneur(
      uid: uid,
      name: data['name'] ?? '',
      about: data['about'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      experience: data['experience'] ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      role: data['role'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      idImageUrl: data['idImageUrl'] ?? '',
      nationalIdUrl: data['NationalIdUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'about': about,
      'phoneNumber': phoneNumber,
      'experience': experience,
      'skills': skills,
      'role': role,
      'profileImageUrl': profileImageUrl,
      'idImageUrl': idImageUrl,
      'NationalIdUrl': nationalIdUrl,
    };
  }
}
