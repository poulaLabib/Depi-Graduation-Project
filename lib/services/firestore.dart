// collections investor, entrepreneur, company, requests.
// investor ==> name*, profilePhotoUrl*, about*, phoneNumber*, Experience*, skills*, investmentCapacity*, NationalIdUrl*, PreferredIndustries*, InvestorType, uid
// entrepreneur ==> profilePhotoUrl* name*, about*, phoneNumber*, experience*, skills*, role*, NationalIdUrl*, uid
// company ==> name*, description*, founded*, teamSize*, industry*, stage*, currency*, location*, teamMembers* list<map<>> => name, role*, verifiedCertificate*, uid, createdAt
// request ==> description*, amountOfMoney*, equityInReturn*, whyAreYouRaising*, submittedAt, companyid, uid

// CRUD
// addCompany, addRequest, addInvestor, addEntrepreneur,
// read data,
// update data,
// delete request,

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_graduation_project/models/investor.dart';
import 'package:depi_graduation_project/models/request.dart';
import 'package:depi_graduation_project/models/company.dart';
import 'package:depi_graduation_project/models/entrepreneur.dart';

// global variable _db to access firestore functions to use in all 4 classes
final FirebaseFirestore _db = FirebaseFirestore.instance;

// functions addInvestor, updateInvestor, getInvestorStream, getInvestors, deleteInvestor
class InvestorFirestoreService {
  // Function to add investor
  Future<void> addInvestor({required String name, required String uid}) async {
    await _db.collection('investors').doc(uid).set({
      'name': name,
      'InvestorType': '',
      'photoUrl': '',
      'about': '',
      'phoneNumber': '',
      'experience': '',
      'skills': <String>[],
      'investmentCapacity': 0,
      'NationalIdUrl': '',
      'PreferredIndustries': <String>[],
    });
  }

  // Function to update investor data all at once requires map<String, dynamic>
  Future<void> updateInvestor({
    required String uid,
    required Map<String, dynamic> updatedData,
  }) async {
    await _db.collection('investors').doc(uid).update(updatedData);
  }

  // Function to get stream of investor object => any thing changes in the firestore the investor changes as well, mainly for his profile page when he updates data.
  Stream<Investor> getInvestorStream({required String uid}) {
    return _db
        .collection('investors')
        .doc(uid)
        .snapshots()
        .map((snapshot) => Investor.fromFireStore(snapshot.data() ?? {}, uid));
  }

  // Function to get all investors as objects, for entrepreneur to see all investors
  Future<List<Investor>> getInvestors() async {
    final snapshot = await _db.collection('investors').get();
    return snapshot.docs.map((doc) {
      return Investor.fromFireStore(doc.data(), doc.id);
    }).toList();
  }

  // Function to delete investor document in investors collection, used if investor deletes his account
  Future<void> deleteInvestor({required String uid}) async {
    await _db.collection('investors').doc(uid).delete();
  }
}

class RequestFirestoreService {
  // Function to add request
  Future<void> addRequest({
    required String uid,
    required String description,
  }) async {
    await _db.collection('requests').doc(uid).set({
      'description': description,
      'amountOfMoney': '',
      'equityInReturn': '',
      'whyAreYouRaising': '',
      'submittedAt': FieldValue.serverTimestamp(),
      'companyId': '',
    });
  }

  // Function to update request data
  Future<void> updateRequest({
    required String uid,
    required Map<String, dynamic> updatedData,
  }) async {
    await _db.collection('requests').doc(uid).update(updatedData);
  }

  // Function to get a stream of request data (auto-updates when Firestore changes)
  Stream<Request> getRequestStream({required String uid}) {
    return _db
        .collection('requests')
        .doc(uid)
        .snapshots()
        .map((snapshot) => Request.fromFireStore(snapshot.data() ?? {}, uid));
  }

  // Function to get all requests
  Future<List<Request>> getRequests() async {
    final snapshot = await _db.collection('requests').get();
    return snapshot.docs
        .map((doc) => Request.fromFireStore(doc.data(), doc.id))
        .toList();
  }

  // Function to delete request
  Future<void> deleteRequest({required String uid}) async {
    await _db.collection('requests').doc(uid).delete();
  }
}

class CompanyFirestoreService {
  // Function to add company
  Future<void> addCompany({required String name, required String uid}) async {
    await _db.collection('companies').doc(uid).set({
      'name': name,
      'description': '',
      'founded': 0,
      'teamSize': 0,
      'industry': '',
      'stage': '',
      'currency': '',
      'location': '',
      'teamMembers': <Map<String, dynamic>>[],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Function to update company data all at once requires map<String, dynamic>
  Future<void> updateCompany({
    required String uid,
    required Map<String, dynamic> updatedData,
  }) async {
    await _db.collection('companies').doc(uid).update(updatedData);
  }

  // Function to get stream of company object => any thing changes in the firestore the company changes as well, mainly for his profile page when he updates data.
  Stream<Company> getCompanyStream({required String uid}) {
    return _db
        .collection('companies')
        .doc(uid)
        .snapshots()
        .map((snapshot) => Company.fromFireStore(snapshot.data() ?? {}, uid));
  }

  // Function to get all companies as objects, for entrepreneur to see all companies
  Future<List<Company>> getCompanies() async {
    final snapshot = await _db.collection('companies').get();
    return snapshot.docs.map((doc) {
      return Company.fromFireStore(doc.data(), doc.id);
    }).toList();
  }

  // Function to delete company document in companies collection, used if company deletes his account
  Future<void> deleteCompany({required String uid}) async {
    await _db.collection('companies').doc(uid).delete();
  }
}

class EntrepreneurFirestoreService {
  // Add entrepreneur
  Future<void> addEntrepreneur({
    required String uid,
    required String name,
  }) async {
    await _db.collection('entrepreneurs').doc(uid).set({
      'name': name,
      'about': '',
      'phoneNumber': '',
      'experience': '',
      'skills': <String>[],
      'profilePhotoUrl': '',
      'role': '',
      'idImageUrl': '',
    });
  }

  // Update entrepreneur
  Future<void> updateEntrepreneur({
    required String uid,
    required Map<String, dynamic> updatedData,
  }) async {
    await _db.collection('entrepreneurs').doc(uid).update(updatedData);
  }

  // Get entrepreneur stream
  Stream<Entrepreneur> getEntrepreneurStream({required String uid}) {
    return _db
        .collection('entrepreneurs')
        .doc(uid)
        .snapshots()
        .map(
          (snapshot) => Entrepreneur.fromFireStore(snapshot.data() ?? {}, uid),
        );
  }

  // get entrepreneur once
  Future<Entrepreneur> getEntrepreneur({required String uid}) async {
    final doc = await _db.collection('entrepreneurs').doc(uid).get();
    return Entrepreneur.fromFireStore(doc.data() ?? {}, uid);
  }

  // Get all entrepreneurs
  Future<List<Entrepreneur>> getEntrepreneurs() async {
    final snapshot = await _db.collection('entrepreneurs').get();
    return snapshot.docs.map((doc) {
      return Entrepreneur.fromFireStore(doc.data(), doc.id);
    }).toList();
  }

  // update profile photo url
  Future<void> updateEntrepreneurProfilePhotoUrl({
    required String uid,
    required String newUrl,
  }) async {
    await _db.collection('entrepreneurs').doc(uid).update({
      'profilePhotoUrl': newUrl,
    });
  }

  // update id photo url
  Future<void> updateEntrepreneurNationalIdUrl({
    required String uid,
    required String newUrl,
  }) async {
    await _db.collection('entrepreneurs').doc(uid).update({
      'idImageUrl': newUrl,
    });
  }

  // Delete entrepreneur
  Future<void> deleteEntrepreneur({required String uid}) async {
    await _db.collection('entrepreneurs').doc(uid).delete();
  }
}
