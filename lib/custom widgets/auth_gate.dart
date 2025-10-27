import 'package:depi_graduation_project/screens/entrepreneur_main_screen.dart';
import 'package:depi_graduation_project/screens/investor_main_screen.dart';
import 'package:depi_graduation_project/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        setState(() {
          _user = null;
          _userType = null;
          _isLoading = false;
        });
      } else {
        final type = await _getUserType(user.uid);
        if (mounted) {
          setState(() {
            _user = user;
            _userType = type;
            _isLoading = false;
          });
        }
      }
    });
  }

  Future<String?> _getUserType(String uid) async {
    final investorDoc = await _firestore.collection('investors').doc(uid).get();
    if (investorDoc.exists) return 'investor';

    final entrepreneurDoc =
        await _firestore.collection('entrepreneurs').doc(uid).get();
    if (entrepreneurDoc.exists) return 'entrepreneur';

    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_user == null) return WelcomePage();

    if (_userType == 'investor') return const InvestorMainScreen();
    if (_userType == 'entrepreneur') return const EntrepreneurMainScreen();

    return WelcomePage();
  }
}