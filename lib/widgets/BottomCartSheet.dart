import 'package:ecommerce_app/widgets/CartProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomCartSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Material(
      child: Container(
        height: 600,
        padding: EdgeInsets.only(top: 20),
        color: Color(0xFFCEDDEE),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 500,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < cart.items.length; i++)
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 140,
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
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, "itemPage");
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10, right: 60),
                                    height: 90,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF475269),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  Image.network(
                                    cart.items[i]['image_url'],
                                    height: 130,
                                    width: 130,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    cart.items[i]['name'],
                                    style: TextStyle(
                                      color: Color(0xFF475269),
                                      fontSize: 23,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF5F9FD),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFF475269)
                                                  .withOpacity(0.3),
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          CupertinoIcons.minus,
                                          size: 18,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "01",
                                          style: TextStyle(
                                            color: Color(0xFF475269),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF5F9FD),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFF475269)
                                                  .withOpacity(0.3),
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          CupertinoIcons.add,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 25),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF475269)
                                              .withOpacity(0.4),
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        cart.removeItem(i);
                                      },
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "\$${cart.items[i]['price']}",
                                    style: TextStyle(
                                      color: Color(0xFF475269),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F9FD),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF475269).withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Delivery Fee:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF475269),
                                ),
                              ),
                              Text(
                                "\$20",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF475269),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 20,
                            thickness: 0.3,
                            color: Color(0xFF475269),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Sub-Total:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF475269),
                                ),
                              ),
                              Text(
                                "\$${cart.totalPrice}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF475269),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 20,
                            thickness: 0.5,
                            color: Color(0xFF475269),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Discount:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF475269),
                                ),
                              ),
                              Text(
                                "-\$10",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFFF5F9FD),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF475269),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xFF475269),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$${cart.totalPrice + 10}", // Total + delivery fee - discount
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      decoration: BoxDecoration(
                        color: Color(0xFF475269),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Check out",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
