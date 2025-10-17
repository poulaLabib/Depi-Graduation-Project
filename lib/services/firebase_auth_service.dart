// register
// login
// logout
// static getter => current user
// update password
// update email
//delete user

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
  // --- Update Password ---
  Future<void> updatePassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword.trim());
        await user.reload(); // refresh user info
        print("Password updated successfully");
      } else {
        throw FirebaseAuthException(
          code: "user-not-found",
          message: "No user currently signed in.",
        );
      }
    } on FirebaseAuthException catch (e) {
      print("Update Password Error: ${e.message}");
      rethrow;
    }
  }

  // --- Update Email ---
 Future<void> updateEmail(String newEmail) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.verifyBeforeUpdateEmail(newEmail.trim());
      print("Verification email sent to new email address.");
    } else {
      throw FirebaseAuthException(
        code: "user-not-found",
        message: "No user currently signed in.",
      );
    }
  } on FirebaseAuthException catch (e) {
    print("Update Email Error: ${e.message}");
    rethrow;
  }
}


  // --- Delete User ---
  Future<void> deleteUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        print("User deleted successfully");
      } else {
        throw FirebaseAuthException(
          code: "user-not-found",
          message: "No user currently signed in.",
        );
      }
    } on FirebaseAuthException catch (e) {
      print("Delete User Error: ${e.message}");
      rethrow;
    }
  }
}