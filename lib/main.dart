import 'package:ecommerce_app/pages/admin/UpdateProductPage.dart';
import 'package:ecommerce_app/pages/admin/UploadProductPage.dart';
import 'package:ecommerce_app/pages/users/ChatPage.dart';
import 'package:ecommerce_app/widgets/CartProvider.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/pages/users/HomePage.dart';
import 'package:ecommerce_app/pages/users/ItemPage.dart';
import 'package:ecommerce_app/pages/users/LoginPage.dart';
import 'package:ecommerce_app/pages/admin/AdminMenu.dart';
import 'package:ecommerce_app/pages/users/SignUpPage.dart';
import 'package:ecommerce_app/pages/users/MenProducts.dart';
import 'package:ecommerce_app/pages/users/WomenProducts.dart';
import 'package:ecommerce_app/pages/users/ChildrenProducts.dart';
import 'package:ecommerce_app/pages/admin/AllProductsAdminPage.dart';
import 'package:ecommerce_app/pages/payment/CheckOutPage.dart';
import 'package:ecommerce_app/pages/payment/stripe_service.dart'; // Import StripeService
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/providers/users_provider.dart';
import 'package:ecommerce_app/providers/categories_provider.dart';
import 'package:ecommerce_app/providers/address_provider.dart';
import 'package:ecommerce_app/providers/order_provider.dart'; // Import OrderProvider
import 'package:ecommerce_app/providers/order_details_provider.dart'; // Import OrderDetailsProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  CategoriesProvider categoriesProvider = CategoriesProvider();
  await categoriesProvider.addDefaultCategories();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(
            create: (_) => OrderProvider()), // Add OrderProvider
        ChangeNotifierProvider(
            create: (_) => OrderDetailsProvider()), // Add OrderDetailsProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-commerce App',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFCEDDEE),
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (context) => LoginPage(),
        "homePage": (context) => HomePage(),
        "UploadProductPage": (context) => UploadProductPage(),
        "AdminMenu": (context) => AdminMenu(),
        "SignUpPage": (context) => SignUpPage(),
        "MenProducts": (context) => MenProducts(),
        "WomenProducts": (context) => WomenProducts(),
        "ChildrenProducts": (context) => ChildrenProducts(),
        "AllProductsAdminPage": (context) => AllProductsAdminPage(),
        "CheckOutPage": (context) => CheckOutPage(),
        "ChatPage": (context) =>
            ChatPage(userID: 'user123'), // Adăugăm ruta pentru ChatPage
      },
      onGenerateRoute: (settings) {
        if (settings.name == 'itemPage') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ItemPage(
              imagePath: args['imagePath'] ?? 'https://via.placeholder.com/150',
              productName: args['productName'] ?? 'No Name',
              productDescription:
                  args['productDescription'] ?? 'No description available',
              productPrice: args['productPrice'] ?? 0.0,
            ),
          );
        }
        if (settings.name == 'UpdateProductPage') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => UpdateProductPage(
              productId: args['productId'],
              imageUrl: args['imageUrl'],
              productName: args['productName'],
              productDescription: args['productDescription'],
              productPrice: args['productPrice'],
            ),
          );
        }
        return null;
      },
    );
  }
}
