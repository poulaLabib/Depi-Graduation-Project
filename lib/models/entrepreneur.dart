
class Entrepreneur {
  final String uid;
  final String name;
  final String about;
  final String phoneNumber;
  final String experience;
  final String skills;
  final String role;
  final String profileImageUrl;
  final String idImageUrl;

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
  });

  factory Entrepreneur.fromFireStore(Map<String, dynamic> data, String uid) {
    return Entrepreneur(
      uid: uid,
      name: data['name'] ?? '',
      about: data['about'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      experience: data['experience'] ?? '',
      skills: data['skills'] ??'' ,
      role: data['role'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      idImageUrl: data['idImageUrl'] ?? '',
    );
  }
}
