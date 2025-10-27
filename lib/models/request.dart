import 'package:cloud_firestore/cloud_firestore.dart';
class Request {
  final String uid;
  final String description;
  final double amountOfMoney;
  final double equityInReturn;
  final String whyAreYouRaising;
  final DateTime? submittedAt;
  final String companyId;

  Request({
    required this.uid,
    required this.description,
    required this.amountOfMoney,
    required this.equityInReturn,
    required this.whyAreYouRaising,
    required this.submittedAt,
    required this.companyId,
  });

  factory Request.fromFireStore(Map<String, dynamic> data, String uid) {
    return Request(
      uid: uid,
      description: data['description'] ?? '',
      amountOfMoney: (data['amountOfMoney'] ?? 0).toDouble(),
      equityInReturn: (data['equityInReturn'] ?? 0).toDouble(),
      whyAreYouRaising: data['whyAreYouRaising'] ?? '',
      submittedAt: (data['submittedAt'] as Timestamp?)?.toDate(),
      companyId: data['companyId'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'description':description,
      'amountOfMoney': amountOfMoney,
      'equityInReturn': equityInReturn,
      'whyAreYouRaising': whyAreYouRaising,
      'submittedAt':submittedAt,
    };
  }
}
