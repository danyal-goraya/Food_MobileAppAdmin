import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../entities/order.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({Key? key}) : super(key: key);

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminOrderProvider>(context, listen: false).loadAllOrders();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search orders by user ID',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    Provider.of<AdminOrderProvider>(
                      context,
                      listen: false,
                    ).loadAllOrders();
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  Provider.of<AdminOrderProvider>(
                    context,
                    listen: false,
                  ).loadUserOrders(value);
                }
              },
            ),
          ),
          Expanded(
            child: Consumer<AdminOrderProvider>(
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
                          onPressed: () => provider.loadAllOrders(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.orders.isEmpty) {
                  return const Center(child: Text('No orders found'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.orders.length,
                  itemBuilder: (context, index) {
                    final order = provider.orders[index];
                    final canDeliver =
                        order.status != 'delivered' &&
                        order.status != 'cancelled';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ExpansionTile(
                        leading: Icon(
                          _getStatusIcon(order.status),
                          color: _getStatusColor(order.status),
                        ),
                        title: Text('Order #${order.id.substring(0, 8)}'),
                        subtitle: Text(
                          'Total: ${provider.formatCurrency(order.totalPrice)} | ${provider.getOrderStatusText(order.status)}',
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('User ID: ${order.userId}'),
                                const SizedBox(height: 8),
                                Text(
                                  'Created: ${provider.formatDate(order.createdAt)}',
                                ),
                                if (order.confirmedAt != null)
                                  Text(
                                    'Confirmed: ${provider.formatDate(order.confirmedAt!)}',
                                  ),
                                if (order.deliveredAt != null)
                                  Text(
                                    'Delivered: ${provider.formatDate(order.deliveredAt!)}',
                                  ),
                                if (order.cancelledAt != null)
                                  Text(
                                    'Cancelled: ${provider.formatDate(order.cancelledAt!)}',
                                  ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: canDeliver
                                          ? () => _markAsDelivered(
                                              context,
                                              order.id,
                                            )
                                          : null,
                                      icon: const Icon(Icons.check_circle),
                                      label: const Text('Mark Delivered'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: canDeliver
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          _viewOrderDetails(context, order.id),
                                      icon: const Icon(Icons.visibility),
                                      label: const Text('View Details'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Icons.check_circle;
      case 'confirmed':
        return Icons.local_shipping;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.pending;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'confirmed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  void _markAsDelivered(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as Delivered'),
        content: const Text(
          'Are you sure you want to mark this order as delivered?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final provider = Provider.of<AdminOrderProvider>(
                context,
                listen: false,
              );
              final success = await provider.markAsDelivered(orderId);

              if (context.mounted) {
                Navigator.pop(context);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order marked as delivered successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _viewOrderDetails(BuildContext context, String orderId) async {
    // Show loading dialog first
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );

    final provider = Provider.of<AdminOrderProvider>(context, listen: false);
    await provider.loadOrderDetails(orderId);

    if (!context.mounted) return;

    // Close loading dialog
    Navigator.pop(context);

    final order = provider.selectedOrder;
    final items = provider.selectedOrderItems;

    if (order == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Could not load order details'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
      return;
    }

    // Show order details dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order #${order.id.substring(0, 8)}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total: ${provider.formatCurrency(order.totalPrice)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    _getStatusIcon(order.status),
                    color: _getStatusColor(order.status),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Status: ${provider.getOrderStatusText(order.status)}',
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('User ID: ${order.userId}'),
              const SizedBox(height: 4),
              Text('Created: ${provider.formatDate(order.createdAt)}'),
              if (order.confirmedAt != null)
                Text('Confirmed: ${provider.formatDate(order.confirmedAt!)}'),
              if (order.deliveredAt != null)
                Text('Delivered: ${provider.formatDate(order.deliveredAt!)}'),
              if (order.cancelledAt != null)
                Text('Cancelled: ${provider.formatDate(order.cancelledAt!)}'),
              const Divider(height: 24),
              const Text(
                'Order Items:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              if (items.isEmpty)
                const Text('No items found')
              else
                ...items.map(
                  (item) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['product_name'] ?? 'Unknown Product',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Quantity: ${item['quantity']}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            provider.formatCurrency(
                              item['price_at_purchase'] * item['quantity'],
                            ),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              provider.clearSelectedOrder();
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
