import 'package:flutter/foundation.dart';
import 'package:food_delivery_admin/models/auth_model.dart';
import 'package:food_delivery_admin/models/userdb.dart';
import '../entities/user.dart';
import '../entities/product.dart';
import '../entities/order.dart';
import '../entities/invoice.dart';

// ==================== ADMIN USER PROVIDER ====================
class AdminUserProvider extends ChangeNotifier {
  final AdminUserModel _userModel;

  AdminUserProvider(this._userModel);

  List<UserEntity> _users = [];
  List<UserEntity> _filteredUsers = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  String _searchQuery = '';

  List<UserEntity> get users => _searchQuery.isEmpty ? _users : _filteredUsers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String get searchQuery => _searchQuery;
  bool get hasUsers => _users.isNotEmpty;

  List<UserEntity> get blockedUsers =>
      _users.where((user) => user.isBlocked).toList();

  Future<void> loadUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await _userModel.getAllUsers();
      _filteredUsers = List.from(_users);
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load users: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchUsers(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      _filteredUsers = List.from(_users);
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _filteredUsers = await _userModel.searchUsersByName(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Search failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> blockUser(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final user = await _userModel.blockUser(userId);

      if (user != null) {
        _successMessage = 'User blocked successfully!';
        await loadUsers();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to block user.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Block user error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> unblockUser(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final user = await _userModel.unblockUser(userId);

      if (user != null) {
        _successMessage = 'User unblocked successfully!';
        await loadUsers();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to unblock user.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Unblock user error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredUsers = List.from(_users);
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  Future<void> refreshUsers() async {
    await loadUsers();
  }
}
