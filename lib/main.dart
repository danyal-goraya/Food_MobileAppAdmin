// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import your service
import 'services/admin_supabase_service.dart';

// Import your models
import 'models/auth_model.dart';
import 'models/userdb.dart';
import 'models/productdb.dart';
import 'models/orderdb.dart' hide AdminOrderModel;
import 'models/invoicedb.dart';

// Import your providers
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/product_provider.dart';
import 'providers/order_provider.dart';
import 'providers/invoice_provider.dart';
import 'providers/admin_theme_provider.dart';

// Import theme
import 'config/admin_theme.dart';

// Import screens
import 'screens/admin_login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://ogkdtfigttrqjxaroxef.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9na2R0ZmlndHRycWp4YXJveGVmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM2MjY5NTUsImV4cCI6MjA3OTIwMjk1NX0.RWPENCUrtEsvqNFHzZldup3fyW6stH0R6rLM1NT38Eo',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a single instance of AdminSupabaseService to share across all models
    final supabaseService = AdminSupabaseService(Supabase.instance.client);

    return MultiProvider(
      providers: [
        // Theme Provider (no dependencies)
        ChangeNotifierProvider(create: (_) => AdminThemeProvider()),

        // Auth Provider with Auth Model (requires AdminSupabaseService)
        ChangeNotifierProvider(
          create: (_) {
            final authModel = AdminAuthModel(supabaseService);
            return AdminAuthProvider(authModel);
          },
        ),

        // User Provider with User Model (requires AdminSupabaseService)
        ChangeNotifierProvider(
          create: (_) {
            final userModel = AdminUserModel(supabaseService);
            return AdminUserProvider(userModel);
          },
        ),

        // Product Provider with Product Model (requires AdminSupabaseService)
        ChangeNotifierProvider(
          create: (_) {
            final productModel = AdminProductModel(supabaseService);
            return AdminProductProvider(productModel);
          },
        ),

        // Order Provider with Order Model (requires AdminSupabaseService)
        ChangeNotifierProvider(
          create: (_) {
            final orderModel = AdminOrderModel(supabaseService);
            return AdminOrderProvider(orderModel);
          },
        ),

        // Invoice Provider with Invoice Model (requires AdminSupabaseService)
        ChangeNotifierProvider(
          create: (_) {
            final invoiceModel = AdminInvoiceModel(supabaseService);
            return AdminInvoiceProvider(invoiceModel);
          },
        ),
      ],
      child: Consumer<AdminThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Food Delivery Admin Panel',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.isDarkMode
                ? AdminTheme.darkTheme
                : AdminTheme.brightTheme,
            home: const AdminLoginScreen(),
          );
        },
      ),
    );
  }
}

/*
EXPLANATION OF THE FIX:

1. Created a single AdminSupabaseService instance:
   final supabaseService = AdminSupabaseService();
   
   This ensures all models share the same service instance.

2. Each model constructor now receives the supabaseService:
   - AdminAuthModel(supabaseService)
   - AdminUserModel(supabaseService)
   - AdminProductModel(supabaseService)
   - AdminOrderModel(supabaseService)
   - AdminInvoiceModel(supabaseService)

3. Each provider receives its corresponding model:
   - AdminAuthProvider(authModel)
   - AdminUserProvider(userModel)
   - AdminProductProvider(productModel)
   - AdminOrderProvider(orderModel)
   - AdminInvoiceProvider(invoiceModel)

VERIFY YOUR MODEL CONSTRUCTORS LOOK LIKE THIS:
------------------------------------------------

// models/auth_model.dart
class AdminAuthModel {
  final AdminSupabaseService _supabaseService;
  AdminAuthModel(this._supabaseService);
  // methods...
}

// models/userdb.dart
class AdminUserModel {
  final AdminSupabaseService _supabaseService;
  AdminUserModel(this._supabaseService);
  // methods...
}

// models/productdb.dart
class AdminProductModel {
  final AdminSupabaseService _supabaseService;
  AdminProductModel(this._supabaseService);
  // methods...
}

// models/orderdb.dart
class AdminOrderModel {
  final AdminSupabaseService _supabaseService;
  AdminOrderModel(this._supabaseService);
  // methods...
}

// models/invoicedb.dart
class AdminInvoiceModel {
  final AdminSupabaseService _supabaseService;
  AdminInvoiceModel(this._supabaseService);
  // methods...
}

MAKE SURE YOUR AdminSupabaseService CLASS EXISTS:
--------------------------------------------------

// services/admin_supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminSupabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  
  // Auth methods
  Future<AuthResponse?> signUp({required String email, required String password}) async {
    // implementation
  }
  
  Future<AuthResponse?> signIn({required String email, required String password}) async {
    // implementation
  }
  
  Future<void> signOut() async {
    // implementation
  }
  
  User? get currentUser => _client.auth.currentUser;
  
  // Database methods
  Future<UserEntity?> createAdmin(Map<String, dynamic> data) async {
    // implementation
  }
  
  Future<UserEntity?> getAdminById(String id) async {
    // implementation
  }
  
  // Add all other CRUD methods for users, products, orders, invoices...
}

TROUBLESHOOTING:
----------------

If you still see red lines after this fix:

1. Run these commands:
   flutter clean
   flutter pub get
   
2. Restart your IDE/VS Code

3. Check that ALL your model files have the same constructor pattern:
   - They should accept AdminSupabaseService as a parameter
   - Store it in a private field: final AdminSupabaseService _supabaseService;

4. Verify the import path for AdminSupabaseService is correct:
   import 'services/admin_supabase_service.dart';
   
   (Adjust the path if your service is in a different location)

This should completely resolve all red line issues! ✅
*/
