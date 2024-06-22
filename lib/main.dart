import 'package:ecommerce_app/pages/UploadProductPage.dart';
import 'package:ecommerce_app/widgets/CartProvider.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/pages/HomePage.dart';
import 'package:ecommerce_app/pages/ItemPage.dart';
import 'package:ecommerce_app/pages/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/providers/categories_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Adăugăm categoriile implicite la inițializarea aplicației
  CategoriesProvider categoriesProvider = CategoriesProvider();
  await categoriesProvider.addDefaultCategories();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
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
        "/": (context) => LoginPage(), // Ruta implicită => UploadProductPage()
        "homePage": (context) => HomePage(),
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
        return null;
      },
    );
  }
}
