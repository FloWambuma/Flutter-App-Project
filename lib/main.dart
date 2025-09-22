import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_smart/admin/admin_dashboard.dart';
import 'package:shop_smart/admin/manage_products_screen.dart';
import 'package:shop_smart/consts/theme_data.dart';
import 'package:shop_smart/firebase_options.dart';
import 'package:shop_smart/providers/cart_provider.dart';
import 'package:shop_smart/providers/products_provider.dart';
import 'package:shop_smart/providers/theme_provider.dart';
import 'package:shop_smart/providers/user_provider.dart';
import 'package:shop_smart/providers/viewed_recently_provider.dart';
import 'package:shop_smart/providers/wishlist_provider.dart';
import 'package:shop_smart/root_screen.dart';
import 'package:shop_smart/screens/auth/forgot_password.dart';
import 'package:shop_smart/screens/auth/login_screen.dart';
import 'package:shop_smart/screens/auth/register_screen.dart';
import 'package:shop_smart/screens/cart/cart_screen.dart';
import 'package:shop_smart/screens/edit_upload_product_form.dart';
import 'package:shop_smart/screens/home_screen.dart';
import 'package:shop_smart/screens/inner_screen/orders/orders_screen.dart';
import 'package:shop_smart/screens/inner_screen/products_details.dart';
import 'package:shop_smart/screens/inner_screen/viewed_recently.dart';
import 'package:shop_smart/screens/inner_screen/wishlist.dart';
import 'package:shop_smart/screens/search_screen.dart';
import 'package:shop_smart/screens/user/user_dashboard.dart';

// ✅ Import the debug Firestore screen
import 'package:shop_smart/screens/debug_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => ViewedProdProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(
              isDarktheme: themeProvider.getIsDarkTheme,
              context: context,
            ),
            initialRoute: FirebaseAuth.instance.currentUser == null
                ? LoginScreen.routeName
                : RootScreen.routeName,
            routes: {
              LoginScreen.routeName: (context) => const LoginScreen(),
              RegisterScreen.routeName: (context) => const RegisterScreen(),
              RootScreen.routeName: (context) => const RootScreen(),
              CartScreen.routeName: (context) => const CartScreen(),
              HomeScreen.routeName: (context) => const HomeScreen(),
              ProductsDetailsScreen.routeName: (context) =>
                  const ProductsDetailsScreen(),
              ViewedRecently.routeName: (context) => const ViewedRecently(),
              WishlistScreen.routeName: (context) => const WishlistScreen(),
              OrdersScreenFree.routeName: (context) => const OrdersScreenFree(),
              ForgotPasswordScreen.routeName: (context) =>
                  const ForgotPasswordScreen(),
              SearchScreen.routeName: (context) => const SearchScreen(),
              DashboardScreen.routeName: (context) => const DashboardScreen(),
              EditOrUploadProductScreen.routeName: (context) =>
                  const EditOrUploadProductScreen(),
              UserDashboardScreen.routeName: (context) =>
                  const UserDashboardScreen(),
              ManageProductsScreen.routeName: (context) =>
                  const ManageProductsScreen(),

              // ✅ Added Firestore debug screen
              FirestoreDebugScreen.routeName: (context) =>
                  const FirestoreDebugScreen(),
            },
          );
        },
      ),
    );
  }
}
