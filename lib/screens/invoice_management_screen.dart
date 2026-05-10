import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/invoice_provider.dart';
import '../../entities/invoice.dart';

class InvoiceManagementScreen extends StatefulWidget {
  const InvoiceManagementScreen({Key? key}) : super(key: key);

  @override
  State<InvoiceManagementScreen> createState() =>
      _InvoiceManagementScreenState();
}

class _InvoiceManagementScreenState extends State<InvoiceManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminInvoiceProvider>(
        context,
        listen: false,
      ).loadAllInvoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AdminInvoiceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadAllInvoices(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.invoices.isEmpty) {
            return const Center(child: Text('No invoices found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.invoices.length,
            itemBuilder: (context, index) {
              final invoice = provider.invoices[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(
                    Icons.receipt_long,
                    size: 40,
                    color: Colors.orange,
                  ),
                  title: Text(provider.formatInvoiceNumber(invoice.id)),
                  subtitle: Text(
                    'Amount: ${provider.formatCurrency(invoice.totalAmount)}\nGenerated: ${provider.formatDate(invoice.generatedAt)}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () =>
                        _viewInvoiceDetails(context, invoice, provider),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final provider = Provider.of<AdminInvoiceProvider>(
            context,
            listen: false,
          );
          provider.refreshInvoices();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _viewInvoiceDetails(
    BuildContext context,
    InvoiceEntity invoice,
    AdminInvoiceProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(provider.formatInvoiceNumber(invoice.id)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Order ID', invoice.orderId.substring(0, 8)),
            _buildDetailRow(
              'Total Amount',
              provider.formatCurrency(invoice.totalAmount),
            ),
            _buildDetailRow(
              'Generated',
              provider.formatDate(invoice.generatedAt),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
