import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthFunction {
  FirebaseAuthFunction._privateConstructor();

  static final FirebaseAuthFunction instance =
      FirebaseAuthFunction._privateConstructor();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// --------------------------------------------------
  /// 1. AUTH STATE STREAM
  /// true  -> user logged in
  /// false -> user logged out
  /// --------------------------------------------------
  Stream<bool> authStateStream() {
    return _auth.authStateChanges().map((User? user) {
      return user != null;
    });
  }

  /// --------------------------------------------------
  /// 2. LOGIN WITH EMAIL & PASSWORD
  /// --------------------------------------------------
  Future<User?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// --------------------------------------------------
  /// 3. SIGN OUT
  /// --------------------------------------------------
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// --------------------------------------------------
  /// 4. FORGOT PASSWORD
  /// --------------------------------------------------
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// --------------------------------------------------
  /// ERROR HANDLING (HUMAN READABLE)
  /// --------------------------------------------------
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      default:
        return e.message ?? 'Authentication error occurred.';
    }
  }
}
