import '../entities/user.dart';
import '../entities/product.dart';
import '../entities/order.dart';
import '../entities/order_item.dart';
import '../entities/invoice.dart';
import '../services/admin_supabase_service.dart';

// ==================== ADMIN PRODUCT MODEL ====================
class AdminProductModel {
  final AdminSupabaseService _supabaseService;

  AdminProductModel(this._supabaseService);

  Future<ProductEntity?> createProduct({
    required String name,
    required String description,
    required double price,
    required String category,
    required String imageUrl,
  }) async {
    try {
      final productData = {
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'image_url': imageUrl,
      };

      return await _supabaseService.createProduct(productData);
    } catch (e) {
      print('Create product error: $e');
      return null;
    }
  }

  Future<ProductEntity?> updateProduct({
    required String productId,
    String? name,
    String? description,
    double? price,
    String? category,
    String? imageUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (description != null) updates['description'] = description;
      if (price != null) updates['price'] = price;
      if (category != null) updates['category'] = category;
      if (imageUrl != null) updates['image_url'] = imageUrl;

      return await _supabaseService.updateProduct(productId, updates);
    } catch (e) {
      print('Update product error: $e');
      return null;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      return await _supabaseService.deleteProduct(productId);
    } catch (e) {
      print('Delete product error: $e');
      return false;
    }
  }

  Future<List<ProductEntity>> getAllProducts() async {
    try {
      return await _supabaseService.getAllProducts();
    } catch (e) {
      print('Get all products error: $e');
      return [];
    }
  }

  Future<ProductEntity?> getProductById(String productId) async {
    try {
      return await _supabaseService.getProductById(productId);
    } catch (e) {
      print('Get product by ID error: $e');
      return null;
    }
  }

  Future<List<String>> getAllCategories() async {
    try {
      final products = await _supabaseService.getAllProducts();
      final categories = products.map((p) => p.category).toSet().toList();
      categories.sort();
      return categories;
    } catch (e) {
      print('Get categories error: $e');
      return [];
    }
  }

  String formatPrice(double price) {
    return 'Rs.${price.toStringAsFixed(2)}';
  }
}
