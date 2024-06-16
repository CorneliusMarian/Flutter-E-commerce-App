import 'dart:io';
import 'package:ecommerce_app/widgets/CartProvider.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:ecommerce_app/widgets/AllItemsWidget.dart';
import 'package:ecommerce_app/widgets/HomeBottomNavBar.dart';
import 'package:ecommerce_app/widgets/RowItemsWidget.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Închide drawer-ul
                Navigator.pushNamed(context, "homePage");
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Închide drawer-ul
              },
            ),
            ExpansionTile(
              leading: Icon(Icons.category),
              title: Text('Categorii'),
              children: <Widget>[
                ListTile(
                  title: Text('Barbati'),
                  onTap: () {
                    Navigator.pop(context); // Închide drawer-ul
                    // Navighează la pagina corespunzătoare
                  },
                ),
                ListTile(
                  title: Text('Femei'),
                  onTap: () {
                    Navigator.pop(context); // Închide drawer-ul
                    // Navighează la pagina corespunzătoare
                  },
                ),
                ListTile(
                  title: Text('Copii'),
                  onTap: () {
                    Navigator.pop(context); // Închide drawer-ul
                    // Navighează la pagina corespunzătoare
                  },
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Închide drawer-ul
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context); // Închide drawer-ul
                Navigator.pushNamed(context, "/");
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFF5F9FD),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF475269).withOpacity(0.3),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.sort,
                          size: 30,
                          color: Color(0xFF475269),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF5F9FD),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF475269).withOpacity(0.3),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: badges.Badge(
                        badgeContent: Text(
                          "${Provider.of<CartProvider>(context).itemCount}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        badgeStyle: badges.BadgeStyle(
                          badgeColor: Colors.redAccent,
                          padding: EdgeInsets.all(7),
                        ),
                        child: Icon(
                          Icons.notifications,
                          size: 30,
                          color: Color(0xFF475269),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: 55,
                decoration: BoxDecoration(
                  color: Color(0xFFF5F9FD),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF475269).withOpacity(0.3),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 300,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search",
                        ),
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.search,
                      size: 27,
                      color: Color(0xFF475269),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              RowItemsWidget(),
              SizedBox(height: 20),
              AllItemsWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNavBar(),
    );
  }
}
