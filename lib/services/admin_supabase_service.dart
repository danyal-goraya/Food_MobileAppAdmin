import 'package:supabase_flutter/supabase_flutter.dart';
import '../entities/user.dart';
import '../entities/product.dart';
import '../entities/order.dart';
import '../entities/order_item.dart';
import '../entities/invoice.dart';

class AdminSupabaseService {
  final SupabaseClient _client;

  AdminSupabaseService(this._client);

  User? get currentUser => _client.auth.currentUser;

  // ==================== AUTHENTICATION ====================

  Future<AuthResponse?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      print('Admin sign up error: $e');
      return null;
    }
  }

  Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      print('Admin sign in error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      print('Admin sign out error: $e');
    }
  }

  // ==================== ADMIN USER OPERATIONS ====================

  Future<UserEntity?> createAdmin(Map<String, dynamic> adminData) async {
    try {
      final response = await _client
          .from('users')
          .insert(adminData)
          .select()
          .maybeSingle();

      if (response == null) return null;
      return UserEntity.fromJson(response);
    } catch (e) {
      print('Create admin error: $e');
      return null;
    }
  }

  Future<UserEntity?> getAdminById(String adminId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', adminId)
          .eq('role', 'admin')
          .maybeSingle();

      if (response == null) return null;
      return UserEntity.fromJson(response);
    } catch (e) {
      print('Get admin by ID error: $e');
      return null;
    }
  }

  // ==================== PRODUCT OPERATIONS ====================

  Future<ProductEntity?> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await _client
          .from('products')
          .insert(productData)
          .select()
          .maybeSingle();

      if (response == null) return null;
      return ProductEntity.fromJson(response);
    } catch (e) {
      print('Create product error: $e');
      return null;
    }
  }

  Future<ProductEntity?> updateProduct(
    String productId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _client
          .from('products')
          .update(updates)
          .eq('id', productId)
          .select()
          .maybeSingle();

      if (response == null) return null;
      return ProductEntity.fromJson(response);
    } catch (e) {
      print('Update product error: $e');
      return null;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      await _client.from('products').delete().eq('id', productId);
      return true;
    } catch (e) {
      print('Delete product error: $e');
      return false;
    }
  }

  Future<List<ProductEntity>> getAllProducts() async {
    try {
      final response = await _client
          .from('products')
          .select()
          .order('created_at', ascending: false);
      return (response as List)
          .map((json) => ProductEntity.fromJson(json))
          .toList();
    } catch (e) {
      print('Get all products error: $e');
      return [];
    }
  }

  Future<ProductEntity?> getProductById(String productId) async {
    try {
      final response = await _client
          .from('products')
          .select()
          .eq('id', productId)
          .maybeSingle();

      if (response == null) return null;
      return ProductEntity.fromJson(response);
    } catch (e) {
      print('Get product by ID error: $e');
      return null;
    }
  }

  // ==================== USER MANAGEMENT ====================

  Future<List<UserEntity>> getAllUsers() async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('role', 'user')
          .order('created_at', ascending: false);
      return (response as List)
          .map((json) => UserEntity.fromJson(json))
          .toList();
    } catch (e) {
      print('Get all users error: $e');
      return [];
    }
  }

  Future<UserEntity?> getUserById(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;
      return UserEntity.fromJson(response);
    } catch (e) {
      print('Get user by ID error: $e');
      return null;
    }
  }

  Future<List<UserEntity>> searchUsersByName(String query) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('role', 'user')
          .ilike('name', '%$query%')
          .order('created_at', ascending: false);
      return (response as List)
          .map((json) => UserEntity.fromJson(json))
          .toList();
    } catch (e) {
      print('Search users error: $e');
      return [];
    }
  }

  Future<UserEntity?> blockUser(String userId) async {
    try {
      final response = await _client
          .from('users')
          .update({'is_blocked': true})
          .eq('id', userId)
          .select()
          .maybeSingle();

      if (response == null) return null;
      return UserEntity.fromJson(response);
    } catch (e) {
      print('Block user error: $e');
      return null;
    }
  }

  Future<UserEntity?> unblockUser(String userId) async {
    try {
      final response = await _client
          .from('users')
          .update({'is_blocked': false})
          .eq('id', userId)
          .select()
          .maybeSingle();

      if (response == null) return null;
      return UserEntity.fromJson(response);
    } catch (e) {
      print('Unblock user error: $e');
      return null;
    }
  }

  // ==================== ORDER OPERATIONS ====================

  Future<List<OrderEntity>> getAllOrders() async {
    try {
      final response = await _client
          .from('orders')
          .select()
          .order('created_at', ascending: false);
      return (response as List)
          .map((json) => OrderEntity.fromJson(json))
          .toList();
    } catch (e) {
      print('Get all orders error: $e');
      return [];
    }
  }

  Future<List<OrderEntity>> getUserOrders(String userId) async {
    try {
      final response = await _client
          .from('orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return (response as List)
          .map((json) => OrderEntity.fromJson(json))
          .toList();
    } catch (e) {
      print('Get user orders error: $e');
      return [];
    }
  }

  Future<OrderEntity?> getOrderById(String orderId) async {
    try {
      final response = await _client
          .from('orders')
          .select()
          .eq('id', orderId)
          .maybeSingle();

      if (response == null) return null;
      return OrderEntity.fromJson(response);
    } catch (e) {
      print('Get order by ID error: $e');
      return null;
    }
  }

  Future<OrderEntity?> updateOrderStatus(String orderId, String status) async {
    try {
      final now = DateTime.now().toIso8601String();
      final updates = <String, dynamic>{'status': status};

      if (status == 'delivered') {
        updates['delivered_at'] = now;
      } else if (status == 'cancelled') {
        updates['cancelled_at'] = now;
      }

      final response = await _client
          .from('orders')
          .update(updates)
          .eq('id', orderId)
          .select()
          .maybeSingle();

      if (response == null) return null;

      // If order is delivered, update user's total_orders
      if (status == 'delivered') {
        final order = OrderEntity.fromJson(response);
        final user = await getUserById(order.userId);
        if (user != null) {
          await _client
              .from('users')
              .update({'total_orders': user.totalOrders + 1})
              .eq('id', order.userId);
        }
      }

      return OrderEntity.fromJson(response);
    } catch (e) {
      print('Update order status error: $e');
      return null;
    }
  }

  // ==================== ORDER ITEM OPERATIONS ====================

  Future<List<OrderItemEntity>> getOrderItems(String orderId) async {
    try {
      final response = await _client
          .from('order_items')
          .select()
          .eq('order_id', orderId);
      return (response as List)
          .map((json) => OrderItemEntity.fromJson(json))
          .toList();
    } catch (e) {
      print('Get order items error: $e');
      return [];
    }
  }

  // ==================== INVOICE OPERATIONS ====================

  Future<List<InvoiceEntity>> getAllInvoices() async {
    try {
      final response = await _client
          .from('invoices')
          .select()
          .order('generated_at', ascending: false);
      return (response as List)
          .map((json) => InvoiceEntity.fromJson(json))
          .toList();
    } catch (e) {
      print('Get all invoices error: $e');
      return [];
    }
  }

  Future<InvoiceEntity?> getInvoiceByOrderId(String orderId) async {
    try {
      final response = await _client
          .from('invoices')
          .select()
          .eq('order_id', orderId)
          .maybeSingle();

      if (response == null) return null;
      return InvoiceEntity.fromJson(response);
    } catch (e) {
      print('Get invoice by order ID error: $e');
      return null;
    }
  }
}
