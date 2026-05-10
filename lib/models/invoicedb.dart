import '../entities/user.dart';
import '../entities/product.dart';
import '../entities/order.dart';
import '../entities/order_item.dart';
import '../entities/invoice.dart';
import '../services/admin_supabase_service.dart';

class AdminInvoiceModel {
  final AdminSupabaseService _supabaseService;

  AdminInvoiceModel(this._supabaseService);

  Future<List<InvoiceEntity>> getAllInvoices() async {
    try {
      return await _supabaseService.getAllInvoices();
    } catch (e) {
      print('Get all invoices error: $e');
      return [];
    }
  }

  Future<InvoiceEntity?> getInvoiceByOrderId(String orderId) async {
    try {
      return await _supabaseService.getInvoiceByOrderId(orderId);
    } catch (e) {
      print('Get invoice by order ID error: $e');
      return null;
    }
  }

  String formatInvoiceNumber(String invoiceId) {
    return 'INV-${invoiceId.substring(0, 8).toUpperCase()}';
  }

  String formatCurrency(double amount) {
    return 'Rs.${amount.toStringAsFixed(2)}';
  }

  String formatInvoiceDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
