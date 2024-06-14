import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/pages/ItemPage.dart'; // Asigură-te că adaugi importul corect pentru ItemPage

class AllItemsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtain the screen width and height for responsive sizing
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return GridView.count(
      crossAxisCount:
          width > 600 ? 4 : 2, // Adjust column count based on screen width
      childAspectRatio: (width / height) > 0.75 ? 0.75 : 0.68,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        for (int i = 1; i <= 4; i++)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemPage(
                      imagePath: "images/$i.png"), // Transmite calea imaginii
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.01),
              margin: EdgeInsets.all(width * 0.02),
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
              child: LayoutBuilder(
                // Use LayoutBuilder to calculate the size constraints
                builder: (context, constraints) {
                  return Column(
                    mainAxisSize:
                        MainAxisSize.min, // Use min size that children need
                    children: [
                      Expanded(
                        child: Image.asset(
                          "images/$i.png",
                          fit: BoxFit.contain, // Adjust the fit
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          "Nike Shoe",
                          style: TextStyle(
                            fontSize: width *
                                0.05, // Scale font size with screen width
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF475269),
                          ),
                          overflow:
                              TextOverflow.ellipsis, // Prevent text overflow
                        ),
                      ),
                      Text(
                        "New Nike Shoe for Men",
                        style: TextStyle(
                          fontSize: width * 0.035, // Smaller font size
                          color: Color(0xFF475269).withOpacity(0.7),
                        ),
                        overflow:
                            TextOverflow.ellipsis, // Prevent text overflow
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
