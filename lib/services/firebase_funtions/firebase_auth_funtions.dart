import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthFunction {
  FirebaseAuthFunction._privateConstructor();

  static final FirebaseAuthFunction instance =
      FirebaseAuthFunction._privateConstructor();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
  /// 3. SIGN UP WITH EMAIL, PASSWORD & NAME
  /// --------------------------------------------------
  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Create auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = userCredential.user;

      if (user == null) return null;

      // Save user data to Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'name': name.trim(),
        'role': 'viewer',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// --------------------------------------------------
  /// 4. SIGN OUT
  /// --------------------------------------------------
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// --------------------------------------------------
  /// 5. FORGOT PASSWORD
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
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password is too weak.';
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
