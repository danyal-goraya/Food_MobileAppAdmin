import 'package:flutter/foundation.dart';
import 'package:food_delivery_admin/models/auth_model.dart';
import '../entities/user.dart';
import '../entities/product.dart';
import '../entities/order.dart';
import '../entities/invoice.dart';

// ==================== ADMIN AUTH PROVIDER ====================
class AdminAuthProvider extends ChangeNotifier {
  final AdminAuthModel _authModel;

  AdminAuthProvider(this._authModel);

  UserEntity? _currentAdmin;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  UserEntity? get currentAdmin => _currentAdmin;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final admin = await _authModel.register(
        name: name,
        email: email,
        password: password,
      );

      if (admin != null) {
        _currentAdmin = admin;
        _isAuthenticated = true;
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Registration failed. Email may already exist.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Registration error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final admin = await _authModel.login(email: email, password: password);

      if (admin != null) {
        _currentAdmin = admin;
        _isAuthenticated = true;
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid email or password.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authModel.logout();
      _currentAdmin = null;
      _isAuthenticated = false;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Logout error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      throw e; // Re-throw so UI can catch and handle
    }
  }

  Future<void> loadCurrentAdmin() async {
    _isLoading = true;
    notifyListeners();

    try {
      final admin = await _authModel.getCurrentAdmin();
      if (admin != null) {
        _currentAdmin = admin;
        _isAuthenticated = true;
      } else {
        _currentAdmin = null;
        _isAuthenticated = false;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _currentAdmin = null;
      _isAuthenticated = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
