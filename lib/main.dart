import 'package:flutter/material.dart';
import 'package:ecommerce_app/pages/HomePage.dart';
import 'package:ecommerce_app/pages/ItemPage.dart';
import 'package:ecommerce_app/pages/LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-commerce App', // Oferă un titlu pentru aplicația ta
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFCEDDEE),
        primarySwatch: Colors.blue,
      ),
      // Definește rutele care nu necesită parametri
      routes: {
        "/": (context) => LoginPage(), // Ruta implicită
        "homePage": (context) => HomePage(),
      },
      // Adaugă onGenerateRoute pentru a gestiona rutele care necesită parametri
      onGenerateRoute: (settings) {
        if (settings.name == 'itemPage') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ItemPage(imagePath: args['images/1.png']),
          );
        }
        // Aici poți adăuga alte rute care necesită parametri dacă este nevoie
        return null; // Returnează null dacă nu există niciun match pentru numele rutei
      },
    );
  }
}
