import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_graduation_project/models/company.dart';
import 'package:depi_graduation_project/models/entrepreneur.dart';
import 'package:depi_graduation_project/models/investor.dart';
import 'package:depi_graduation_project/models/message.dart';
import 'package:depi_graduation_project/models/notification.dart';
import 'package:depi_graduation_project/models/request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Model Tests', () {
    group('Company Model', () {
      test('fromFireStore creates Company with correct values', () {
        final data = {
          'name': 'Test Company',
          'description': 'Test description',
          'founded': 2020,
          'teamSize': 10,
          'industry': 'Tech',
          'stage': 'Seed',
          'currency': 'USD',
          'location': 'New York',
          'teamMembers': [
            {'name': 'John', 'role': 'CEO'},
          ],
          'logoUrl': 'logo.jpg',
          'certificateUrl': 'cert.jpg',
        };

        final company = Company.fromFireStore(data, 'uid1');

        expect(company.uid, equals('uid1'));
        expect(company.name, equals('Test Company'));
        expect(company.description, equals('Test description'));
        expect(company.founded, equals(2020));
        expect(company.teamSize, equals(10));
        expect(company.industry, equals('Tech'));
        expect(company.stage, equals('Seed'));
        expect(company.currency, equals('USD'));
        expect(company.location, equals('New York'));
        expect(company.teamMembers.length, equals(1));
        expect(company.logoUrl, equals('logo.jpg'));
        expect(company.certificateUrl, equals('cert.jpg'));
      });

      test('fromFireStore handles missing fields with defaults', () {
        final data = <String, dynamic>{};
        final company = Company.fromFireStore(data, 'uid1');

        expect(company.name, equals(''));
        expect(company.founded, equals(0));
        expect(company.teamSize, equals(0));
        expect(company.teamMembers, isEmpty);
      });

      test('toMap converts Company to map correctly', () {
        final company = Company(
          uid: 'uid1',
          name: 'Test Company',
          description: 'Test description',
          founded: 2020,
          teamSize: 10,
          industry: 'Tech',
          stage: 'Seed',
          currency: 'USD',
          location: 'New York',
          teamMembers: [],
          logoUrl: 'logo.jpg',
          certificateUrl: 'cert.jpg',
        );

        final map = company.toMap();

        expect(map['name'], equals('Test Company'));
        expect(map['founded'], equals(2020));
        expect(map['teamSize'], equals(10));
        expect(map['industry'], equals('Tech'));
      });
    });

    group('Entrepreneur Model', () {
      test('fromFireStore creates Entrepreneur with correct values', () {
        final data = {
          'name': 'John Doe',
          'about': 'About John',
          'phoneNumber': '1234567890',
          'experience': '5 years',
          'skills': ['Flutter', 'Dart'],
          'role': 'Founder',
          'profileImageUrl': 'profile.jpg',
          'idImageUrl': 'id.jpg',
        };

        final entrepreneur = Entrepreneur.fromFireStore(data, 'uid1');

        expect(entrepreneur.uid, equals('uid1'));
        expect(entrepreneur.name, equals('John Doe'));
        expect(entrepreneur.skills, equals(['Flutter', 'Dart']));
        expect(entrepreneur.role, equals('Founder'));
      });

      test('copyWith creates new instance with updated values', () {
        final original = Entrepreneur(
          uid: 'uid1',
          name: 'John',
          about: 'About',
          phoneNumber: '123',
          experience: '5 years',
          skills: ['Flutter'],
          role: 'Founder',
          profileImageUrl: '',
          idImageUrl: '',
        );

        final updated = original.copyWith(
          name: 'Jane',
          skills: ['Flutter', 'Dart'],
        );

        expect(updated.name, equals('Jane'));
        expect(updated.skills, equals(['Flutter', 'Dart']));
        expect(updated.uid, equals('uid1'));
        expect(updated.role, equals('Founder'));
      });
    });

    group('Investor Model', () {
      test('fromFireStore creates Investor with correct values', () {
        final data = {
          'name': 'Investor Name',
          'about': 'About investor',
          'phoneNumber': '1234567890',
          'experience': '10 years',
          'skills': ['Finance'],
          'investmentCapacity': 100000,
          'preferredIndustries': ['Tech'],
          'investorType': 'Angel Investor',
          'nationalIdUrl': 'id.jpg',
          'photoUrl': 'photo.jpg',
        };

        final investor = Investor.fromFireStore(data, 'uid1');

        expect(investor.uid, equals('uid1'));
        expect(investor.name, equals('Investor Name'));
        expect(investor.investmentCapacity, equals(100000));
        expect(investor.preferredIndustries, equals(['Tech']));
        expect(investor.investorType, equals('Angel Investor'));
      });

      test('copyWith creates new instance with updated values', () {
        final original = Investor(
          uid: 'uid1',
          name: 'Investor',
          about: 'About',
          phoneNumber: '123',
          experience: '10 years',
          skills: ['Finance'],
          investmentCapacity: 50000,
          preferredIndustries: ['Tech'],
          investorType: 'Angel',
          nationalIdUrl: '',
          photoUrl: '',
        );

        final updated = original.copyWith(
          investmentCapacity: 100000,
          preferredIndustries: ['Tech', 'Healthcare'],
        );

        expect(updated.investmentCapacity, equals(100000));
        expect(updated.preferredIndustries, equals(['Tech', 'Healthcare']));
        expect(updated.uid, equals('uid1'));
      });
    });

    group('Message Model', () {
      test('fromMap creates Message with correct values', () {
        final map = {
          'id': 'msg1',
          'content': 'Hello',
          'senderId': 'uid1',
          'receiverId': 'uid2',
          'timeCreated': Timestamp.fromDate(DateTime(2024, 1, 1)),
          'isRead': false,
          'isEdited': false,
        };

        final message = Message.fromMap(map);

        expect(message.id, equals('msg1'));
        expect(message.content, equals('Hello'));
        expect(message.senderId, equals('uid1'));
        expect(message.receiverId, equals('uid2'));
        expect(message.isRead, equals(false));
        expect(message.isEdited, equals(false));
      });

      test('copyWith creates new instance with updated values', () {
        final original = Message(
          id: 'msg1',
          content: 'Hello',
          senderId: 'uid1',
          receiverId: 'uid2',
          timeCreated: DateTime.now(),
          isRead: false,
          isEdited: false,
        );

        final updated = original.copyWith(content: 'Updated', isRead: true);

        expect(updated.content, equals('Updated'));
        expect(updated.isRead, equals(true));
        expect(updated.id, equals('msg1'));
      });
    });

    group('NotificationModel', () {
      test('fromFireStore creates NotificationModel with correct values', () {
        final data = {
          'receiverId': 'uid1',
          'senderId': 'uid2',
          'senderName': 'Sender',
          'type': 'message',
          'message': 'Hello',
          'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          'isRead': false,
        };

        final notification = NotificationModel.fromFireStore(data, 'notif1');

        expect(notification.id, equals('notif1'));
        expect(notification.receiverId, equals('uid1'));
        expect(notification.senderId, equals('uid2'));
        expect(notification.senderName, equals('Sender'));
        expect(notification.type, equals('message'));
        expect(notification.message, equals('Hello'));
        expect(notification.isRead, equals(false));
      });
    });

    group('Request Model', () {
      test('fromFireStore creates Request with correct values', () {
        final data = {
          'uid': 'uid1',
          'description': 'Test request',
          'amountOfMoney': 10000.0,
          'equityInReturn': '10%',
          'whyAreYouRaising': 'Expansion',
          'submittedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
        };

        final request = Request.fromFireStore(data, 'req1');

        expect(request.requestId, equals('req1'));
        expect(request.uid, equals('uid1'));
        expect(request.description, equals('Test request'));
        expect(request.amountOfMoney, equals(10000.0));
        expect(request.equityInReturn, equals('10%'));
        expect(request.whyAreYouRaising, equals('Expansion'));
      });

      test('fromFireStore handles missing fields with defaults', () {
        final data = <String, dynamic>{};
        final request = Request.fromFireStore(data, 'req1');

        expect(request.uid, equals(''));
        expect(request.description, equals(''));
        expect(request.amountOfMoney, equals(0.0));
        expect(request.submittedAt, isNull);
      });
    });
  });
}
