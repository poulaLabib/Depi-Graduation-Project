import 'package:depi_graduation_project/screens/entrepreneur_main_screen.dart';
import 'package:depi_graduation_project/screens/investor_main_screen.dart';
import 'package:depi_graduation_project/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _firestore = FirebaseFirestore.instance;
  User? _user;
  String? _userType;
  bool _isLoading = true;
  late final StreamSubscription<User?> _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(_handleAuthChange);
  }

  Future<void> _handleAuthChange(User? user) async {
    if (!mounted) return;

    if (user == null) {
      if (!mounted) return;
      setState(() {
        _user = null;
        _userType = null;
        _isLoading = false;
      });
    } else {
      String? type;
      try {
        type = await _getUserType(user.uid);
      } catch (e) {
        print('Error fetching user type: $e');
      }
      if (!mounted) return;
      setState(() {
        _user = user;
        _userType = type;
        _isLoading = false;
      });
    }
  }

  Future<String?> _getUserType(String uid) async {
    try {
      final investorDoc = await _firestore.collection('investors').doc(uid).get();
      if (investorDoc.exists) return 'investor';

      final entrepreneurDoc = await _firestore.collection('entrepreneurs').doc(uid).get();
      if (entrepreneurDoc.exists) return 'entrepreneur';
    } catch (e) {
      print('Firestore error in _getUserType: $e');
    }
    return null;
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_user == null) return Welcome();

    if (_userType == 'investor') return const InvestorMainScreen();
    if (_userType == 'entrepreneur') return const EntrepreneurMainScreen();

    return Welcome();
  }
}