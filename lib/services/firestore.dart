import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_graduation_project/models/investor.dart';
import 'package:depi_graduation_project/models/request.dart';
import 'package:depi_graduation_project/models/company.dart';
import 'package:depi_graduation_project/models/entrepreneur.dart';
import 'package:depi_graduation_project/models/chat_room.dart';
import 'package:depi_graduation_project/models/message.dart';

// Global variable _db to access firestore functions to use in all 4 classes
final FirebaseFirestore _db = FirebaseFirestore.instance;

class InvestorFirestoreService {
  // Add investor
  Future<void> addInvestor({required String name, required String uid}) async {
    await _db.collection('investors').doc(uid).set({
      'name': name,
      'investorType': '',
      'photoUrl': '',
      'about': '',
      'phoneNumber': '',
      'experience': '',
      'skills': <String>[],
      'investmentCapacity': 0,
      'nationalIdUrl': '',
      'preferredIndustries': <String>[],
    });
  }

  // Update investor data all at once requires map<String, dynamic>
  Future<void> updateInvestor({
    required String uid,
    required Map<String, dynamic> updatedData,
  }) async {
    await _db.collection('investors').doc(uid).update(updatedData);
  }

  // Get stream of investor object => any thing changes in the firestore the investor changes as well, mainly for his profile page when he updates data.
  Stream<Investor> getInvestorStream({required String uid}) {
    return _db
        .collection('investors')
        .doc(uid)
        .snapshots()
        .map((snapshot) => Investor.fromFireStore(snapshot.data() ?? {}, uid));
  }

  Future<Investor> getInvestor({required String uid}) async {
    final doc = await _db.collection('investors').doc(uid).get();
    return Investor.fromFireStore(doc.data() ?? {}, uid);
  }

  // Get investor once

  // Get all investors as objects, for entrepreneur to see all investors
  Future<List<Investor>> getInvestors() async {
    final snapshot = await _db.collection('investors').get();
    return snapshot.docs.map((doc) {
      return Investor.fromFireStore(doc.data(), doc.id);
    }).toList();
  }

  // Update profile photo url
  Future<void> updateInvestorProfilePhotoUrl({
    required String uid,
    required String newUrl,
  }) async {
    await _db.collection('investors').doc(uid).update({'photoUrl': newUrl});
  }

  // Update id photo url
  Future<void> updateInvestorNationalIdUrl({
    required String uid,
    required String newUrl,
  }) async {
    await _db.collection('investors').doc(uid).update({
      'nationalIdUrl': newUrl,
    });
  }

  // Delete investor document in investors collection, used if investor deletes his account
  Future<void> deleteInvestor({required String uid}) async {
    await _db.collection('investors').doc(uid).delete();
  }
}

class RequestFirestoreService {
  //  Add request
  Future<void> addRequest({
    required String uid,
    required String description,
    required double amountOfMoney,
    required String equityInReturn,
    String? whyAreYouRaising,

  }) async {
    await _db.collection('requests').add({
      'uid': uid,
      'description': description,
      'amountOfMoney': amountOfMoney,
      'equityInReturn': equityInReturn,
      'whyAreYouRaising': whyAreYouRaising ?? '',
      'submittedAt': FieldValue.serverTimestamp(),
    });
  }

  //  Update request by document ID
  Future<void> updateRequest({
    required String requestId,
    required Map<String, dynamic> updatedData,
  }) async {
    await _db.collection('requests').doc(requestId).update(updatedData);
  }

  //  Stream of user's requests
  Stream<List<Request>> getRequestsStream({required String uid}) {
    return _db
        .collection('requests')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Request.fromFireStore(doc.data(), doc.id))
                  .toList(),
        );

  }

  //  Get all requests
  Future<List<Request>> getRequests() async {
    final snapshot = await _db.collection('requests').get();
    return snapshot.docs
        .map((doc) => Request.fromFireStore(doc.data(), doc.id))
        .toList();
  }

  // return stream of one request
  Stream<Request?> getRequest(String uid, String requestId) {
    return _db.collection('requests').doc(requestId).snapshots().map((
      docSnapshot,
    ) {
      if (docSnapshot.exists) {
        return Request.fromFireStore(docSnapshot.data()!, docSnapshot.id);
      } else {
        return null;
      }
    });
  }

  //  Delete request by document ID
  Future<void> deleteRequest({required String requestId}) async {
    await _db.collection('requests').doc(requestId).delete();
  }
}

class CompanyFirestoreService {
  // Add company
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
      'logoUrl': '',
      'certificateUrl': '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Update company data all at once requires map<String, dynamic>
  Future<bool> updateCompany({
    required String uid,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      await _db
          .collection('companies')
          .doc(uid)
          .set(updatedData, SetOptions(merge: true));
      return true;
    } catch (e) {
      print('Error updating company: $e');
      return false;
    }
  }

  Future<bool> companyExists({required String uid}) async {
    final doc = await _db.collection('companies').doc(uid).get();
    return doc.exists;
  }

  Stream<Company> getCompanyStream({required String uid}) {
    return _db
        .collection('companies')
        .doc(uid)
        .snapshots()
        .map((snapshot) => Company.fromFireStore(snapshot.data() ?? {}, uid));
  }

  // get company once
  Future<Company> getCompany({required String uid}) async {
    final doc = await _db.collection('companies').doc(uid).get();
    return Company.fromFireStore(doc.data() ?? {}, uid);
  }

  // Get all companies as objects, for entrepreneur to see all companies
  Future<List<Company>> getCompanies() async {
    final snapshot = await _db.collection('companies').get();
    return snapshot.docs.map((doc) {
      return Company.fromFireStore(doc.data(), doc.id);
    }).toList();
  }

  // Update company logo url
  Future<void> updateCompanyLogoUrl({
    required String uid,
    required String newUrl,
  }) async {
    await _db.collection('companies').doc(uid).update({'logoUrl': newUrl});
  }

  // Update company certificate url
  Future<void> updateCompanyCertificateUrl({
    required String uid,
    required String newUrl,
  }) async {
    await _db.collection('companies').doc(uid).update({
      'certificateUrl': newUrl,
    });
  }

  // Delete company document in companies collection, used if company deletes his account
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

  // Get entrepreneur once
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

  // Update profile photo url
  Future<void> updateEntrepreneurProfilePhotoUrl({
    required String uid,
    required String newUrl,
  }) async {
    await _db.collection('entrepreneurs').doc(uid).update({
      'profileImageUrl': newUrl,
    });
  }

  // Update id photo url
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
class ChatRoomFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Chat Room Management

  Future<void> addOrGetChatRoom(String uid1, String uid2) async {
    final chatRooms = _firestore.collection('chatrooms');

    final chatRoomId = uid1.compareTo(uid2) <= 0 ? '${uid1}_$uid2' : '${uid2}_$uid1';
    final chatRoomDoc = chatRooms.doc(chatRoomId);
    final chatRoomSnap = await chatRoomDoc.get();
    if (!chatRoomSnap.exists) {
      await chatRoomDoc.set({
        'id': chatRoomId,
        'members': [uid1, uid2],
        'timeCreated': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> deleteChatRoom(String chatRoomId) async {
    final chatRoomRef = _firestore.collection('chatrooms').doc(chatRoomId);

    final messages = await chatRoomRef.collection('messages').get();
    for (var doc in messages.docs) {
      await doc.reference.delete();
    }

    await chatRoomRef.delete();
  }

  Stream<List<ChatRoom>> getChatRoomStream(String uid) {
    return _firestore
        .collection('chatrooms')
        .where('members', arrayContains: uid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatRoom.fromMap(doc.data()))
            .toList());
  }

  // Message Management

  Future<void> addMessage(
    String chatRoomId,
    String content,
    String senderId,
    String receiverId,
  ) async {
    final messageRef = _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc();

    final messageData = {
      'id': messageRef.id,
      'content': content,
      'senderId': senderId,
      'receiverId': receiverId,
      'timeCreated': FieldValue.serverTimestamp(),
      'isRead': false,
      'isEdited': false,
    };

    await messageRef.set(messageData);
    await updateLastMessage(chatRoomId, content);
  }

  Future<void> deleteMessage(String chatRoomId, String messageId) async {
    final messageRef = _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId);

    await messageRef.delete();
  }

  Future<void> updateMessage(
      String chatRoomId, String messageId, String newContent) async {
    final messageRef = _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId);

    await messageRef.update({
      'content': newContent,
      'isEdited': true,
    });
  }

  Stream<List<Message>> getMessagesStream(String chatRoomId) {
    return _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timeCreated', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList());
  }

  // Message States

  Future<void> toggleIsRead(
      String chatRoomId, String messageId, bool value) async {
    await _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .update({'isRead': value});
  }

  Future<void> toggleIsEdited(
      String chatRoomId, String messageId, bool value) async {
    await _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .update({'isEdited': value});
  }

  Future<void> markAllAsRead(String chatRoomId, String currentUserId) async {
    final unreadMessages = await _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('receiverId', isEqualTo: currentUserId)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in unreadMessages.docs) {
      await doc.reference.update({'isRead': true});
    }
  }

  // Chat room updates 

  Future<void> updateLastMessage(String chatRoomId, String content) async {
    await _firestore.collection('chatrooms').doc(chatRoomId).update({
      'lastMessage': content,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  // Unread messages tracking

  Stream<int> getUnreadCountStream(String uid) {
    return _firestore
        .collectionGroup('messages')
        .where('receiverId', isEqualTo: uid)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
