import 'package:ecommerce_app/widgets/BottomCartSheet.dart';
import 'package:ecommerce_app/widgets/CartProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

class HomeBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return BottomAppBar(
      child: Container(
        color: Color(0xFFF5F9FD),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {},
            ),
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    showSlidingBottomSheet(context, builder: (context) {
                      return SlidingSheetDialog(
                        elevation: 8,
                        cornerRadius: 16,
                        builder: (context, state) {
                          return BottomCartSheet();
                        },
                      );
                    });
                  },
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
