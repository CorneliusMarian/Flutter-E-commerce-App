import 'dart:convert'; // Importă acest pachet pentru decodificare Base64
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RowItemsWidget extends StatelessWidget {
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('Products');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: _productsCollection.limit(4).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading products'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No products available'));
        }

        final products = snapshot.data!.docs;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: products.map((product) {
              final productData = product.data() as Map<String, dynamic>;
              final imageBase64 = productData.containsKey('image_base64')
                  ? productData['image_base64']
                  : null;
              final imageBytes = imageBase64 != null
                  ? Base64Decoder().convert(imageBase64)
                  : null;
              final image = imageBytes != null
                  ? Image.memory(imageBytes)
                  : Image.network('https://via.placeholder.com/150');

              return Container(
                margin: EdgeInsets.only(top: 10, bottom: 10, left: 15),
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 170,
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
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20, right: 70),
                          height: 100,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Color(0xFF475269),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1.0, // Raportul aspectului imaginii
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: image,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            productData['name'] ?? 'No Name',
                            style: TextStyle(
                              color: Color(0xFF475269),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            minFontSize: 12,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          AutoSizeText(
                            productData['description'] ??
                                'No description available',
                            style: TextStyle(
                              color: Color(0xFF475269),
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            minFontSize: 12,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          Row(
                            children: [
                              AutoSizeText(
                                "\$${productData['price']?.toString() ?? '0.0'}",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                minFontSize: 12,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(width: 50),
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Color(0xFF475269),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  CupertinoIcons.cart_fill_badge_plus,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
