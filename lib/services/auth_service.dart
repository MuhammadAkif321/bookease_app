import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  // Firebase instance
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Auth state stream
  static Stream<User?> get authStateChanges =>
      _auth.authStateChanges();

  // Register with email & password
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential =
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Update display name
      await credential.user?.updateDisplayName(name.trim());
      await credential.user?.reload();

      return {
        'success': true,
        'message': 'Account created successfully!',
        'user': credential.user,
      };
    } on FirebaseAuthException catch (e) {
      return {
        'success': false,
        'message': _getErrorMessage(e.code),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Something went wrong. Try again!',
      };
    }
  }

  // Login with email & password
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential =
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      return {
        'success': true,
        'message': 'Login successful!',
        'user': credential.user,
      };
    } on FirebaseAuthException catch (e) {
      return {
        'success': false,
        'message': _getErrorMessage(e.code),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Something went wrong. Try again!',
      };
    }
  }

  // Logout
  static Future<void> logout() async {
    await _auth.signOut();
  }

  // Reset password
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );
      return {
        'success': true,
        'message': 'Password reset email sent!',
      };
    } on FirebaseAuthException catch (e) {
      return {
        'success': false,
        'message': _getErrorMessage(e.code),
      };
    }
  }

  // Error messages in simple English
  static String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered!';
      case 'invalid-email':
        return 'Please enter a valid email!';
      case 'weak-password':
        return 'Password must be at least 6 characters!';
      case 'user-not-found':
        return 'No account found with this email!';
      case 'wrong-password':
        return 'Incorrect password. Try again!';
      case 'too-many-requests':
        return 'Too many attempts. Try later!';
      case 'network-request-failed':
        return 'No internet connection!';
      default:
        return 'Something went wrong. Try again!';
    }
  }
}