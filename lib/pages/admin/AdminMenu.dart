import 'package:flutter/material.dart';

class AdminMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meniu Admin'),
        backgroundColor: Color(0xFF475269),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'UploadProductPage');
              },
              child: Card(
                elevation: 5.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add, size: 50.0, color: Colors.blue),
                    SizedBox(height: 10.0),
                    Text('Adăugare produs', style: TextStyle(fontSize: 16.0)),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'AllProductsAdminPage');
              },
              child: Card(
                elevation: 5.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.shopping_cart, size: 50.0, color: Colors.blue),
                    SizedBox(height: 10.0),
                    Text('Vizualizare produse',
                        style: TextStyle(fontSize: 16.0)),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Adaugă acțiunea dorită pentru acest buton
              },
              child: Card(
                elevation: 5.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.list, size: 50.0, color: Colors.blue),
                    SizedBox(height: 10.0),
                    Text('Vizualizare comenzi',
                        style: TextStyle(fontSize: 16.0)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
