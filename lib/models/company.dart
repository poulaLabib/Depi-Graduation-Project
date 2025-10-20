class Company {
  final String uid;
  final String name;
  final String description;
  final int founded;
  final int teamSize;
  final String industry;
  final String stage;
  final String currency;
  final String location;
  final List<Map<String, dynamic>> teamMembers;
  final String logoUrl;
  final String certificateUrl;

  Company({
    required this.uid,
    required this.name,
    required this.description,
    required this.founded,
    required this.teamSize,
    required this.industry,
    required this.stage,
    required this.currency,
    required this.location,
    required this.teamMembers,
    required this.logoUrl,
    required this.certificateUrl,
  });

  factory Company.fromFireStore(Map<String, dynamic> data, String uid) {
    return Company(
      uid: uid,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      founded: data['founded'] ?? 0,
      teamSize: data['teamSize'] ?? 0,
      industry: data['industry'] ?? '',
      stage: data['stage'] ?? '',
      currency: data['currency'] ?? '',
      location: data['location'] ?? '',
      teamMembers: List<Map<String, dynamic>>.from(data['teamMembers'] ?? []),
      logoUrl: data['logoUrl'] ?? '',
      certificateUrl: data['certificateUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'founded': founded,
      'teamSize': teamSize,
      'industry': industry,
      'stage': stage,
      'currency': currency,
      'location': location,
      'teamMembers': teamMembers,
      'logoUrl': logoUrl,
      'certificateUrl': certificateUrl,
    };
  }
}