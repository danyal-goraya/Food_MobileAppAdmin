import 'package:flutter/foundation.dart';
import 'package:food_delivery_admin/models/userdb.dart';
import '../entities/user.dart';
import '../entities/product.dart';
import '../entities/order.dart';
import '../entities/invoice.dart';

class AdminOrderProvider extends ChangeNotifier {
  final AdminOrderModel _orderModel;

  AdminOrderProvider(this._orderModel);

  List<OrderEntity> _orders = [];
  OrderEntity? _selectedOrder;
  List<Map<String, dynamic>> _selectedOrderItems = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  List<OrderEntity> get orders => _orders;
  OrderEntity? get selectedOrder => _selectedOrder;
  List<Map<String, dynamic>> get selectedOrderItems => _selectedOrderItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get hasOrders => _orders.isNotEmpty;

  List<OrderEntity> get confirmedOrders =>
      _orders.where((o) => o.status == 'confirmed').toList();
  List<OrderEntity> get deliveredOrders =>
      _orders.where((o) => o.status == 'delivered').toList();
  List<OrderEntity> get cancelledOrders =>
      _orders.where((o) => o.status == 'cancelled').toList();

  Future<void> loadAllOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orders = await _orderModel.getAllOrders();
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load orders: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserOrders(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orders = await _orderModel.getUserOrders(userId);
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load user orders: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadOrderDetails(String orderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedOrder = await _orderModel.getOrderById(orderId);
      if (_selectedOrder != null) {
        _selectedOrderItems = await _orderModel.getOrderItemsWithProducts(
          orderId,
        );
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load order details: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> markAsDelivered(String orderId) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final order = await _orderModel.markOrderAsDelivered(orderId);

      if (order != null) {
        _successMessage = 'Order marked as delivered!';
        await loadAllOrders();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to mark order as delivered.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Update order error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  String getOrderStatusText(String status) {
    return _orderModel.getOrderStatusText(status);
  }

  String getOrderStatusColor(String status) {
    return _orderModel.getOrderStatusColor(status);
  }

  String formatCurrency(double amount) {
    return _orderModel.formatCurrency(amount);
  }

  String formatDate(DateTime date) {
    return _orderModel.formatDate(date);
  }

  void clearSelectedOrder() {
    _selectedOrder = null;
    _selectedOrderItems = [];
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  Future<void> refreshOrders() async {
    await loadAllOrders();
  }

  void loadOrders() {}

  Future<void> updateOrderStatus(String orderId, String status) async {}

  void loadOrdersByUser(String value) {}
}
