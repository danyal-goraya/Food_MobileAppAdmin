import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/order_provider.dart';
import '../../config/admin_theme.dart';

class DashboardHomeScreen extends StatefulWidget {
  const DashboardHomeScreen({Key? key}) : super(key: key);

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final productProvider = Provider.of<AdminProductProvider>(
      context,
      listen: false,
    );
    final userProvider = Provider.of<AdminUserProvider>(context, listen: false);
    final orderProvider = Provider.of<AdminOrderProvider>(
      context,
      listen: false,
    );

    await Future.wait([
      productProvider.loadProducts(),
      userProvider.loadUsers(),
      orderProvider.loadAllOrders(),
    ]);
  }

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    // If user cancelled
    if (shouldLogout != true) return;
    if (!mounted) return;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Call logout from provider
      final authProvider = Provider.of<AdminAuthProvider>(
        context,
        listen: false,
      );

      await authProvider.logout();

      if (!mounted) return;

      // Close loading dialog
      Navigator.of(context).pop();

      // Navigate to login screen and remove all previous routes
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/admin/login', // Change this to your actual admin login route
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      // Close loading dialog
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Determine grid layout based on screen size
    int crossAxisCount = 1;
    double childAspectRatio = 1.5;

    if (screenWidth > 600) {
      crossAxisCount = 2;
      childAspectRatio = 1.3;
    }
    if (screenWidth > 900) {
      crossAxisCount = 3;
      childAspectRatio = 1.2;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loadDashboardData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, Admin!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: screenWidth < 600 ? 20 : 24,
                  ),
                ),
                const SizedBox(height: 24),
                Consumer3<
                  AdminProductProvider,
                  AdminUserProvider,
                  AdminOrderProvider
                >(
                  builder:
                      (
                        context,
                        productProvider,
                        userProvider,
                        orderProvider,
                        child,
                      ) {
                        // Calculate active orders (not delivered and not cancelled)
                        final activeOrders = orderProvider.orders
                            .where(
                              (order) =>
                                  order.status != 'delivered' &&
                                  order.status != 'cancelled',
                            )
                            .length;

                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: childAspectRatio,
                          children: [
                            _buildStatCard(
                              context,
                              'Total Products',
                              productProvider.products.length.toString(),
                              Icons.restaurant_menu,
                              Colors.orange,
                              productProvider.isLoading,
                            ),
                            _buildStatCard(
                              context,
                              'Total Users',
                              userProvider.users.length.toString(),
                              Icons.people,
                              Colors.blue,
                              userProvider.isLoading,
                            ),
                            _buildStatCard(
                              context,
                              'Active Orders',
                              activeOrders.toString(),
                              Icons.shopping_bag,
                              Colors.green,
                              orderProvider.isLoading,
                            ),
                          ],
                        );
                      },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    bool isLoading,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive sizing
    double iconSize = screenWidth < 600 ? 56 : 64;
    double valueFontSize = screenWidth < 600 ? 32 : 40;
    double titleFontSize = screenWidth < 600 ? 14 : 16;
    double cardPadding = screenWidth < 600 ? 20 : 24;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: color),
            const SizedBox(height: 16),
            isLoading
                ? CircularProgressIndicator(color: color)
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: valueFontSize,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
