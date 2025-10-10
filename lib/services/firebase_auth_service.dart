// register
// login
// logout
// static getter => current user
// update password
// update email

import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //register
  Future<User?> register({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Register Error: ${e.message}");
      rethrow;
    }
  }

  //login
  Future<User?> login({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return result.user; 
    } on FirebaseAuthException catch (e) {
      print("Login Error: ${e.message}");
      rethrow; 
    }
  }

  //logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
      print("Logged Out Successfully");
    } catch (e) {
      print("Logout Error: $e");
      rethrow;
    }
  }
}