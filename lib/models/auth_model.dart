import '../entities/user.dart';
import '../entities/product.dart';
import '../entities/order.dart';
import '../entities/order_item.dart';
import '../entities/invoice.dart';
import '../services/admin_supabase_service.dart';

// ==================== ADMIN AUTH MODEL ====================
class AdminAuthModel {
  final AdminSupabaseService _supabaseService;

  AdminAuthModel(this._supabaseService);

  Future<UserEntity?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await _supabaseService.signUp(
        email: email,
        password: password,
      );

      if (authResponse == null || authResponse.user == null) {
        print('Admin auth signup failed');
        return null;
      }

      final adminId = authResponse.user!.id;
      final adminData = {
        'id': adminId,
        'name': name,
        'email': email,
        'role': 'admin',
        'total_orders': 0,
        'cancellation_count': 0,
        'user_category': 'Bronze',
        'discount_percentage': 0.0,
        'is_blocked': false,
      };

      final adminEntity = await _supabaseService.createAdmin(adminData);
      if (adminEntity == null) {
        print('Failed to create admin record in database');
        return null;
      }

      return adminEntity;
    } catch (e) {
      print('Admin registration error: $e');
      return null;
    }
  }

  Future<UserEntity?> login({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await _supabaseService.signIn(
        email: email,
        password: password,
      );

      if (authResponse == null || authResponse.user == null) {
        print('Admin auth signin failed');
        return null;
      }

      final adminId = authResponse.user!.id;
      final adminEntity = await _supabaseService.getAdminById(adminId);

      return adminEntity;
    } catch (e) {
      print('Admin login error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await _supabaseService.signOut();
  }

  Future<UserEntity?> getCurrentAdmin() async {
    try {
      final currentUser = _supabaseService.currentUser;
      if (currentUser == null) return null;

      final adminEntity = await _supabaseService.getAdminById(currentUser.id);
      return adminEntity;
    } catch (e) {
      print('Get current admin error: $e');
      return null;
    }
  }
}
