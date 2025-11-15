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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final user = snapshot.data;
        if (user == null) {
          return WelcomePage();
        }

        return FutureBuilder<String?>(
          future: _getUserType(user.uid),
          builder: (context, typeSnapshot) {
            if (typeSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            final userType = typeSnapshot.data;
            if (userType == 'investor') {
              return const InvestorMainScreen();
            }
            if (userType == 'entrepreneur') {
              return const EntrepreneurMainScreen();
            }

            return WelcomePage();
          },
        );
      },
    );
  }

  Future<String?> _getUserType(String uid) async {
    final investorDoc = await _firestore.collection('investors').doc(uid).get();
    if (investorDoc.exists) return 'investor';

    final entrepreneurDoc =
        await _firestore.collection('entrepreneurs').doc(uid).get();
    if (entrepreneurDoc.exists) return 'entrepreneur';

    return null;
  }
}