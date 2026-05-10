import 'package:flutter/foundation.dart';
import 'package:food_delivery_admin/models/productdb.dart';
import '../entities/user.dart';
import '../entities/product.dart';
import '../entities/order.dart';
import '../entities/invoice.dart';

class AdminProductProvider extends ChangeNotifier {
  final AdminProductModel _productModel;

  AdminProductProvider(this._productModel);

  List<ProductEntity> _products = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  List<ProductEntity> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get hasProducts => _products.isNotEmpty;

  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _productModel.getAllProducts();
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load products: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createProduct({
    required String name,
    required String description,
    required double price,
    required String category,
    required String imageUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final product = await _productModel.createProduct(
        name: name,
        description: description,
        price: price,
        category: category,
        imageUrl: imageUrl,
      );

      if (product != null) {
        _successMessage = 'Product created successfully!';
        await loadProducts();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to create product.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Create product error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct({
    required String productId,
    String? name,
    String? description,
    double? price,
    String? category,
    String? imageUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final product = await _productModel.updateProduct(
        productId: productId,
        name: name,
        description: description,
        price: price,
        category: category,
        imageUrl: imageUrl,
      );

      if (product != null) {
        _successMessage = 'Product updated successfully!';
        await loadProducts();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to update product.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Update product error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final success = await _productModel.deleteProduct(productId);

      if (success) {
        _successMessage = 'Product deleted successfully!';
        await loadProducts();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to delete product.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Delete product error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  String formatPrice(double price) {
    return _productModel.formatPrice(price);
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }

  Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    required String category,
    String? imageUrl,
  }) async {}
}
