import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../constants/role_constants.dart';
import '../constants/collection_constants.dart';

class UserSessionProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String _errorMessage = '';

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  // Getter untuk peran
  bool get isAdmin => _currentUser?.role == RoleConstants.admin;
  bool get isTeacher => _currentUser?.role == RoleConstants.teacher;
  bool get isStudent => _currentUser?.role == RoleConstants.student;
  bool get isStaff => _currentUser?.role == RoleConstants.staff;
  bool get isPrincipal => _currentUser?.role == RoleConstants.principal;

  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Metode untuk memperbarui data pengguna
  Future<void> refreshUserData() async {
    if (_currentUser == null) return;

    try {
      setLoading(true);
      final userDoc =
          await FirebaseFirestore.instance
              .collection(Collections.users)
              .doc(_currentUser!.uid)
              .get();

      if (userDoc.exists) {
        _currentUser = UserModel.fromJson({
          ...userDoc.data()!,
          'uid': userDoc.id,
        });
      }
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
