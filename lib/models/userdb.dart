import '../entities/user.dart';
import '../entities/product.dart';
import '../entities/order.dart';
import '../entities/order_item.dart';
import '../entities/invoice.dart';
import '../services/admin_supabase_service.dart';

class AdminUserModel {
  final AdminSupabaseService _supabaseService;

  AdminUserModel(this._supabaseService);

  Future<List<UserEntity>> getAllUsers() async {
    try {
      return await _supabaseService.getAllUsers();
    } catch (e) {
      print('Get all users error: $e');
      return [];
    }
  }

  Future<UserEntity?> getUserById(String userId) async {
    try {
      return await _supabaseService.getUserById(userId);
    } catch (e) {
      print('Get user by ID error: $e');
      return null;
    }
  }

  Future<List<UserEntity>> searchUsersByName(String query) async {
    try {
      return await _supabaseService.searchUsersByName(query);
    } catch (e) {
      print('Search users error: $e');
      return [];
    }
  }

  Future<UserEntity?> blockUser(String userId) async {
    try {
      return await _supabaseService.blockUser(userId);
    } catch (e) {
      print('Block user error: $e');
      return null;
    }
  }

  Future<UserEntity?> unblockUser(String userId) async {
    try {
      return await _supabaseService.unblockUser(userId);
    } catch (e) {
      print('Unblock user error: $e');
      return null;
    }
  }

  Future<List<UserEntity>> getBlockedUsers() async {
    try {
      final allUsers = await _supabaseService.getAllUsers();
      return allUsers.where((user) => user.isBlocked).toList();
    } catch (e) {
      print('Get blocked users error: $e');
      return [];
    }
  }

  String getUserCategoryText(String category) {
    return category;
  }

  String getUserCategoryColor(String category) {
    switch (category) {
      case 'Bronze':
        return 'brown';
      case 'Silver':
        return 'grey';
      case 'Gold':
        return 'yellow';
      case 'Platinum':
        return 'purple';
      default:
        return 'grey';
    }
  }
}

// ==================== ADMIN ORDER MODEL ====================
class AdminOrderModel {
  final AdminSupabaseService _supabaseService;

  AdminOrderModel(this._supabaseService);

  Future<List<OrderEntity>> getAllOrders() async {
    try {
      return await _supabaseService.getAllOrders();
    } catch (e) {
      print('Get all orders error: $e');
      return [];
    }
  }

  Future<List<OrderEntity>> getUserOrders(String userId) async {
    try {
      return await _supabaseService.getUserOrders(userId);
    } catch (e) {
      print('Get user orders error: $e');
      return [];
    }
  }

  Future<OrderEntity?> getOrderById(String orderId) async {
    try {
      return await _supabaseService.getOrderById(orderId);
    } catch (e) {
      print('Get order by ID error: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getOrderItemsWithProducts(
    String orderId,
  ) async {
    try {
      final orderItems = await _supabaseService.getOrderItems(orderId);
      final itemsWithProducts = <Map<String, dynamic>>[];

      for (var item in orderItems) {
        final product = await _supabaseService.getProductById(item.productId);
        if (product != null) {
          itemsWithProducts.add({'orderItem': item, 'product': product});
        }
      }

      return itemsWithProducts;
    } catch (e) {
      print('Get order items with products error: $e');
      return [];
    }
  }

  Future<OrderEntity?> markOrderAsDelivered(String orderId) async {
    try {
      return await _supabaseService.updateOrderStatus(orderId, 'delivered');
    } catch (e) {
      print('Mark order as delivered error: $e');
      return null;
    }
  }

  Future<OrderEntity?> updateOrderStatus(String orderId, String status) async {
    try {
      return await _supabaseService.updateOrderStatus(orderId, status);
    } catch (e) {
      print('Update order status error: $e');
      return null;
    }
  }

  String getOrderStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'cancelled':
        return 'Cancelled';
      case 'delivered':
        return 'Delivered';
      default:
        return 'Unknown';
    }
  }

  String getOrderStatusColor(String status) {
    switch (status) {
      case 'pending':
        return 'blue';
      case 'confirmed':
        return 'orange';
      case 'delivered':
        return 'green';
      case 'cancelled':
        return 'red';
      default:
        return 'grey';
    }
  }

  String formatCurrency(double amount) {
    return 'Rs.${amount.toStringAsFixed(2)}';
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
