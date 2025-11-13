import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  final String requestId;
  final String uid;
  final String description;
  final double amountOfMoney;
  final String equityInReturn;
  final String whyAreYouRaising;
  final DateTime? submittedAt;

  Request({
    required this.requestId,
    required this.uid,
    required this.description,
    required this.amountOfMoney,
    required this.equityInReturn,
    required this.whyAreYouRaising,
    required this.submittedAt,
  });

  factory Request.fromFireStore(Map<String, dynamic> data, String requestId) {
    return Request(
      requestId: requestId,
      uid: data['uid'] ?? '',
      description: data['description'] ?? '',
      amountOfMoney: (data['amountOfMoney'] ?? 0).toDouble(),
      equityInReturn: (data['equityInReturn'] ?? ''),
      whyAreYouRaising: data['whyAreYouRaising'] ?? '',
      submittedAt: (data['submittedAt'] as Timestamp?)?.toDate(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'amountOfMoney': amountOfMoney,
      'equityInReturn': equityInReturn,
      'whyAreYouRaising': whyAreYouRaising,
      'submittedAt': submittedAt,
    };
  }
}
