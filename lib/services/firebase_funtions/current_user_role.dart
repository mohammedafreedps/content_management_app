import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum UserRole { admin, editor, viewer }

class CurrentUserRole {
  CurrentUserRole._();
  static final CurrentUserRole instance = CurrentUserRole._();

  final ValueNotifier<UserRole> _role = ValueNotifier(UserRole.viewer);

  // ---------------- PUBLIC ----------------
  bool get isAdmin => _role.value == UserRole.admin;
  bool get isEditor => _role.value == UserRole.editor;
  bool get isViewer => _role.value == UserRole.viewer;

  bool get canUpload =>
      _role.value == UserRole.admin || _role.value == UserRole.admin;

  bool get canApprove => _role.value == UserRole.admin;

  ValueListenable<UserRole> get listenable => _role;

  // ---------------- INTERNAL ----------------
  Future<void> loadFromFirebase(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final roleStr = doc.data()?['role'];
    _role.value = _parseRole(roleStr);
  }

  void clear() {
    _role.value = UserRole.viewer;
  }

  UserRole _parseRole(String? role) {
    switch (role) {
      case 'admin':
        return UserRole.admin;
      case 'editor':
        return UserRole.editor;
      default:
        return UserRole.viewer;
    }
  }
}
