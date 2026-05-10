import 'package:flutter/foundation.dart';
import 'package:food_delivery_admin/models/invoicedb.dart';
import '../entities/user.dart';
import '../entities/product.dart';
import '../entities/order.dart';
import '../entities/invoice.dart';
import '../models/auth_model.dart';

class AdminInvoiceProvider extends ChangeNotifier {
  final AdminInvoiceModel _invoiceModel;

  AdminInvoiceProvider(this._invoiceModel);

  List<InvoiceEntity> _invoices = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<InvoiceEntity> get invoices => _invoices;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasInvoices => _invoices.isNotEmpty;

  Future<void> loadAllInvoices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _invoices = await _invoiceModel.getAllInvoices();
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load invoices: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  String formatInvoiceNumber(String invoiceId) {
    return _invoiceModel.formatInvoiceNumber(invoiceId);
  }

  String formatCurrency(double amount) {
    return _invoiceModel.formatCurrency(amount);
  }

  String formatDate(DateTime date) {
    return _invoiceModel.formatInvoiceDate(date);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> refreshInvoices() async {
    await loadAllInvoices();
  }
}
